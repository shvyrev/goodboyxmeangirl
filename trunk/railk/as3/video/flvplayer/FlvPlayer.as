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
	import railk.as3.data.saver.FileSaver;
	import railk.as3.data.parser.Parser;
	import railk.as3.display.GraphicShape;
	import railk.as3.display.PixelShapes;
	import railk.as3.display.AnimatedClip;
	import railk.as3.root.Current;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.stage.FullScreenMode;
	import railk.as3.text.TextLink;
	import railk.as3.utils.DynamicRegistration;
	import railk.as3.utils.InfoBulle;
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
		private var _config                             :Array;
		private var _interfaceZindexList                :ObjectList;
		
		// _______________________________________________________________________________ VARIABLES CONTR�LE
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
		private var container                           :DynamicRegistration;
		private var containerMask                       :DynamicRegistration;
		
		private var component                           :DynamicRegistration = new DynamicRegistration();
		protected var interfaceItemList                 :ObjectList = new ObjectList(
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
																	/*['resizeButton',component],*/
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
		protected var share                               :String
		
		// ________________________________________________________________________________________ FUCNTIONS
		private var txtHoverOut                         :Function = function( type:String, o:TextLink)
		{
			if ( type == 'hover') Tweener.addTween( o.textfield, { _text_color:0xFFFF00, time:.2 } );
			else if ( type == 'out') Tweener.addTween( o.textfield, { _text_color:0xFFFFff, time:.2 } );
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																						  CONSTRCUTEUR
		// ���������������������������������������������������������������������������������������������������
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
		
		// ���������������������������������������������������������������������������������������������������
		// 																						  		  INIT
		// ���������������������������������������������������������������������������������������������������
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
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																						  		CREATE
		// ���������������������������������������������������������������������������������������������������
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
		public function create( name:String, url:String, width:Number, height:Number, videoWidth:Number, videoHeight:Number, fonts:Object=null, backgroundImage:BitmapData=null, buffersize:int=0, type:String='stream', standalone:Boolean=false, playListContent:Array=null, config:XML=null ):void 
		{
			//--logger
			Logger.print( 'FlvPlayer ' + name +' enabled', Logger.MESSAGE );
			
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
			if ( config != null ) _config = Parser.XMLItem( config );
			
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
			createComponents();
			createLayout();
			initListeners();
			//////////////////////////
			
			//--launch stream and apuse lecture
			stream.play( url );
			stream.seek(0);
			stream.togglePause();	
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																						  	  CREATION
		// ���������������������������������������������������������������������������������������������������
		private function createComponents():void 
		{
			containerMask = createMask();
			///////////////////////////////
			interfaceItemList.getObjectByName('bg').data = createBG();
			if( _backgroundImage ) interfaceItemList.getObjectByName('bgImage').data = createBGimage();
			interfaceItemList.getObjectByName('loading').data = createLoading();
			interfaceItemList.getObjectByName('playPauseButton').data = createPlayPauseButton();
			interfaceItemList.getObjectByName('replayButton').data = createReplayButton();
			interfaceItemList.getObjectByName('bufferBar').data = createBufferBar();
			interfaceItemList.getObjectByName('seekBar').data = createSeekBar();
			interfaceItemList.getObjectByName('seeker').data = createSeeker();
			interfaceItemList.getObjectByName('volumeBarBG').data = createVolumeBarBG();
			interfaceItemList.getObjectByName('volumeBar').data = createVolumeBar();
			interfaceItemList.getObjectByName('volumeButton').data = createVolumeButton();
			interfaceItemList.getObjectByName('volumeSeeker').data = createVolumeSeeker();
			interfaceItemList.getObjectByName('fullscreenButton').data = createFullscreenButton();
			interfaceItemList.getObjectByName('x2Button').data = createX2Button();
			//interfaceItemList.getObjectByName('resizeButton').data = createResizeButton();
			interfaceItemList.getObjectByName('shareButton').data = createShareButton();
			interfaceItemList.getObjectByName('sharePanel').data = createSharePanel(share);
			interfaceItemList.getObjectByName('downloadButton').data = createDownloadButton();
			interfaceItemList.getObjectByName('screenshotButton').data = createScreenshotButton();
			interfaceItemList.getObjectByName('playListButton').data = createPlayListButton();
			interfaceItemList.getObjectByName('playList').data = createPlayList();
			interfaceItemList.getObjectByName('bulle').data = createBulle();
			interfaceItemList.getObjectByName('time').data = createTime();
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																				  INTERFACE COMPONENTS
		// ���������������������������������������������������������������������������������������������������
		protected function createBG():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var b:GraphicShape = new GraphicShape();
				b.rectangle( 0x000000, 0, 0, _width, _height );
				result.addChild( b );

			return result; 
		}
		protected function createBGimage():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				result.addChild( new Bitmap( _backgroundImage, 'always', true ) );

			return result; 
		}
		protected function createMask():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var m:GraphicShape = new GraphicShape();
				m.rectangle( 0x000000, 0, 0, _width, _height );
				result.addChild( m );

			return result; 
		}
		protected function createLoading():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result;  
		}
		protected function createPlayPauseButton():DynamicRegistration { 
			var placement:Object = { x:_width/2-50, y:_height/2-20, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var play:TextLink = new TextLink('play','dynamic','PLAY',0xfe5815,_fonts['itcStone'],false,19,'center',true,false,false,false,'',60,30);
				var pause:TextLink = new TextLink('pause','dynamic','PAUSE',0xfe5815,_fonts['itcStone'],false,19,'center',true,false,false,false,'',150,30);
				
				var playPause:AnimatedClip = new AnimatedClip( 2 );
				playPause.addFrameContent( 0, play );
				playPause.addFrameContent( 1, pause );
				result.addChild( playPause );
				
				LinkManager.add('playPause', result, { playPause: { objet:result, colors:null, action:null }}, 'mouse', function(type:String,o:*)
				{
					if ( type == 'do') Tweener.addTween( playPause.currentFrame.data, { alpha:0, time:.2, onComplete:function(){ playPause.nextFrame(); Tweener.addTween( playPause.currentFrame.data, { alpha:1, time:.4 } ); }} );
					else if ( type == 'undo') Tweener.addTween( playPause.currentFrame.data, { alpha:0, time:.4, onComplete:function(){ playPause.previousFrame(); Tweener.addTween( playPause.currentFrame.data, { alpha:1, time:.4 } ); }} );
				} );
					
			return result; 
		}
		protected function createReplayButton():DynamicRegistration { 
			var placement:Object = { x2:_width>>1, y2:_height/2, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var replay:TextLink = new TextLink('share', 'dynamic', '<font face="' + _fonts['itcStone'] + '" size="19" color="#fe5815">REPLAY </font> <font face="' + _fonts['itcStone'] + '" size="19" color="#ffffff">THIS VIDEO ?</font>', 0xffffff, _fonts['itcStone'], true, 19, 'center', false, true, false, false, '', 185, 30);
				replay.alpha = 0;
				result.addChild( replay );
				result.buttonMode = true;
				result.mouseChildren = false;
			return result; 
		}
		protected function createBufferBar():DynamicRegistration { 
			var placement:Object = { x:0, y:_height-4, alpha:1, size:_width, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
				
				var bb:GraphicShape = new GraphicShape();
				bb.rectangle(0x545454, 0, 0, _width, 4);
				result.addChild( bb );

			return result; 
		}
		protected function createSeekBar():DynamicRegistration { 
			var placement:Object = { x:0, y:_height-4, alpha:1, size:_width, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var sb:GraphicShape = new GraphicShape();
				sb.rectangle(0xfe5815, 0, 0, 1, 4);
				result.addChild( sb );
			
			return result; 
		}
		protected function createSeeker():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result; 
		}
		protected function createVolumeBarBG():DynamicRegistration { 
			var placement:Object = { x:_width>>1, y:_height*.6, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			result.buttonMode = true;
			
				var barre:GraphicShape = new GraphicShape();
				barre.roundRectangle(0x2e2e2e,0,0,26,71,15,15);
				result.addChild( barre );
			
			return result; 
		}
		protected function createVolumeBar():DynamicRegistration { 
			var placement:Object = { x:_width>>1, y:_height*.6, size:71, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			result.mouseEnabled = false;
			result.mouseChildren = false;
			
				var barre:GraphicShape = new GraphicShape();
				barre.roundRectangle(0x4a4a4a,0,0,26,71,15,15);
				result.addChild( barre );
			
			return result; 
		}
		protected function createVolumeButton():DynamicRegistration { 
			var placement:Object = { x:_width-100, y:height-24, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result; 
		}
		protected function createVolumeSeeker():DynamicRegistration { 
			var placement:Object = { x:200, y:200, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result; 
		}
		protected function createFullscreenButton():DynamicRegistration { 
			var placement:Object = { x:_width/2-7, y:_height/2, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
				var full:TextLink = new TextLink('x2','dynamic','FULLSCREEN',0xffffff,_fonts['itcStone'],true,14,'left',false,false,false,true,TextLink.AUTOSIZE_LEFT )
				full.alpha = .28;
				
				LinkManager.add('full', result, { full: { objet:result, colors:null, action:null }}, 'mouse', function(type:String,o:*)
				{
					if ( type == 'do') Tweener.addTween( full, { alpha:0, time:.5 } );
					else if ( type == 'undo') Tweener.addTween( full, { alpha:0, time:.28 } );
				} );
				
			result.addChild( full );
				
			return result; 
		}
		protected function createX2Button():DynamicRegistration { 
			var placement:Object = { x:_width/2-7, y:_height/2, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			result.visible = false;
				var x2:AnimatedClip = new AnimatedClip( 2 );
				x2.alpha = .28;
				x2.addFrameContent( 0, new TextLink('X2','dynamic','X2',0xffffff,_fonts['itcStone'],true,14,'left',false,false,false,true,TextLink.AUTOSIZE_LEFT ) );
				x2.addFrameContent( 1, new TextLink('NORMAL', 'dynamic', 'NORMAL', 0xffffff, _fonts['itcStone'], true, 14, 'left',false, false,false, true, TextLink.AUTOSIZE_LEFT ) );
				result.addChild( x2 );
				
				LinkManager.add('x2', result, { x2: { objet:result, colors:null, action:null }}, 'mouse', function(type:String,o:*)
				{
					if ( type == 'do') Tweener.addTween( x2.currentFrame.data, { alpha:0, time:.2, onComplete:function(){ x2.nextFrame(); Tweener.addTween( x2.currentFrame.data, { alpha:1, time:.4 } ); }} );
					else if ( type == 'undo') Tweener.addTween( x2.currentFrame.data, { alpha:0, time:.4, onComplete:function(){ x2.previousFrame(); Tweener.addTween( x2.currentFrame.data, { alpha:1, time:.4 } ); }} );
				} );
			
			return result; 
		}
		protected function createShareButton():DynamicRegistration { 
			var placement:Object = { x:_width/2+5, y:_height/2-20, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var share:TextLink = new TextLink( 'share', 'dynamic', 'SHARE ME', 0xffffff, _fonts['itcStone'], true, 19, 'left', false,false, false, true, TextLink.AUTOSIZE_LEFT );
				result.addChild( share );
				LinkManager.add('shareButton', share, { share: { objet:share, colors:null, action:txtHoverOut }}, 'mouse' );
			
			return result; 
		}
		protected function createSharePanel( share:String ):DynamicRegistration {
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			result.visible = false;
			
				var bg:GraphicShape = new GraphicShape();
				bg.rectangle( 0x000000, 0, 0, _width, _height );
				result.addChild( bg );
				
				var txt:TextLink = new TextLink('share', 'dynamic', share, 0xffffff, _fonts['itcStone'], true, 8, 'left', true, false, false, false, '', _width - 120, _height - 120);
				txt.y2 = _height >> 1;
				result.addChild( txt );
			
			return result; 
		}
		protected function createDownloadButton():DynamicRegistration { 
			var placement:Object = { x:_width/2-95, y:_height/2, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var dwl:TextLink = new TextLink( 'download', 'dynamic', 'DOWNLOAD', 0xffffff, _fonts['itcStone'], true, 14, 'left', false, false, false, true, TextLink.AUTOSIZE_LEFT );
				dwl.alpha = .28;
				result.addChild( dwl );
				LinkManager.add('downloadButton', dwl, { dwl: { objet:dwl, colors:null, action:txtHoverOut }}, 'mouse' );
				
			return result; 
		}
		protected function createScreenshotButton():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var bg:GraphicShape = new GraphicShape();
				bg.rectangle( 0x0d0d0d, 0, 0, _width, 24 );
				result.addChild( bg );
			
				var sc:GraphicShape = new GraphicShape();
				sc.drawPixels( 0xffffffff, PixelShapes.cam() );
				sc.x2 = _width >> 1;
				sc.y = 3;
				sc.alpha = .25;
				result.addChild( sc );
				
				LinkManager.add('screenshotButton', result, { screenshot: { objet:result, colors:null, action:function(type:String,o:*)
				{
					if ( type == 'hover') Tweener.addTween( sc, { alpha:.5, time:.4 } );
					else if ( type == 'out') Tweener.addTween( sc, { alpha:.25, time:.4 } );
				}
				}}, 'mouse' );
			
			return result; 
		}
		protected function createPlayListButton():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result; 
		}
		protected function createPlayList():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result; 
		}
		protected function createBulle():DynamicRegistration { 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			return result; 
		}
		protected function createTime():DynamicRegistration { 
			var placement:Object = { x:width/2-95, y:_height/2-20, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );
			
				var time:TextLink = new TextLink( 'time', 'dynamic', "00'00", 0xffffff, _fonts['itcStone'], true, 18, 'left',false, false,false, true, TextLink.AUTOSIZE_LEFT );
				result.addChild( time );
			
			return result; 
		}
		/*protected function createResizeButton():DynamicRegistration{ 
			var placement:Object = { x:0, y:0, alpha:1, resize:function(){ } };
			var result:DynamicRegistration = new DynamicRegistration( placement );

			return result; 
		}*/
		
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																					  INTERFACE LAYOUT
		// ���������������������������������������������������������������������������������������������������
		private function createLayout():void {
			for ( var i:int=0; i < interfaceItemList.length; i++ )
			{
				var node:ObjectNode = interfaceItemList.iterate(i);
				if ( node.data.extra.x != undefined ) node.data.x =  node.data.extra.x;
				else if ( node.data.extra.x2 != undefined ) node.data.x =  node.data.extra.x2;
				if ( node.data.extra.y != undefined ) node.data.y =  node.data.extra.y;
				else if ( node.data.extra.y2 != undefined ) node.data.y2 =  node.data.extra.y2;
				if ( node.data.extra.alpha != undefined ) node.data.alpha =  node.data.extra.alpha;
				
				//ResizeManager.add( prop, node.data, node.data.extra.resize );
				node.data.name = node.name;
				container.addChild( node.data );
			}
			if ( _enableMask ) container.mask = containerMask;	
			if ( _standalone && _enablefullscreen ) FullScreenMode.Activate( interfaceItemList.getObjectByName('fullscreenButton').data, Current.stage );
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																					 GESTION LISTENERS
		// ���������������������������������������������������������������������������������������������������
		private function initListeners():void 
		{
			stream.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
            stream.addEventListener( NetStatusEvent.NET_STATUS, manageEvent, false, 0, true );
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
			stream.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
            stream.removeEventListener( NetStatusEvent.NET_STATUS, manageEvent );
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
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																					ADD INTERFACE ITEM
		// ���������������������������������������������������������������������������������������������������
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
			for ( var i:int=0; i < interfaceItemList.length; i++ ){
				var node:ObjectNode = interfaceItemList.iterate(i);
				if( insertPoint == node.data.name ){
					if ( insertMode == 'before') interfaceItemList.insertBefore( node, name, item );
					else if ( insertMode == 'after') interfaceItemList.insertAfter( node, name, item );
					break;
				}
			}
			
		}
		
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																						  PARSE CONFIG
		// ���������������������������������������������������������������������������������������������������
		private function parseConfig( config:Array ):void {}
		
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																						   SORT ZINDEX
		// ���������������������������������������������������������������������������������������������������
		private function sortZindex( zindex:Object ):void {}
		
		
		
		// ��������������������������������������������������������������������������������������������������
		// 																				     	  IMAGE SAVER
		// ��������������������������������������������������������������������������������������������������
		private function screenshot( name:String ):void {
			//--vars
			var toSave:ByteArray;
			var bmp:BitmapData = new BitmapData( _videoWidth, _videoHeight );
			var saveImg:FileSaver = new FileSaver( name );
			
			bmp.draw( interfaceItemList.getObjectByName('videoContainer').data );
			toSave = PNGEncoder.encode( bmp );
			saveImg.create( 'local','assets\images',name, 'png', toSave, true );
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																					     	 METADATAS
		// ���������������������������������������������������������������������������������������������������
		private  function onVideoMetaData( metaData:Object ):void {
			streamMetadata = metaData;
		}
		
		private  function onVideoCuePoint( evt:* ):void {
			//return evt;
		}
		
		private  function onVideoPlayStatus( evt:* ):void {
			//return evt;
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																				  			   DISPOSE
		// ���������������������������������������������������������������������������������������������������
		public function dispose(){
			delListeners();
			video = null;
		}
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																					      MANAGE EVENT
		// ���������������������������������������������������������������������������������������������������
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
						
						interfaceItemList.getObjectByName( 'bufferBar' ).data.width = interfaceItemList.getObjectByName( 'bufferBar' ).data.extra.size * loaded;
						interfaceItemList.getObjectByName( 'seekBar' ).data.width = interfaceItemList.getObjectByName( 'seekBar' ).data.extra.size * played;
						interfaceItemList.getObjectByName( 'seeker' ).data.x2 = interfaceItemList.getObjectByName( 'seekBar' ).data.width+interfaceItemList.getObjectByName( 'seekBar' ).data.x;
						
						
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
							interfaceItemList.getObjectByName('seeker').data.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
							break;
							
						case 'volumeseeker':
							interfaceItemList.getObjectByName('volumeSeeker').data.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
							break;	
					}
					break;
				
				case MouseEvent.MOUSE_DOWN :
					switch( evt.currentTarget.name ){
						case 'seeker':
							interfaceItemList.getObjectByName('seeker').data.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
							break;
							
						case 'volumeseeker':
							interfaceItemList.getObjectByName('volumeSeeker').data.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
							break;	
					}
					break;
					
				case MouseEvent.MOUSE_MOVE :
					switch( evt.currentTarget.name ){
						case 'seeker':
							stream.seek( (interfaceItemList.getObjectByName('seeker').data.extra.pos*streamMetadata.duration)/interfaceItemList.getObjectByName('seekBar').data.extra.size );
							break;
							
						case 'volumeseeker':
							volume.volume = (interfaceItemList.getObjectByName('volumeSeeker').data.extra.pos*100)/interfaceItemList.getObjectByName('volumeBar').data.extra.size;
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
		
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																					     GETTER/SETTER
		// ���������������������������������������������������������������������������������������������������
		public override function get name():String { return _name; }
		
		public override function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void 
		{
			_url = value;
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
			interfaceItemList.getObjectByName('shareButton').data.visible = value;
		}
		
		public function get enableDownload():Boolean { return _enableDownload; }
		
		public function set enableDownload(value:Boolean):void 
		{
			_enableDownload = value;
			interfaceItemList.getObjectByName('downloadButton').data.visible = value;
		}
		
		public function get enablefullscreen():Boolean { return _enablefullscreen; }
		
		public function set enablefullscreen(value:Boolean):void 
		{
			_enablefullscreen = value;
			interfaceItemList.getObjectByName('fullscreenButton').data.visible = value;
		}
		
		public function get enablePlaylist():Boolean { return _enablePlaylist; }
		
		public function set enablePlaylist(value:Boolean):void 
		{
			_enablePlaylist = value;
			interfaceItemList.getObjectByName('playList').data.visible = value;
			interfaceItemList.getObjectByName('playListButton').data.visible = value;
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
			interfaceItemList.getObjectByName('x2Button').data.visible = value;
		}
		
		public function get enableScreenshot():Boolean { return _enableScreenshot; }
		
		public function set enableScreenshot(value:Boolean):void 
		{
			_enableScreenshot = value;
			interfaceItemList.getObjectByName('screenshotButton').data.visible = value;
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