/**
* Basic extendable flv player -> basic stream/rtpm stream
* 
* @author Richard Rodney.
* @version 0.2
* 
* TODO:
* 	_Resize Button for manual resize
*   _External config parsing 
* 	_sort new Zindex
*/

package railk.as3.video.flvplayer {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.BitmapData;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.utils.ByteArray;

	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.data.saver.FileSaver;
	import railk.as3.data.parser.Parser;
	import railk.as3.root.Current;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.stage.FullScreenMode;
	import railk.as3.text.TextLink;
	import railk.as3.utils.DynamicRegistration;
	import railk.as3.utils.link.LinkManager;
	import railk.as3.utils.Loading;
	import railk.as3.utils.Logger;
	import railk.as3.utils.objectList.*;
	import railk.as3.utils.resize.ResizeManager;
	import railk.as3.utils.tag.TagManager;
	import railk.as3.utils.Utils;
	
	// _________________________________________________________________________________________ IMPORT ADOBE
	import com.adobe.images.PNGEncoder;
	
	// _______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	
	
	
	public class FlvPlayer extends DynamicRegistration  
	{
		// _____________________________________________________________________________ VARIABLES RAPATRIEES
		private var _name                               :String;
		private var _stream                             :NetStream;
		private var _streamPath                         :String;
		private var _duration                           :Number;
		private var _width                              :Number;
		private var _height                             :Number;
		private var _videoWidth                         :Number;
		private var _videoHeight                        :Number;
		private var _type                               :String;
		private var _standalone                         :Boolean;
		private var _playListContent                    :Array;
		private var _config                             :Array;
		private var _interfaceZindexList                :ObjectList;
		
		// _______________________________________________________________________________ VARIABLES CONTRÔLE
		private var _enableMask                         :Boolean;
		private var _enableShare                        :Boolean;
		private var _enableDownload                     :Boolean;
		private var _enablefullscreen                   :Boolean;
		private var _enablePlaylist                     :Boolean;
		private var _enableResize                       :Boolean;
		private var _enableScreenshot                   :Boolean;
		private var _enableX2                           :Boolean;
		
		// __________________________________________________________________________ VARIABLES VIDEO & SOUND
		private var video                               :Video;
		private var volume                              :SoundTransform;
		private var loaded                              :Number;
		private var played                              :Number;
		private var total                               :Number;
		private var current                             :Number;
		private var time                                :String;
		
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var container                           :DynamicRegistration;
		private var containerMask                       :DynamicRegistration;
		
		private var videoContainer                      :DynamicRegistration;
		private var bg                                  :DynamicRegistration;
		private var loading                             :DynamicRegistration;
		private var playPauseButton                     :DynamicRegistration;
		private var replayButton                        :DynamicRegistration;
		private var bufferBar                           :DynamicRegistration;
		private var seekBar                             :DynamicRegistration;
		private var seeker                              :DynamicRegistration;
		private var volumeBar                           :DynamicRegistration;
		private var volumeButton                        :DynamicRegistration;
		private var volumeSeeker                        :DynamicRegistration;
		private var fullscreenButton                    :DynamicRegistration;
		private var x2Button                            :DynamicRegistration;
		//private var resizeButton                        :DynamicRegistration;
		private var shareButton                         :DynamicRegistration;
		private var downloadButton                      :DynamicRegistration;
		private var screenshotButton                    :DynamicRegistration;
		private var playListButton                      :DynamicRegistration;
		private var playList                            :DynamicRegistration;
		private var tagList                             :DynamicRegistration;
		private var bulle                               :DynamicRegistration;
		private var interfaceItemList                   :ObjectList = new ObjectList(
																	['bg',bg],
																	['videoContainer',videoContainer],
																	['playList',playList],
																	['bufferBar',bufferBar],
																	['seekBar',seekBar],
																	['seeker',seeker],
																	['playPauseButton',playPauseButton],
																	['volumeBar',volumeBar],
																	['volumeButton',volumeButton],
																	['volumeSeeker',volumeSeeker],
																	['fullscreenButton',fullscreenButton],
																	['x2Button',x2Button],
																	/*['resizeButton',resizeButton],*/
																	['shareButton',shareButton],
																	['downloadButton',downloadButton],
																	['screenshotButton',screenshotButton],
																	['playListButton',playListButton],
																	['tagList',tagList],
																	['replayButton',replayButton],
																	['bulle',bulle],
																	['loading',loading] );
																	
		// _________________________________________________________________________________ VARIABLES PLAYER															
		private var share                               :String
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRCUTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function FlvPlayer():void{}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  		  INIT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	stream
		 * @param	streamPath
		 * @param	duration
		 * @param	width
		 * @param	height
		 * @param	videoWidth
		 * @param	videoHeight
		 * @param	type                 'stream' | 'rtpm'
		 * @param	playListContent
		 * @param	config               xmlfile <configs><path>needed</path>...</configs>
		 */
		public function init( name:String, stream:NetStream, streamPath:String, duration:Number, width:Number, height:Number, videoWidth:Number, videoHeight:Number, type:String='stream', standalone:Boolean=false, playListContent:Array=null, config:XML=null ):void 
		{
			//--logger
			Logger.print( 'FlvPlayer ' + name +' enabled', Logger.MESSAGE );
			
			//--managers
			TagManager.init();
			ResizeManager.init();
			LinkManager.init( 'flvplayer' )
			
			//--vars
			_name = name;
			_stream = stream;
			_streamPath = streamPath;
			_duration = duration;
			_width = width;
			_height = height;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			_type = type;
			_standalone = standalone;
			_playListContent = playListContent;
			if ( config != null ) _config = Parser.XMLItem( config );
			
			//--prepare interface list
			for ( var i:int=1; i < interfaceItemList.length; i++ )
			{
				var node:ObjectNode = interfaceItemList.iterate(i);
				node.data = new DynamicRegistration();
				node.data.name = node.name;
			}
			
			
			//--Sharing the player + the exact .flv
			var path:String = ExternalInterface.call("window.location.href.toString");
			share = '<object width="'+width+'" height="'+height+'">';
			share += '<param name="allowscriptaccess" value="always" />';
			if ( config != null )
			{
				share += '<param name="flashvars" value="config='+_config[0].path+'" />';
				share += '< param name = "movie" value ="' + path + 'flash/'+name+'.swf?config='+_config[0].path+'" / >';
				share += '< embed src ="' + path + 'flash/'+name+'.swf?config='+_config[0].path+'" type="application/x-shockwave-flash"  allowscriptaccess="always" width="'+width+'" height="'+height+'" >';
			}
			else
			{
				share += '< param name = "movie" value ="' + path + 'flash/'+name+'.swf" / >';
				share += '< embed src ="' + path + 'flash/'+name+'.swf" type="application/x-shockwave-flash"  allowscriptaccess="always" width="'+width+'" height="'+height+'" >';
			}
			share += '</embed></object>';
			
			//--main container
			container = new DynamicRegistration();
			addChild( container );
			
			//--attach video
			interfaceItemList.getObjectByName('videoContainer').data = new DynamicRegistration( { x:0, y:0, alpha:1, resize:function(){} } );
			
				video = new Video( videoWidth, videoHeight );
				video.attachNetStream ( stream );
				interfaceItemList.getObjectByName('videoContainer').data.addChild( video );	
				
			//--enable volume modification
			volume = new SoundTransform();
			stream.soundTransform = volume;
			
			//////////////////////////
			create();
			//////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	  CREATION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function create():void 
		{
			containerMask = createMask();
			///////////////////////////////
			interfaceItemList.getObjectByName('bg').data = createBG();
			interfaceItemList.getObjectByName('loading').data = createLoading();
			interfaceItemList.getObjectByName('playPauseButton').data = createPlayPauseButton();
			interfaceItemList.getObjectByName('replayButton').data = createReplayButton();
			interfaceItemList.getObjectByName('bufferBar').data = createBufferBar();
			interfaceItemList.getObjectByName('seekBar').data = createSeekBar();
			interfaceItemList.getObjectByName('seeker').data = createSeeker();
			interfaceItemList.getObjectByName('volumeBar').data = createVolumeBar();
			interfaceItemList.getObjectByName('volumeButton').data = createVolumeButton();
			interfaceItemList.getObjectByName('volumeSeeker').data = createVolumeSeeker();
			interfaceItemList.getObjectByName('fullscreenButton').data = createFullscreenButton();
			interfaceItemList.getObjectByName('x2Button').data = createX2Button();
			//interfaceItemList.getObjectByName('resizeButton').data = createResizeButton();
			interfaceItemList.getObjectByName('shareButton').data = createShareButton();
			interfaceItemList.getObjectByName('downloadButton').data = createDownloadButton();
			interfaceItemList.getObjectByName('screenshotButton').data = createScreenshotButton();
			interfaceItemList.getObjectByName('playListButton').data = createPlayListButton();
			interfaceItemList.getObjectByName('playList').data = createPlayList();
			interfaceItemList.getObjectByName('tagList').data = createTagList();
			interfaceItemList.getObjectByName('bulle').data = createBulle();
			//////////////////////////////
			createLayout();
			initListeners();
			//////////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 INTERFACE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		protected function createBG():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var b:GraphicShape = new GraphicShape();
				b.rectangle( 0xffffff, 0, 0, _width, _height );
				result.addChild( b );

			return result; 
		}
		protected function createMask():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				//var m:GraphicShape = new GraphicShape();
				//m.roundRectangle( 0x000000, 0, 0, _width, _height,30,30 );
				//result.addChild( m );

			return result; 
		}
		protected function createLoading():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result;  
		}
		protected function createPlayPauseButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createReplayButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createBufferBar():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createSeekBar():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createSeeker():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createVolumeBar():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createVolumeButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createVolumeSeeker():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createFullscreenButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createX2Button():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createShareButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createDownloadButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createScreenshotButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createPlayListButton():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createPlayList():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		protected function createTagList():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result;  
		}
		protected function createBulle():DynamicRegistration
		{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}
		/*protected function createResizeButton():DynamicRegistration
		 { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}*/
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					ADD INTERFACE ITEM
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	item
		 * @param	insert   'before:name' | 'after:name'
		 * @param	action
		 */
		public function addInterfaceItem( name:String, item:*, insert:String, action:Function=null ):void {
			//--vars
			var insertMode = insert.split(':')[0];
			var insertPoint = insert.split(':')[1];
			item.name = name;
			
			//--add
			for ( var i:int=1; i < interfaceItemList.length; i++ )
			{
				var node:ObjectNode = interfaceItemList.iterate(i);
				if( insertPoint == node.data.name ){
					if ( insertMode == 'before') interfaceItemList.insertBefore( node, name, item );
					else if ( insertMode == 'after') interfaceItemList.insertAfter( node, name, item );
					break;
				}
			}
			
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  PARSE CONFIG
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function parseConfig( config:Array ):void {}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   SORT ZINDEX
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function sortZindex( zindex:Object ):void {}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 	LAYOUT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createLayout():void {
			for ( var i:int=1; i < interfaceItemList.length; i++ )
			{
				var node:ObjectNode = interfaceItemList.iterate(i);
				if ( node.data.extra.x != undefined ) node.data.x =  node.data.extra.x;
				else if ( node.data.extra.x2 != undefined ) node.data.x =  node.data.extra.x2;
				if ( node.data.extra.y != undefined ) node.data.y =  node.data.extra.y;
				else if ( node.data.extra.y2 != undefined ) node.data.y2 =  node.data.extra.y2;
				if ( node.data.extra.alpha != undefined ) node.data.alpha =  node.data.extra.alpha;
				
				//ResizeManager.add( prop, node.data, node.data.extra.resize );
				container.addChild( node.data );
				if ( _enableMask ) container.mask = containerMask;
			}
			if ( _standalone ) FullScreenMode.Activate( fullscreenButton, Current.stage );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 GESTION LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void 
		{
			StageManager.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('seeker').data.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('seeker').data.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeSeeker').data.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeSeeker').data.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('playPauseButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('replayButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeBar').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('fullscreenButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('x2Button').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			//interfaceItemList.getObjectByName('resizeButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('shareButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('downloadButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('screenshotButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		private function delListeners():void 
		{
			StageManager.removeEventListener( Event.ENTER_FRAME, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent );
			interfaceItemList.getObjectByName('seeker').data.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			interfaceItemList.getObjectByName('seeker').data.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			interfaceItemList.getObjectByName('volumeSeeker').data.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			interfaceItemList.getObjectByName('volumeSeeker').data.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			interfaceItemList.getObjectByName('volumeButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('playPauseButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('replayButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('volumeBar').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('fullscreenButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('x2Button').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			//interfaceItemList.getObjectByName('resizeButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('shareButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('downloadButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('screenshotButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				     	  IMAGE SAVER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function screenshot( name:String ):void {
			//--vars
			var toSave:ByteArray;
			var bmp:BitmapData = new BitmapData( _videoWidth, _videoHeight );
			var saveImg:FileSaver = new FileSaver( name );
			
			bmp.draw( videoContainer );
			toSave = PNGEncoder.encode( bmp );
			saveImg.create( 'local','assets\images',name, 'png', toSave, true );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose()
		{
			delListeners();
			video = null;
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					      MANAGE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case StageManagerEvent.ONSTAGERESIZE :
					ResizeManager.groupAction( StageManager.W,StageManager.H );
					break;
				
				case StageManagerEvent.ONMOUSELEAVE :
					break;
					
				case StageManagerEvent.ONMOUSEACTIVE :
					break;
					
				case StageManagerEvent.ONMOUSEIDLE :
					break;	
					
				case Event.ENTER_FRAME :
					current = Math.floor( stream.time );	
					total = Math.round( _duration );
					played = stream.time / _duration;
					loaded = stream.bytesLoaded / stream.bytesTotal;
					time = Utils.numberToTime( played, true );
					break;
				
				case MouseEvent.MOUSE_UP :
					switch( evt.target.name )
					{
						case 'seeker':
							seeker.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
							break;
							
						case 'volumeseeker':
							volumeSeeker.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
							break;	
					}
					break;
				
				case MouseEvent.MOUSE_DOWN :
					switch( evt.target.name )
					{
						case 'seeker':
							seeker.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
							break;
							
						case 'volumeseeker':
							volumeSeeker.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
							break;	
					}
					break;
					
				case MouseEvent.MOUSE_MOVE :
					switch( evt.target.name )
					{
						case 'seeker':
							_stream.seek( (seeker.extra.pos*_duration)/seekBar.extra.size );
							break;
							
						case 'volumeseeker':
							volume.volume = (volumeSeeker.extra.pos*100)/volumeBar.extra.size;
							_stream.soundTransform = volume;
							break;	
					}
					evt.updateAfterEvent();
					break;
					
				case MouseEvent.CLICK :
					switch( evt.target.name )
					{
						case 'playpausebutton':
							_stream.togglePause();
							break;
						
						case 'replaybutton':
							_stream.seek(0);
							break;	
							
						case 'volumebutton':
							if ( LinkManager.getLink( 'volumebutton').isActive() )
							{
								Tweener.addTween( volume, { volume:(volumeSeeker.extra.pos*100)/volumeBar.extra.size, time:.4, onUpdate:function(){ _stream.soundTransform = volume; } } );
							}
							else
							{
								Tweener.addTween( volume, { volume:0, time:.4, onUpdate:function(){ _stream.soundTransform = volume; } } );
							}
							break;
						
						case 'fullscreenbutton':
							if ( ! _standalone )
							{
								if ( LinkManager.getLink( 'fullscreenbutton').isActive() )
								{
									ResizeManager.groupAction( StageManager.W, StageManager.H );
								}
								else
								{
									ResizeManager.groupAction( _width, _height );
								}
							}
							break;
							
						case 'x2button' :
							if ( LinkManager.getLink( 'x2button').isActive() )
							{
								ResizeManager.groupAction(_width*.5,_height*.5);
							}
							else 
							{
								ResizeManager.groupAction(_width*2,_height*2);
							}
							break;
							
						/*case 'resizebutton':
							//function to resize manually
							break;*/
						
						case 'sharebutton':
							System.setClipboard( share );
							break;
						
						case 'downloadbutton':
							navigateToURL( new URLRequest( _streamPath ), '_blank' );
							break;
							
						case 'screenshotbutton':
							screenshot( String(current) );
							break;
							
					}
					break;
			}
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					     GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public override function get name():String { return _name; }
		
		public override function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get stream():NetStream { return _stream; }
		
		public function set stream(value:NetStream):void 
		{
			video.attachNetStream( stream );
			_stream = value;
		}
		
		public function get streamPath():String { return _streamPath; }
		
		public function set streamPath(value:String):void 
		{
			_streamPath = value;
		}
		
		public function get duration():Number { return _duration; }
		
		public function set duration(value:Number):void 
		{
			_duration = value;
		}
		
		public override function get width():Number { return _width; }
		
		public override function set width(value:Number):void 
		{
			_width = value;
			ResizeManager.groupAction( _width, _height );
		}
		
		public override function get height():Number { return _height; }
		
		public override function set height(value:Number):void 
		{
			_height = value;
			ResizeManager.groupAction( _width, _height );
		}
		
		public function get enableShare():Boolean { return _enableShare; }
		
		public function set enableShare(value:Boolean):void 
		{
			_enableShare = value;
			shareButton.visible = value;
		}
		
		public function get enableDownload():Boolean { return _enableDownload; }
		
		public function set enableDownload(value:Boolean):void 
		{
			_enableDownload = value;
			downloadButton.visible = value;
		}
		
		public function get enablefullscreen():Boolean { return _enablefullscreen; }
		
		public function set enablefullscreen(value:Boolean):void 
		{
			_enablefullscreen = value;
			fullscreenButton.visible = value;
		}
		
		public function get enablePlaylist():Boolean { return _enablePlaylist; }
		
		public function set enablePlaylist(value:Boolean):void 
		{
			_enablePlaylist = value;
			playList.visible = value;
			playListButton.visible = value;
		}
		
		/*public function get enableResize():Boolean { return _enableResize; }
		
		public function set enableResize(value:Boolean):void 
		{
			_enableResize = value;
		}*/
		
		public function get enableX2():Boolean { return _enableX2; }
		
		public function set enableX2(value:Boolean):void 
		{
			_enableX2 = value;
			x2Button.visible = value;
		}
		
		public function get enableScreenshot():Boolean { return _enableScreenshot; }
		
		public function set enableScreenshot(value:Boolean):void 
		{
			_enableScreenshot = value;
			screenshotButton.visible = value;
		}
		
		public function get enableMask():Boolean { return _enableMask; }
		
		public function set enableMask(value:Boolean):void 
		{
			_enableMask = value;
		}
		
		public function get playListContent():Array { return _playListContent; }
		
		public function set playListContent(value:Array):void 
		{
			_playListContent = value;
		}
		
		public function get interfaceZindexList():ObjectList { return _interfaceZindexList; }
		
		public function set interfaceZindexList(value:ObjectList):void 
		{
			_interfaceZindexList = value;
			sortZindex( _interfaceZindexList );
		}
		
		
		public function get config():Array { return _config; }
		
		public function set config(value:Array):void 
		{
			_config = value;
			parseConfig( _config );
		}
		
		
	}	
}