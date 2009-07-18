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

	import railk.as3.net.saver.file.FileSaver;	
	import com.adobe.images.PNGEncoder;
	
	
	public class VideoPlayer  
	{
		private var nc                  :NetConnection;
		private var stream              :NetStream;
		private var ticker				:Shape = new Shape();
		private var streamMetadata      :Object={};
		private var streamReady         :Boolean = false;
		private var streamBufferState   :Number = 0;
		private var previousBytesLoaded :Number = 0;
		private var previousBytesPLayed :Number = 0;
		private var bytesPlayed			:Number;
		private var bytesTotal			:Number;
		private var responseTime        :Number;
		private var loaded				:Number;
		private var played				:Number;
		private var time  				:String;
		
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
		private var volume				:SoundTransform;										
		private var share               :String
		
		
		
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
				Security.loadPolicyFile("http://+"domain+"/crossdomain.xml");
			}
			
			this.path = path;
			this.filename = filename;
			this.width = width;
			this.height = height;
			this.type = type;
			this.bufferSize = buffersize;
			
			//--Sharing the player + the exact .flv
			share = '<object width="'+width+'" height="'+height+'">';
			share += '<param name="allowscriptaccess" value="always" />';
			share += '< param name = "movie" value ="' + path + 'flash/'+name+'.swf" / >';
			share += '< embed src ="' + path + 'flash/'+name+'.swf" type="application/x-shockwave-flash"  allowscriptaccess="always" width="'+width+'" height="'+height+'" >';
			share += '</embed></object>';
			
			//connection
			nc = new NetConnection();
			nc.connect( ((type=='rtmp')?path:null) );
			stream = new NetStream( nc );
			volume = new SoundTransform();
			stream.soundTransform = volume;
			
			var customClient:Object = new Object();
			customClient.onMetaData = onVideoMetaData;
			customClient.onCuePoint = onVideoCuePoint;
			customClient.onPlayStatus = onVideoPlayStatus;
			stream.client = customClient;
			
			//-video
			video = new Video( width, height );
			video.attachNetStream ( stream );
				
			//--enable volume modification
			
			
			//--listeners
			initListeners();
			
			//--launch stream and apuse lecture
			stream.play( ((type=='rtmp')?filename:path+filename) );
			stream.seek(0);
			stream.togglePause();	
		}
		
		/**
		 * LISTENERS
		 */
		private function initListeners():void {
			ticker.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			stream.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
            stream.addEventListener( NetStatusEvent.NET_STATUS, manageEvent, false, 0, true );
            stream.addEventListener( Event.OPEN, manageEvent, false, 0, true );
			shape.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		private function delListeners():void {
			ticker.removeEventListener( Event.ENTER_FRAME, manageEvent );
			stream.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
            stream.removeEventListener( NetStatusEvent.NET_STATUS, manageEvent );
			shape.removeEventListener( Event.ENTER_FRAME, manageEvent );
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
		}
		
		public function pause():void {
			stream.togglePause();
		}
		
		public function replay():void {
			stream.seek(0);
		}
		
		public function seek(pos:Number,size:Number):void {
			stream.seek( (pos*streamMetadata.duration)/size );
		}
		
		public function volume(pos:Number, size:Number):void {
			volume.volume = (pos*100)/size;
			stream.soundTransform = volume;
		}
		
		public function downloadVideo():void {
			if(download) navigateToURL( new URLRequest( url ), '_blank' );
		}
		
		public function shareVideo():void {
			if(share) System.setClipboard( share );
		}
		
		public function screenshot( name:String ):void {
			var toSave:ByteArray;
			var bmp:BitmapData = new BitmapData( width, height );
			var saveImg:FileSaver = new FileSaver( name );
			
			bmp.draw( interfaceItemList.getNodeByName('videoContainer').data );
			toSave = PNGEncoder.encode( bmp );
			saveImg.create( 'local','assets\images',name, 'png', toSave, true );
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
				case ProgressEvent.PROGRESS :
				case Event.ENTER_FRAME :
					var timeElapsed:Number = getTimer()-startTime;
					var currentSpeed:Number = evt.bytesLoaded / (timeElapsed*.001);
					var downloadTimeLeft:Number = (evt.bytesLoaded-evt.bytesLoaded)/(currentSpeed*.8);
					var remainingBuffer:Number = streamMetadata.duration - loader.bufferLength ;
					var buffer = ( bufferSize * evt.bytesTotal ) / streamMetadata.duration;
					bytesPlayed = Math.round(( Math.round(loader.time) * evt.bytesTotal )/Math.round(streamMetadata.duration));
					
					if ( !bufferSize ) if ( remainingBuffer > downloadTimeLeft && evt.bytesLoaded > 8 ) streamReady();
					else {
						if ( !ready ) {
							if ( streamBufferState <= buffer ) streamBufferState += evt.bytesLoaded-previousBytesLoaded;
							else stream.togglePause();
						} else {
							if ( streamBufferState > buffer*.2 && (evt.bytesLoaded - bytesPlayed) >= loader.bufferLength ) streamBufferState = streamBufferState-(bytesPlayed-previousBytesPLayed);
							else stream.togglePause();
						}
					}	
					previousBytesLoaded = evt.bytesLoaded;
					previousBytesPLayed = bytesPlayed;
					bytesTotal = evt.bytesTotal;
					break;
			}
		}
	}	
}