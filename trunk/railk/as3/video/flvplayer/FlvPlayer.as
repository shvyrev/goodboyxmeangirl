/**
* Basic extendable flv player -> basic stream/rtpm stream
* 
* @author Richard Rodney.
* @version 0.2
* 
* need at least itc StoneSans font for this basic player to work, extented doesn't need it
* 
* TODO:
* 	_Resize Button for manual resize, External config parsing, sort new Zindex
*/

package railk.as3.video.flvplayer {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.net.saver.file.FileSaver;
	import railk.as3.data.parser.Parser;
	import railk.as3.display.GraphicShape;
	import railk.as3.display.DSprite;
	import railk.as3.display.drawingShape.PixelShapes;
	import railk.as3.display.AnimatedClip;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.stage.FullScreenMode;
	import railk.as3.text.TextLink;
	import railk.as3.display.RegistrationPoint;
	import railk.as3.ui.ToolTip;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.ui.Loading;
	import railk.as3.utils.Logger;
	import railk.as3.data.list.*;
	import railk.as3.ui.resize.ResizeManager;
	import railk.as3.data.tag.TagManager;
	import railk.as3.utils.Utils;
	
	// _________________________________________________________________________________________ IMPORT ADOBE
	import com.adobe.images.PNGEncoder;
	
	// _______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	
	
	
	public class FlvPlayer extends RegistrationPoint  
	{
		// _________________________________________________________________________________ VARIABLES STREAM
		private var nc                                  :NetConnection;
		private var stream                              :NetStream;
		private var streamTriggerEvent                  :Sprite;
		private var streamMetadata                      :Object={};
		private var streamReady                         :Boolean = false;
		private var streamBufferState                   :Number = 0;
		private var previousBytesLoaded                 :Number = 0;
		private var previousBytesPLayed                 :Number = 0;
		private var responseTime                        :Number;
		private var loaded                              :Number;
		private var played                              :Number;
		private var time                                :String;
		
		// _____________________________________________________________________________ VARIABLES RAPATRIEES
		private var _name                               :String;
		private var _url                                :String;
		private var _bufferSize                         :int;
		private var _width                              :Number;
		private var _height                             :Number;
		private var _videoWidth                         :Number;
		private var _videoHeight                        :Number;
		private var _fonts                              :Object;
		private var _backgroundImage                    :BitmapData;
		private var _type                               :String;
		private var _standalone                         :Boolean;
		private var _playListContent                    :Array;
		private var _config                             :*;
		private var _interfaceZindexList                :DLinkedList;
		
		// _______________________________________________________________________________ VARIABLES CONTRﾔLE
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
		
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var container                           :DSprite;
		private var containerMask                       :DSprite;
		
		private var component                           :DSprite = new DSprite();
		protected var currentNode                       :DListNode;
		protected var interfaceItemList                 :DLinkedList = new DLinkedList(
																	['bg', component],
																	['bgImage',component],
																	['videoContainer',component],
																	['playList',component],
																	['bufferBar',component],
																	['seekBar',component],
																	['seeker',component],
																	['playPauseButton',component],
																	['volumeBarBG',component],
																	['volumeBar',component],
																	['volumeButton',component],
																	['volumeSeeker',component],
																	['fullscreenButton',component],
																	['x2Button',component],
																	['resizeButton',component],
																	['shareButton',component],
																	['downloadButton',component],
																	['screenshotButton',component],
																	['playListButton',component],
																	['replayButton',component],
																	['bulle',component],
																	['time',component],
																	['loading', component],
																	['sharePanel',component]);
																	
		// _________________________________________________________________________________ VARIABLES PLAYER															
		private var share                               :String
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRCUTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function FlvPlayer():void 
		{
			//Security.allowDomain("localhost");
			//Security.loadPolicyFile("http://localhost/crossdomain.xml");
			nc = new NetConnection();
			nc.connect( null );
			stream = new NetStream( nc );
			streamTriggerEvent = new Sprite();
			streamTriggerEvent.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			var customClient:Object = new Object();
			customClient.onMetaData = onVideoMetaData;
			//customClient.onCuePoint = onVideoCuePoint;
			//customClient.onPlayStatus = onVideoPlayStatus;
			stream.client = customClient;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  		  INIT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function init( mask:Boolean = false, playlist:Boolean=false, share:Boolean = false, download:Boolean = false, fullscreen:Boolean = false, x2:Boolean = false, resize:Boolean = false, screenshot:Boolean=false ):void
		{
			_enableDownload = download;
			_enablefullscreen = fullscreen;
			_enableMask = mask;
			_enablePlaylist = playlist;
			_enableResize = resize;
			_enableScreenshot = screenshot;
			_enableShare = share;
			_enableX2 = x2;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  		CREATE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		/**
		 * 
		 * @param	name
		 * @param	url
		 * @param	width
		 * @param	height
		 * @param	videoWidth
		 * @param	videoHeight
		 * @param	fonts              {name:fontName,...}
		 * @param	backgroundImage
		 * @param	buffersize
		 * @param	type               'stream'|'rtpm'
		 * @param	standalone
		 * @param	playListContent
		 * @param	config             xmlfile <configs><path>needed</path>...</configs>
		 */
		public function create( name:String, url:String, width:Number, height:Number, videoWidth:Number, videoHeight:Number, config:Class, fonts:Object=null, backgroundImage:BitmapData=null, buffersize:int=0, type:String='stream', standalone:Boolean=false, playListContent:Array=null ):void 
		{
			//--logger
			Logger.print( '' + config.NAME +' enabled', Logger.MESSAGE );
			
			//--managers
			TagManager.init();
			ResizeManager.init();
			LinkManager.init( 'flvplayer' )
			
			//--vars
			_name = name;
			_url = url;
			_width = width;
			_height = height;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			_fonts = fonts;
			_type = type;
			_backgroundImage = backgroundImage;
			_bufferSize = buffersize;
			_standalone = standalone;
			_playListContent = playListContent;
			
			
			//--Sharing the player + the exact .flv
			var path:String = ExternalInterface.call("window.location.href.toString");
			share = '<object width="'+width+'" height="'+height+'">';
			share += '<param name="allowscriptaccess" value="always" />';
			share += '< param name = "movie" value ="' + path + 'flash/'+name+'.swf" / >';
			share += '< embed src ="' + path + 'flash/'+name+'.swf" type="application/x-shockwave-flash"  allowscriptaccess="always" width="'+width+'" height="'+height+'" >';
			share += '</embed></object>';
			
			//--config init
			_config = new config();
			_config.init( width, height, fonts, share, backgroundImage );
			
			//--main container
			container = new DSprite();
			addChild( container );
			
			//--attach video
			interfaceItemList.getNodeByName('videoContainer').data = new DSprite( { x:0, y:0, alpha:1, resize:function(){} } );
			
				video = new Video( videoWidth, videoHeight );
				video.attachNetStream ( stream );
				interfaceItemList.getNodeByName('videoContainer').data.addChild( video );	
				
			//--enable volume modification
			volume = new SoundTransform();
			stream.soundTransform = volume;
			
			//////////////////////////
			createComponents();
			createLayout();
			initListeners();
			//////////////////////////
			
			//--launch stream and apuse lecture
			stream.play( url );
			stream.seek(0);
			stream.togglePause();	
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  	  CREATION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function createComponents():void 
		{
			containerMask = _config.createMask();
			///////////////////////////////
			interfaceItemList.getNodeByName('bg').data = _config.createBG();
			if( _backgroundImage ) interfaceItemList.getNodeByName('bgImage').data = _config.createBGimage();
			interfaceItemList.getNodeByName('loading').data = _config.createLoading();
			interfaceItemList.getNodeByName('playPauseButton').data = _config.createPlayPauseButton();
			interfaceItemList.getNodeByName('replayButton').data = _config.createReplayButton();
			interfaceItemList.getNodeByName('bufferBar').data = _config.createBufferBar();
			interfaceItemList.getNodeByName('seekBar').data = _config.createSeekBar();
			interfaceItemList.getNodeByName('seeker').data =_config. createSeeker();
			interfaceItemList.getNodeByName('volumeBarBG').data = _config.createVolumeBarBG();
			interfaceItemList.getNodeByName('volumeBar').data = _config.createVolumeBar();
			interfaceItemList.getNodeByName('volumeButton').data = _config.createVolumeButton();
			interfaceItemList.getNodeByName('volumeSeeker').data = _config.createVolumeSeeker();
			interfaceItemList.getNodeByName('fullscreenButton').data = _config.createFullscreenButton();
			interfaceItemList.getNodeByName('x2Button').data = _config.createX2Button();
			interfaceItemList.getNodeByName('resizeButton').data = _config.createResizeButton();
			interfaceItemList.getNodeByName('shareButton').data = _config.createShareButton();
			interfaceItemList.getNodeByName('sharePanel').data = _config.createSharePanel(share);
			interfaceItemList.getNodeByName('downloadButton').data = _config.createDownloadButton();
			interfaceItemList.getNodeByName('screenshotButton').data = _config.createScreenshotButton();
			interfaceItemList.getNodeByName('playListButton').data = _config.createPlayListButton();
			interfaceItemList.getNodeByName('playList').data = _config.createPlayList();
			interfaceItemList.getNodeByName('bulle').data = _config.createBulle();
			interfaceItemList.getNodeByName('time').data = _config.createTime();
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					  INTERFACE LAYOUT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function createLayout():void {
			currentNode = interfaceItemList.head;
			loop:while ( currentNode ) 
			{
				if ( currentNode.data.extra.x != undefined ) currentNode.data.x =  currentNode.data.extra.x;
				else if ( currentNode.data.extra.x2 != undefined ) currentNode.data.x =  currentNode.data.extra.x2;
				if ( currentNode.data.extra.y != undefined ) currentNode.data.y =  currentNode.data.extra.y;
				else if ( currentNode.data.extra.y2 != undefined ) currentNode.data.y2 =  currentNode.data.extra.y2;
				if ( currentNode.data.extra.alpha != undefined ) currentNode.data.alpha =  currentNode.data.extra.alpha;
				
				//ResizeManager.add( prop, currentNode.data, currentNode.data.extra.resize );
				currentNode.data.name = currentNode.name;
				container.addChild( currentNode.data );
				
				currentNode = currentNode.next;
			}
			
			if ( _enableMask ) container.mask = containerMask;	
			if ( _standalone && _enablefullscreen ) FullScreenMode.Activate( interfaceItemList.getNodeByName('fullscreenButton').data, Current.stage );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					 GESTION LISTENERS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function initListeners():void 
		{
			stream.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
            stream.addEventListener( NetStatusEvent.NET_STATUS, manageEvent, false, 0, true );
			StageManager.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('seeker').data.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('seeker').data.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('volumeSeeker').data.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('volumeSeeker').data.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('volumeButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('playPauseButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('replayButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('volumeBar').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('fullscreenButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('x2Button').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('resizeButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('shareButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('downloadButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getNodeByName('screenshotButton').data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		private function delListeners():void 
		{
			stream.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
            stream.removeEventListener( NetStatusEvent.NET_STATUS, manageEvent );
			StageManager.removeEventListener( Event.ENTER_FRAME, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent );
			StageManager.removeEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent );
			interfaceItemList.getNodeByName('seeker').data.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			interfaceItemList.getNodeByName('seeker').data.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			interfaceItemList.getNodeByName('volumeSeeker').data.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			interfaceItemList.getNodeByName('volumeSeeker').data.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			interfaceItemList.getNodeByName('volumeButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('playPauseButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('replayButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('volumeBar').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('fullscreenButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('x2Button').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('resizeButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('shareButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('downloadButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getNodeByName('screenshotButton').data.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					ADD INTERFACE ITEM
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		/**
		 * 
		 * @param	name
		 * @param	item
		 * @param	insert   'before:name' | 'after:name'
		 * @param	action
		 */
		public function addInterfaceItem( name:String, item:*, insert:String, group:String = '', action:Function = null ):void 
		{
			var insertMode = insert.split(':')[0];
			var insertPoint = insert.split(':')[1];
			item.name = name;
			
			//--add
			currentNode = interfaceItemList.head;
			loop:while ( currentNode ) {
				if( insertPoint == currentNode.data.name ){
					if ( insertMode == 'before') interfaceItemList.insertBefore( currentNode, name, item, group, action );
					else if ( insertMode == 'after') interfaceItemList.insertAfter( currentNode, name, item, group, action  );
					break loop;
				}
				currentNode = currentNode.next;
			}
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						   SORT ZINDEX
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function sortZindex( zindex:Object ):void {}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				     	  IMAGE SAVER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function screenshot( name:String ):void 
		{
			var toSave:ByteArray;
			var bmp:BitmapData = new BitmapData( _videoWidth, _videoHeight );
			var saveImg:FileSaver = new FileSaver( name );
			
			bmp.draw( interfaceItemList.getNodeByName('videoContainer').data );
			toSave = PNGEncoder.encode( bmp );
			saveImg.create( 'local','assets\images',name, 'png', toSave, true );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					     	 METADATAS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private  function onVideoMetaData( metaData:Object ):void { streamMetadata = metaData; }
		
		private  function onVideoCuePoint( evt:* ):void { /*return evt;*/ }
		
		private  function onVideoPlayStatus( evt:* ):void { /*return evt;*/ }
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																				  			   DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function dispose(){
			delListeners();
			video = null;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					      MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function manageEvent( evt:*):void 
		{
			var event:Event;
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
				
				case NetStatusEvent.NET_STATUS :
					switch( evt.info.code ) {
						case "NetStream.Play.Start" :
							responseTime = getTimer();
							break;
					}
					break;
					
				case IOErrorEvent.IO_ERROR :
					//todo error loading flv
					break;
					
				case Event.ENTER_FRAME :
					if ( stream.bytesLoaded == 0 ) responseTime = getTimer();
					else if ( stream.bytesLoaded == stream.bytesTotal ) streamReady = true;
					
					if ( Math.round(stream.time) == Math.round(streamMetadata.duration) ) streamTriggerEvent.removeEventListener( Event.ENTER_FRAME, manageEvent );
					else 
					{
						time = Utils.numberToTime( (getTimer() - responseTime), true );
						played = stream.time / streamMetadata.duration;
						loaded = stream.bytesLoaded / stream.bytesTotal;
						
						interfaceItemList.getNodeByName( 'bufferBar' ).data.width = interfaceItemList.getNodeByName( 'bufferBar' ).data.extra.size * loaded;
						interfaceItemList.getNodeByName( 'seekBar' ).data.width = interfaceItemList.getNodeByName( 'seekBar' ).data.extra.size * played;
						interfaceItemList.getNodeByName( 'seeker' ).data.x2 = interfaceItemList.getNodeByName( 'seekBar' ).data.width+interfaceItemList.getNodeByName( 'seekBar' ).data.x;
						
						
						////////////////////////////////////////////////buffer//////////////////////////////////////////////////////////
						var remainingBuffer:Number = streamMetadata.duration - stream.bufferLength ;
						var buffer:Number = ( _bufferSize * stream.bytesTotal ) / streamMetadata.duration;
						var bytesPlayed:Number = Math.round(( Math.round(stream.time) * stream.bytesTotal ) / Math.round(streamMetadata.duration));
						var bytesLoaded:Number = stream.bytesLoaded;
						var bytesLeft:Number = stream.bytesTotal - stream.bytesLoaded;
						var currentSpeed = loaded / ((getTimer() - responseTime)/1000);
						var downloadTimeLeft:Number = bytesLeft / (currentSpeed * 0.8);
						
						if ( _bufferSize == 0 ) {
							if ( remainingBuffer > downloadTimeLeft && bytesLoaded > 8 ) streamReady = true;
						}
						else {
							if ( streamReady == false ) {
								if ( streamBufferState <= buffer ) streamBufferState += bytesLoaded - previousBytesLoaded;
								else streamReady = true;
							}
							else if ( streamReady == true ) {
								if ( streamBufferState > buffer*.02 && (bytesLoaded - bytesPlayed) >= stream.bufferLength ) streamBufferState = streamBufferState - ( bytesPlayed - previousBytesPLayed );
								else streamReady = false;
							}
						}	
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						
						previousBytesLoaded = bytesLoaded;
						previousBytesPLayed = bytesPlayed;
					}
					break;
				
				case MouseEvent.MOUSE_UP :
					switch( evt.currentTarget.name ){
						case 'seeker':
							interfaceItemList.getNodeByName('seeker').data.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
							break;
							
						case 'volumeseeker':
							interfaceItemList.getNodeByName('volumeSeeker').data.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
							break;	
					}
					break;
				
				case MouseEvent.MOUSE_DOWN :
					switch( evt.currentTarget.name ){
						case 'seeker':
							interfaceItemList.getNodeByName('seeker').data.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
							break;
							
						case 'volumeseeker':
							interfaceItemList.getNodeByName('volumeSeeker').data.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
							break;	
					}
					break;
					
				case MouseEvent.MOUSE_MOVE :
					switch( evt.currentTarget.name ){
						case 'seeker':
							stream.seek( (interfaceItemList.getNodeByName('seeker').data.extra.pos*streamMetadata.duration)/interfaceItemList.getNodeByName('seekBar').data.extra.size );
							break;
							
						case 'volumeseeker':
							volume.volume = (interfaceItemList.getNodeByName('volumeSeeker').data.extra.pos*100)/interfaceItemList.getNodeByName('volumeBar').data.extra.size;
							stream.soundTransform = volume;
							break;	
					}
					evt.updateAfterEvent();
					break;
					
				case MouseEvent.CLICK :
					switch( evt.currentTarget.name ){
						case 'playPauseButton':
							stream.togglePause();
							break;
						
						case 'replayButton':
							stream.seek(0);
							break;	
							
						case 'volumeButton':
							if ( LinkManager.getLink( 'volumeButton').isActive() ) 	Tweener.addTween( volume, { volume:0, time:.4, onUpdate:function(){ stream.soundTransform = volume; } } );
							else Tweener.addTween( volume, { volume:1, time:.4, onUpdate:function(){ stream.soundTransform = volume; } } );
							break;
						
						case 'fullscreenButton':
							if ( ! _standalone && _enablefullscreen ){
								if ( LinkManager.getLink( 'fullscreenButton').isActive() ) ResizeManager.groupAction( StageManager.W, StageManager.H );
								else ResizeManager.groupAction( _width, _height );
							}
							break;
							
						case 'x2Button' :
							if( _enableX2 ){
								if ( LinkManager.getLink( 'x2Button').isActive() ) ResizeManager.groupAction(_width*.5,_height*.5);
								else ResizeManager.groupAction(_width * 2, _height * 2); 
							}
							break;
							
						/*case 'resizeButton':
							//if( _enableResize )function to resize manually
							break;*/
							
						case 'shareButton':
							if( _enableShare ) System.setClipboard( share );
							break;
						
						case 'downloadButton':
							if ( _enableDownload )  navigateToURL( new URLRequest( _url ), '_blank' );
							break;
							
						case 'screenshotButton':
							if( _enableScreenshot ) screenshot( time );
							break;
					}
					break;
			}
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					     GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public override function get name():String { return _name; }
		
		public override function set name(value:String):void { _name = value; }
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void { _url = value; }
		
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
			interfaceItemList.getNodeByName('shareButton').data.visible = value;
		}
		
		public function get enableDownload():Boolean { return _enableDownload; }
		
		public function set enableDownload(value:Boolean):void 
		{
			_enableDownload = value;
			interfaceItemList.getNodeByName('downloadButton').data.visible = value;
		}
		
		public function get enablefullscreen():Boolean { return _enablefullscreen; }
		
		public function set enablefullscreen(value:Boolean):void 
		{
			_enablefullscreen = value;
			interfaceItemList.getNodeByName('fullscreenButton').data.visible = value;
		}
		
		public function get enablePlaylist():Boolean { return _enablePlaylist; }
		
		public function set enablePlaylist(value:Boolean):void 
		{
			_enablePlaylist = value;
			interfaceItemList.getNodeByName('playList').data.visible = value;
			interfaceItemList.getNodeByName('playListButton').data.visible = value;
		}
		
		public function get enableResize():Boolean { return _enableResize; }
		
		public function set enableResize(value:Boolean):void { _enableResize = value; }
		
		public function get enableX2():Boolean { return _enableX2; }
		
		public function set enableX2(value:Boolean):void 
		{
			_enableX2 = value;
			interfaceItemList.getNodeByName('x2Button').data.visible = value;
		}
		
		public function get enableScreenshot():Boolean { return _enableScreenshot; }
		
		public function set enableScreenshot(value:Boolean):void 
		{
			_enableScreenshot = value;
			interfaceItemList.getNodeByName('screenshotButton').data.visible = value;
		}
		
		public function get enableMask():Boolean { return _enableMask; }
		
		public function set enableMask(value:Boolean):void { _enableMask = value; }
		
		public function get playListContent():Array { return _playListContent; }
		
		public function set playListContent(value:Array):void { _playListContent = value; }
		
		public function get interfaceZindexList():DLinkedList { return _interfaceZindexList; }
		
		public function set interfaceZindexList(value:DLinkedList):void 
		{
			_interfaceZindexList = value;
			sortZindex( _interfaceZindexList );
		}
	}	
}