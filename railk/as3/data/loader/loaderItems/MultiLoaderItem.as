/**
* 
* MultiLoaderItem class
* 
* @author richard rodney
* @version 0.1
*/

package railk.as3.data.loader.loaderItems {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
    import flash.system.LoaderContext;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	// ____________________________________________________________________________________ IMPORT MULTILOADER
	import railk.as3.data.loader.MultiLoaderEvent;

	

	public class  MultiLoaderItem extends EventDispatcher {
		
		// ___________________________________________________________________________________ CONSTANTES TYPE
		public static const IMGFILE                  :String = "imgfile";
        public static const SWFFILE                  :String = "swffile";
        public static const XMLFILE                  :String = "xmlfile";
		public static const	TXTFILE                  :String = "txtfile";
		public static const	BINARYFILE               :String = "binaryfile";
        public static const FLVFILE                  :String = "flvfile";
        public static const SOUNFFILE                :String = "soundfile";
		
		// ___________________________________________________________________________________ CONSTANTES STATE
		public static const LOADED                   :String = "loaded";
		public static const LOADING                  :String = "loading";
		public static const WAITING                  :String = "waiting";
		public static const FAILED                   :String = "failed";
		
		
		// ____________________________________________________________________________________ VARIABLES ITEMS
		private var item                             :MultiLoaderItem; 
		private var itemURL                          :URLRequest;
		private var itemName                         :String;
		private var itemMode                         :String;
		private var itemArgs                         :Object;
		private var itemPriority                     :int;
		private var itemType                         :String = MultiLoaderItem.WAITING;
		private var itemState                        :String;
		private var itemPreventCache                 :Boolean;
		private var itemSaveState                    :Boolean;
		private var itemContent                      :*;
		private var itemPercentLoaded                :Number = 0;
		private var itemBytesLoaded                  :Number;
		private var itemBytesTotal                   :Number;
		private var itemBytesLeft                    :Number;
		private var itemBytesPlayed                  :Number;
		private var itemResponseTime                 :Number;
		private var itemBufferSize                   :int;
		
		private var maxTries                         :int = 3;
		private var numTries                         :int = 0;	
		
		// ___________________________________________________________________________________ VARIABLES LOADER
		private var classTypes                       :Object = {
            "imgfile":Loader,
            "swffile":Loader,
            "xmlfile":URLLoader,
			"txtfile":URLLoader,
			"binaryfile":URLLoader,
            "flvfile":NetStream,
            "soundfile":Sound
        }
		private var dataFormats                      :Object = {
			"xmlfile":URLLoaderDataFormat.TEXT,
			"txtfile":URLLoaderDataFormat.TEXT,
			"binaryfile":URLLoaderDataFormat.BINARY
		}
		private var loaderClass                      :Class;
		private var loader                           :*;
		private var context                          :*;
		
		// _________________________________________________________________________________ VARIABLES STREAM
		private var ch                               :SoundChannel;
		private var nc                               :NetConnection;
		private var streamTriggerEvent               :Sprite;
		private var streamMedatada                   :Object;
		private var streamReady                      :Boolean = false;
		private var streamBufferState                :Number = 0;
		private var previousBytesLoaded              :Number = 0;
		private var previousBytesPLayed              :Number = 0;
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function MultiLoaderItem( url:URLRequest, name:String, args:Object, type:String, priority:int, state:String, preventCache:Boolean, bufferSize:int, saveState:Boolean, mode:String ):void {
			//--
			item = this;
			itemURL = url;
			itemName = name;
			itemMode = mode;
			itemArgs = args;
			itemType = type;
			itemPriority = priority;
			itemState = state;
			itemPreventCache = preventCache;
			itemBufferSize = bufferSize;
			itemSaveState = saveState;
			itemMode = mode;
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  LOADER MANAGMENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function load():void {
			//--
			if ( itemPreventCache == true ) {
				itemURL.url += "?dontCacheMe=" + int( Math.random()  * 100000 * getTimer() + getTimer() );
			}
			
			//--
			loaderClass = classTypes[itemType];
			if ( itemType == "flvfile" ) {
				nc = new NetConnection();
				nc.connect( null );
				loader = new loaderClass( nc );
			}
			else {
				loader = new loaderClass();
			}	
			initListeners( loader );
			
			
			//--
			if ( loader is Loader ) {
				if ( itemMode == 'sameDomain' ) context = new LoaderContext(true, ApplicationDomain.currentDomain);
				else if( itemMode == 'externalDomain' ) context = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
				loader.load( itemURL, context );
			}
			else if ( loader is URLLoader ) {
				loader.dataFormat = dataFormats[itemType];
				loader.load( itemURL );
			}
			else if ( loader is Sound ) {
				context = new SoundLoaderContext(3000,true);
                loader.load( itemURL , context );
			}
			else if ( loader is NetStream ) {
				streamTriggerEvent = new Sprite();
				streamTriggerEvent.addEventListener( Event.ENTER_FRAME, onStreamEvent, false, 0, true );
                var customClient:Object = new Object();
				customClient.onMetaData = onVideoMetaData;
                //customClient.onCuePoint = onVideoCuePoint;
                //customClient.onPlayStatus = onVideoPlayStatus;
                loader.client = customClient;
                loader.play( itemURL.url );
                loader.seek(0);
			}
		}
		
		
		public function stop():void {
			loader.close();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  LOADER LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners( loaderType:* ):void {
			//--
			if( loaderType is Loader ){
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onloadComplete, false, 0, true );
				loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onloadProgress, false, 0, true );
				loader.contentLoaderInfo.addEventListener( Event.OPEN, onloadBegin, false, 0, true );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onloadIOerror, false, 0, true );
				loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, onloadHttpStatus, false, 0, true );
			}
			else if ( loaderType is Sound ) {
				loader.addEventListener( Event.COMPLETE, onloadComplete, false, 0, true );
				loader.addEventListener( ProgressEvent.PROGRESS, onloadProgress, false, 0, true );
				loader.addEventListener( Event.OPEN, onloadBegin, false, 0, true );
				loader.addEventListener( IOErrorEvent.IO_ERROR, onloadIOerror, false, 0, true );
				loader.addEventListener( Event.ID3, onloadID3, false, 0, true );
			}
			else if ( loaderType is NetStream ) {
				loader.addEventListener( IOErrorEvent.IO_ERROR, onloadIOerror, false, 0, true );
                loader.addEventListener( NetStatusEvent.NET_STATUS, onloadNetStatus, false, 0, true );
			}
			else {
				loader.addEventListener( Event.COMPLETE, onloadComplete, false, 0, true );
				loader.addEventListener( ProgressEvent.PROGRESS, onloadProgress, false, 0, true );
				loader.addEventListener( Event.OPEN, onloadBegin, false, 0, true );
				loader.addEventListener( IOErrorEvent.IO_ERROR, onloadIOerror, false, 0, true );
				loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onloadHttpStatus, false, 0, true );
			}
		}
		
		private function delListeners( loaderType:* ):void {
			//--
			if( loaderType is Loader ){
				loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onloadComplete );
				loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onloadProgress );
				loader.contentLoaderInfo.removeEventListener( Event.OPEN, onloadBegin );
				loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onloadIOerror );
				loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onloadHttpStatus );
			}
			else if ( loaderType is Sound ) {
				loader.removeEventListener( Event.COMPLETE, onloadComplete );
				loader.removeEventListener( ProgressEvent.PROGRESS, onloadProgress );
				loader.removeEventListener( Event.OPEN, onloadBegin );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onloadIOerror );
				loader.removeEventListener( Event.ID3, onloadID3 );
			}
			else if ( loaderType is NetStream ) {
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onloadIOerror );
                loader.removeEventListener( NetStatusEvent.NET_STATUS, onloadNetStatus );
			}
			else {
				loader.removeEventListener( Event.COMPLETE, onloadComplete );
				loader.removeEventListener( ProgressEvent.PROGRESS, onloadProgress );
				loader.removeEventListener( Event.OPEN, onloadBegin );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onloadIOerror );
				loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onloadHttpStatus );
			}
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   LISTENERS FONCTIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function onStreamEvent( evt:Event ):void {
			//init
			var event:*;
			//--
			if ( loader.bytesLoaded == 0 ) {
				loader.pause();
				//////////////////////////////////////////////
				event = new Event( Event.OPEN );
                onloadBegin( event );
				//////////////////////////////////////////////
			}
			else if ( loader.bytesLoaded == itemBytesTotal ) {
				onStreamReady();
				//////////////////////////////////////////////
				event = new Event( Event.COMPLETE );
                onloadComplete( event);
				//////////////////////////////////////////////
			}
			else if ( Math.round(loader.time) == Math.round(streamMedatada.duration) ) {
				////////////////////////////////////////////
				streamTriggerEvent.removeEventListener( Event.ENTER_FRAME, onStreamEvent );
				////////////////////////////////////////////
				
				///////////////////////////////////////////////////////////////
				//arguments du messages
				var args:Object = { info:"stream playing finished", item:this };
				//envoie de l'evenement pour les listeners de uploader
				var eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMPLAYED, args );
				dispatchEvent( eEvent );
				///////////////////////////////////////////////////////////////
			}
			else {
				//////////////////////////////////////////////
				event = new ProgressEvent( ProgressEvent.PROGRESS, false, false, loader.bytesLoaded, loader.bytesTotal );
				onloadProgress( event );
				//////////////////////////////////////////////
			}
		}
		
		private function onStreamReady():void {
			//--
			if ( streamReady == false ) {
				
				streamReady = true;
				
				///////////////////////////////////////////////////////////////
				//arguments du messages
				var args:Object = { info:"stream ready to be played", item:this };
				//envoie de l'evenement pour les listeners de uploader
				var eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMREADY, args );
				dispatchEvent( eEvent );
				///////////////////////////////////////////////////////////////
				
			}	
		}
		
		private function onStreamBuffering():void {
			//--
			if ( streamReady == true ) {
				
				streamReady = false;
				
				///////////////////////////////////////////////////////////////
				//arguments du messages
				var args:Object = { info:"stream paused for buffering", item:this };
				//envoie de l'evenement pour les listeners de uploader
				var eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMBUFFERING, args );
				dispatchEvent( eEvent );
				///////////////////////////////////////////////////////////////
				
			}	
		}
		
		private function onSoundComplete( evt:Event ):void {			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"stream playing finished", item:this };
			//envoie de l'evenement pour les listeners de uploader
			var eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMPLAYED, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
			ch.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
		}
		
		
		
		private function onloadBegin( evt:Event ):void {
			
			itemResponseTime = getTimer();
			
			if ( loader is Sound ) {
				itemContent = loader;
				ch = loader.play();
				ch.stop();
			}
			
			//////////////////////////////////////////////
			itemState = MultiLoaderItem.LOADING;
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		private function onloadProgress( evt:ProgressEvent ):void {
			
			itemPercentLoaded = Math.round((evt.bytesLoaded * 100) / evt.bytesTotal);
			itemBytesLoaded = evt.bytesLoaded;
			itemBytesTotal = evt.bytesTotal;
			itemBytesLeft = itemBytesTotal - itemBytesLoaded;
			
			if ( loader is Sound ) {
				if ( loader.isBuffering == true ) {
					onStreamBuffering();
				}
				else if ( loader.isBuffering == false ) {
					onStreamReady();
				}
			}
			
			
			else if ( loader is NetStream ) {
				
				var timeElapsed:Number = getTimer() - itemResponseTime;
                var currentSpeed:Number = itemBytesLoaded / (timeElapsed/1000);
                var downloadTimeLeft:Number = itemBytesLeft / (currentSpeed * 0.8);
                var remainingBuffer:Number = streamMedatada.duration - loader.bufferLength ;
				var buffer = ( itemBufferSize * itemBytesTotal ) / streamMedatada.duration;
				itemBytesPlayed = Math.round(( Math.round(loader.time) * itemBytesTotal )/Math.round(streamMedatada.duration));
				
				
				///////////////////////////////////////////////////////////////////////////////////////////////
				//                                   gestion du buffer                                       //
				///////////////////////////////////////////////////////////////////////////////////////////////
				if ( itemBufferSize == 0 ) {
					//temps a télécharger ce qui reste moindre que le nombre de seconde de données restantes
					if ( remainingBuffer > downloadTimeLeft && itemBytesLoaded > 8 ) {
						onStreamReady();
					}
				}
				else {
					if ( streamReady == false ) {
						if ( streamBufferState <= buffer ) {
							streamBufferState += itemBytesLoaded - previousBytesLoaded;
						}
						else {
							onStreamReady();
						}
					}
					else if ( streamReady == true ) {
						if ( streamBufferState > buffer*.02 && (itemBytesLoaded - itemBytesPlayed) >= loader.bufferLength ){
							streamBufferState = streamBufferState - ( itemBytesPlayed - previousBytesPLayed );
						}
						else {
							onStreamBuffering();
						}
					}
				}	
				//////////////////////////////////////////////////////////////////////////////////////////////
				//                                                                                          //
				//////////////////////////////////////////////////////////////////////////////////////////////
				
				
				previousBytesLoaded = itemBytesLoaded;
				previousBytesPLayed = itemBytesPlayed;
				
			}
			
			//////////////////////////////////////////////
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		private function onloadComplete( evt:Event ):void {
			
			if ( loader is Loader ) {
				itemContent = loader.content;
				delListeners( loader );
				loader.unload();
				loader = null
			}
			//--
			else if (loader is URLLoader ) {
				if ( itemType == MultiLoaderItem.XMLFILE ) {
					itemContent = new XML(loader.data);
				}
				else if (itemType == MultiLoaderItem.BINARYFILE ) {
					itemContent = loader.data as ByteArray;
				}
				else {
					itemContent = loader.data;
				}
				delListeners( loader );
				loader = null;
			}
			//--
			else if ( loader is NetStream ) {
				itemContent = loader;
				delListeners( loader );
				loader = null;
			}
			//--
			else if (loader is Sound ) {
				itemContent = loader;
				delListeners( loader );
				loader = null;
			}
			
			//////////////////////////////////////////////
			itemPercentLoaded = 100;
			itemState = MultiLoaderItem.LOADED;
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		private function onloadIOerror( evt:IOErrorEvent ):void {
			
			if ( numTries < maxTries ) { load(); numTries += 1; }
			else { itemState = MultiLoaderItem.FAILED; }
			
			//////////////////////////////////////////////
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		private function onloadHttpStatus( evt:HTTPStatusEvent ):void {
			
			//////////////////////////////////////////////
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		private function onloadNetStatus( evt:NetStatusEvent ):void {
			switch( evt.info.code ) {
				case "NetStream.Play.Start" :
					itemContent = loader;
					
					//////////////////////////////////////////////
					var event:Event = new Event( Event.OPEN );
					onloadBegin( event );
					//////////////////////////////////////////////
					break;
			}
				
				
			//////////////////////////////////////////////
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		private function onloadID3( evt:Event ):void {
			//////////////////////////////////////////////
			dispatchEvent( evt );
			//////////////////////////////////////////////
		}
		
		
		
		//TODO
		private  function onVideoMetaData( metaData:Object ):void {
			streamMedatada = metaData;
		}
		
		private  function onVideoCuePoint( evt:* ):void {
			//return evt;
		}
		
		private  function onVideoPlayStatus( evt:* ):void {
			//return evt;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   DISPOSE OF THE ITEM
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			itemContent = null;
		}
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				         GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get content():*{
			return itemContent;
		}
		
		public function get name():String {
			return itemName;
		}
		
		public function get args():Object {
			return itemArgs;
		}
		
		public function get url():String {
			return itemURL.url;
		}
		
		public function get saveState():Boolean{
			return itemSaveState;
		}
		
		public function get state():String {
			return itemState
		}
		
		public function set state( state:String ):void {
			itemState = state;
		}
		
		public function get priority():int {
			return itemPriority;
		}
		
		public function set priority( priority:int ):void {
			itemPriority = priority;
		}
		
		public function get percentLoaded():Number {
			return itemPercentLoaded;
		}
		
		public function get bytesLoaded():Number {
			return itemBytesLoaded;
		}
				
		public function get bytesTotal():Number {
			return itemBytesTotal;
		}
		
		public function flvDuration():Number {
			return streamMedatada.duration;
		}
		
		public function get bytesPlayed():Number {
			return itemBytesPlayed;
		}
		
		public function get channel():SoundChannel {
			return ch;
		}
		
		public function set channel( chan:SoundChannel ):void {
			ch = chan;
			ch.addEventListener( Event.SOUND_COMPLETE, onSoundComplete, false, 0, true );
		}

	}
}