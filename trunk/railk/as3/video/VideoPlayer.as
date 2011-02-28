/**
* Flvplayer engine rtmp/stream
* 
* @author Richard Rodney.
* @version 0.2
* 
*/

package railk.as3.video 
{	
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import railk.as3.event.CustomEvent;
	
	
	public class VideoPlayer extends EventDispatcher
	{
		private var nc                  :NetConnection;
		private var stream              :NetStream;
		private var ticker				:Shape = new Shape();
		private var streamMetadata      :Object={};
		private var ready         		:Boolean = false;
		private var streamBufferState   :Number = 0;
		private var previousBytesLoaded :Number = 0;
		private var previousBytesPLayed :Number = 0;
		private var bytesPlayed			:Number;
		private var bytesTotal			:Number;
		private var startTime           :Number;
		private var responseTime        :Number;
		private var time  				:String;
		private var loaded				:Number;
		
		private var url                  :String;
		private var path  				:String;
		private var filename  			:String;
		private var bufferSize       	:int;
		private var width          		:Number;
		private var height         		:Number;
		private var type 				:String;
		
		public var share         		:Boolean;
		public var download     		:Boolean;
		public var screenshot   		:Boolean;
		public var externalDomain       :Boolean;
		
		private var video 				:Video;
		private var sound				:SoundTransform;										
		private var shareTxt            :String
		
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function VideoPlayer() {}
		
		/**
		 * INIT
		 */
		public function init( share:Boolean = false, download:Boolean = false, screenshot:Boolean=false, externalDomain:Boolean=false ):void {
			this.download = download;
			this.screenshot = screenshot;
			this.share = share;
			this.externalDomain = externalDomain;
		}
		
		/**
		 * CREATE
		 * 
		 * @param	path
		 * @param	filename
		 * @param	width
		 * @param	height
		 * @param	buffersize
		 * @param	type		rtmp/stream
		 * @param	domain
		 */
		public function create(path:String, filename:String, width:Number, height:Number, buffersize:int=0, type:String='stream', domain:String='' ):void {
			if (externalDomain) {
				Security.allowDomain(domain);
				Security.loadPolicyFile("http://"+domain+"/crossdomain.xml");
			}
			
			this.url = path + filename;
			this.path = path;
			this.filename = filename;
			this.width = width;
			this.height = height;
			this.type = type;
			this.bufferSize = buffersize;
			execute();
		}
		
		private function execute():void {
			//connection
			nc = new NetConnection();
			nc.connect( ((type=='rtmp')?path:null) );
			stream = new NetStream( nc );
			sound = new SoundTransform();
			stream.soundTransform = sound;
			
			var customClient:Object = new Object();
			customClient.onMetaData = onVideoMetaData;
			customClient.onCuePoint = onVideoCuePoint;
			customClient.onPlayStatus = onVideoPlayStatus;
			stream.client = customClient;
			
			//-video
			video = new Video(width, height);
			video.width = width;
			video.height = height;
			video.attachNetStream ( stream );			
			
			//--listeners
			initListeners();
			
			//--launch stream and apuse lecture
			stream.play( ((type=='rtmp')?filename:path+filename+'?nocache='+int(Math.random()*100000*getTimer()+getTimer())) );
			stream.seek(0);
			stream.togglePause();	
		}
		
		/**
		 * LISTENERS
		 */
		private function initListeners():void {
			stream.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
            stream.addEventListener( NetStatusEvent.NET_STATUS, manageEvent, false, 0, true );
            stream.addEventListener( Event.OPEN, manageEvent, false, 0, true );
			ticker.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		private function delListeners():void {
			stream.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
            stream.removeEventListener( NetStatusEvent.NET_STATUS, manageEvent );
			ticker.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		/**
		 * META DATA
		 */
		private  function onVideoMetaData( metaData:Object ):void { streamMetadata = metaData; }
		private  function onVideoCuePoint( evt:* ):void { /*return evt;*/ }
		private  function onVideoPlayStatus( evt:* ):void { /*return evt;*/ }
		
		/**
		 * ACTIONS
		 */
		public function play():void {
			stream.togglePause();
			ticker.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		public function pause():void {
			stream.togglePause();
			ticker.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		public function stop():void {
			stream.seek(0);
			stream.pause();
			ticker.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		public function replay():void {
			ticker.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			stream.seek(0);
		}
		
		public function seek(pos:Number,size:Number):void {
			stream.seek( (pos*streamMetadata.duration)/size );
		}
		
		public function volume(pos:Number, size:Number):void {
			sound.volume = (pos*100)/size;
			stream.soundTransform = sound;
		}
		
		public function downloadVideo():void {
			if(download) navigateToURL( new URLRequest( url ), '_blank' );
		}
		
		public function shareVideo():void {
			if(share) System.setClipboard( shareTxt );
		}
		
		
		/**
		 * gestion du stream
		 */
		private function streamReady():void {
			if ( !ready ) {
				ready = true;
				dispatchEvent( new CustomEvent( "stream ready" ));
			}	
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void{
			delListeners();
			video = null;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function getVideo():Video { return video; }
		public function get duration():Number { return streamMetadata.duration; }
		public function get played():Number { return bytesPlayed; }
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( evt:*):void {
			switch( evt.type ) {
				case Event.OPEN :
					startTime = getTimer();
					break;
				case NetStatusEvent.NET_STATUS : switch( evt.info.code ){ case "NetStream.Play.Start" : responseTime = getTimer(); break;} break;
				case IOErrorEvent.IO_ERROR : break;
				case Event.ENTER_FRAME :
					var timeElapsed:Number = getTimer()-startTime;
					var currentSpeed:Number = stream.bytesLoaded / (timeElapsed*.001);
					var downloadTimeLeft:Number = (stream.bytesLoaded-stream.bytesLoaded)/(currentSpeed*.8);
					var remainingBuffer:Number = streamMetadata.duration - stream.bufferLength ;
					var buffer:Number = ( bufferSize * stream.bytesTotal ) / streamMetadata.duration;
					bytesPlayed = Math.round(( Math.round(stream.time) * stream.bytesTotal )/Math.round(streamMetadata.duration));
					
					if ( !bufferSize ) if ( remainingBuffer > downloadTimeLeft && evt.bytesLoaded > 8 ) streamReady();
					else {
						if ( !ready ) {
							if ( streamBufferState <= buffer ) streamBufferState += stream.bytesLoaded-previousBytesLoaded;
							else stream.togglePause();
						} else {
							if ( streamBufferState > buffer*.2 && (stream.bytesLoaded - bytesPlayed) >= stream.bufferLength ) streamBufferState = streamBufferState-(bytesPlayed-previousBytesPLayed);
							else stream.togglePause();
						}
					}	
					previousBytesLoaded = stream.bytesLoaded;
					previousBytesPLayed = bytesPlayed;
					bytesTotal = stream.bytesTotal;
					if ( bytesPlayed == bytesTotal ) {
						ticker.removeEventListener( Event.ENTER_FRAME, manageEvent );
						dispatchEvent( new VideoPlayerEvent( VideoPlayerEvent.ON_COMPLETE ));
					}
					dispatchEvent( new VideoPlayerEvent(VideoPlayerEvent.ON_PROGRESS, { percentLoaded:(stream.bytesLoaded / stream.bytesTotal) * 100, percentPlayed:(bytesPlayed / bytesTotal) * 100 } ));
					break;
				default : break;
			}
		}
	}	
}