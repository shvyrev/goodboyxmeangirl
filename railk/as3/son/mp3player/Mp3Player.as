/**
* Basic extendable mp3 player
* 
* @author Richard Rodney.
* @version 0.2
* 
* TODO:
*   _External config parsing 
* 	_sort new Zindex
*/

package railk.as3.son.mp3player {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.system.System;

	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.DSprite;
	import railk.as3.display.GraphicShape;
	import railk.as3.data.parser.Parser;
	import railk.as3.root.Current;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.text.TextLink;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.link.LinkManager;
	import railk.as3.utils.Logger;
	import railk.as3.utils.tag.TagManager;
	import railk.as3.utils.Utils;
	import railk.as3.utils.objectList.*;
	
	
	
	public class Mp3Player extends RegistrationPoint  
	{
		// _____________________________________________________________________________ VARIABLES RAPATRIEES
		private var _name                               :String;
		private var _sound                              :Sound;
		private var _soundPath                          :String;
		private var _duration                           :Number;
		private var _width                              :Number;
		private var _height                             :Number;
		private var _playListContent                    :Array;
		private var _config                             :*;
		private var _interfaceZindexList                :Object = null;
		
		// _______________________________________________________________________________ VARIABLES CONTRÔLE
		private var _enableShare                        :Boolean;
		private var _enableDownload                     :Boolean;
		private var _enablePlaylist                     :Boolean;
		
		// __________________________________________________________________________________ VARIABLES SOUND
		private var channel                             :SoundChannel;
		private var volume                              :SoundTransform;
		private var loaded                              :Number;
		private var played                              :Number;
		private var total                               :Number;
		private var current                             :Number;
		private var time                                :String;
		
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var container                           :DSprite;
		private var mask                                :DSprite;
		
		private var components                          :DSprite;
		private var currentNode                         :ObjectNode;
		private var interfaceItemList                   :ObjectList = {
																	['bg', component],
																	['playList',component],
																	['bufferBar',component],
																	['seekBar',component],
																	['seeker',component],
																	['playPauseButton',component],
																	['volumeBarBG',component],
																	['volumeBar',component],
																	['volumeButton',component],
																	['volumeSeeker',component],
																	['shareButton',component],
																	['downloadButton',component],
																	['playListButton',component],
																	['bulle',component],
																	['time',component],
																	['sharePanel',component] };
																	
		// _________________________________________________________________________________ VARIABLES PLAYER															
		private var share                               :String
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRCUTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function Mp3Player():void{}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  		  INIT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	sound
		 * @param	soundPath
		 * @param	duration
		 * @param	width
		 * @param	height
		 * @param	playListContent
		 * @param	config               xmlfile <configs><path>needed</path>...</configs>
		 */
		public function init( name:String = '', sound:Sound, width:Number, height:Number, config:Class, playListContent:Array=null ):void 
		{
			//--logger
			Logger.print( 'FlvPlayer' + name +'enabled', Logger.MESSAGE );
			
			//--managers
			TagManager.init();
			ResizeManager.init();
			LinkManager.init( 'flvplayer' )
			
			//--vars
			_name = name;
			_sound = sound;
			_soundPath = sound.url;
			_duration = sound.length;
			_width = width;
			_height = height;
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
			_config.init( width, height, fonts, share );
			
			//--main container
			container = new Sprite();
			addChild( container );
				
			//--enable volume modification
			volume = new SoundTransform();
			stream.soundTransform = volume;
			
			//--soundchannel
			channel = new SoundChannel()
			channel.soundTransform = volume;
			
			//////////////////////////
			createComponents();
			createLayout();
			initListeners();
			//////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	  CREATION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createComponents():void 
		{
			containerMask = _config.createMask();
			///////////////////////////////
			interfaceItemList.getObjectByName( 'bg' ).data = _config.createBG();
			interfaceItemList.getObjectByName( 'playPauseButton').data = _config.createPlayPauseButton();
			interfaceItemList.getObjectByName( 'bufferBar').data = _config.createBufferBar();
			interfaceItemList.getObjectByName( 'seekBar').data = _config.createSeekBar();
			interfaceItemList.getObjectByName( 'seeker').data = _config.createSeeker();
			interfaceItemList.getObjectByName( 'volumeBarBG').data = _config.createVolumeBarBG();
			interfaceItemList.getObjectByName( 'volumeBar').data = _config.createVolumeBar();
			interfaceItemList.getObjectByName( 'volumeButton').data = _config.createVolumeButton();
			interfaceItemList.getObjectByName( 'volumeSeeker').data = _config.createVolumeSeeker();
			interfaceItemList.getObjectByName( 'sharePanel').data = _config.createSharePanel();
			interfaceItemList.getObjectByName( 'shareButton').data = _config.createShareButton();
			interfaceItemList.getObjectByName( 'downloadButton').data = _config.createDownloadButton();
			interfaceItemList.getObjectByName( 'playListButton').data = _config.createPlayListButton();
			interfaceItemList.getObjectByName( 'playList').data = _config.createPlayList();
			interfaceItemList.getObjectByName( 'time').data = _config.createTime();
			interfaceItemList.getObjectByName( 'bulle').data = _config.createBulle();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 	LAYOUT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createLayout():void {
			currentNode = interfaceItemList.head;
			loop:while ( currentNode ) {
				if ( currentNode.data.extra.x != undefined ) currentNode.data.x =  currentNode.data.extra.x;
				else if ( currentNode.data.extra.x2 != undefined ) currentNode.data.x =  currentNode.data.extra.x2;
				if ( currentNode.data.extra.y != undefined ) currentNode.data.y =  currentNode.data.extra.y;
				else if ( currentNode.data.extra.y2 != undefined ) currentNode.data.y2 =  currentNode.data.extra.y2;
				if ( currentNode.data.extra.alpha != undefined ) currentNode.data.alpha =  currentNode.data.extra.alpha;
				
				currentNode.data.name = currentNode.name;
				container.addChild( currentNode.data );
				currentNode = currentNode.next;
			}
			if ( _enableMask ) container.mask = containerMask;	
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 GESTION LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void 
		{
			channel.addEventListener(  Event.SOUND_COMPLETE, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('seeker' ).data.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('seeker' ).data.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeSeeker' ).data.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeSeeker' ).data.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeButton' ).data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('playPauseButton' ).data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('volumeBar' ).data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('shareButton' ).data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			interfaceItemList.getObjectByName('downloadButton' ).data.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		private function delListeners():void 
		{
			channel.removeEventListener(  Event.SOUND_COMPLETE, manageEvent );
			interfaceItemList.getObjectByName('seeker' ).data.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			interfaceItemList.getObjectByName('seeker' ).data.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			interfaceItemList.getObjectByName('volumeSeeker' ).data.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			interfaceItemList.getObjectByName('volumeSeeker' ).data.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			interfaceItemList.getObjectByName('volumeButton' ).data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('playPauseButton' ).data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('volumeBar' ).data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('shareButton' ).data.removeEventListener( MouseEvent.CLICK, manageEvent );
			interfaceItemList.getObjectByName('downloadButton' ).data.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		
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
		public function addInterfaceItem( name:String, item:*, insert:String, group:String = '', action:Function = null ):void 
		{
			var insertMode = insert.split(':')[0];
			var insertPoint = insert.split(':')[1];
			item.name = name;
			
			//--add
			currentNode = list.head;
			loop:while ( currentNode ) {
				if( insertPoint == currentNode.data.name ){
					if ( insertMode == 'before') interfaceItemList.insertBefore( currentNode, name, item, group, action );
					else if ( insertMode == 'after') interfaceItemList.insertAfter( currentNode, name, item, group, action  );
					break loop;
				}
				currentNode = currentNode.next;
			}
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   SORT ZINDEX
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function sortZindex( zindex:Array ):void {}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose()
		{
			delListeners();
			_sound = null;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					      MANAGE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void 
		{
			switch( evt.type )
			{
				case Event.SOUND_COMPLETE :
					//place volume seeker;
					break;
				
				case Event.ENTER_FRAME :
					current = Math.floor( stream.time );	
					total = Math.round( _duration );
					played = _sound. / _duration;
					loaded = stream.bytesLoaded / stream.bytesTotal;
					time = Utils.numberToTime( played );
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
							channel = _sound.play( (seeker.extra.pos*_duration)/seekBar.extra.size );
							break;
							
						case 'volumeseeker':
							volume.volume = (volumeSeeker.extra.pos*100)/volumeBar.extra.size;
							channel.soundTransform = volume;
							break;	
					}
					evt.updateAfterEvent();
					break;
					
				case MouseEvent.CLICK :
					switch( evt.target.name )
					{
						case 'playpausebutton':
							if ( LinkManager.getLink( 'playpausebutton').isActive() )
							{
								channel = _sound.play( current );
							}
							else
							{
								channel.stop();
							}
							break;
							
						case 'volumebutton':
							if ( LinkManager.getLink( 'volumebutton').isActive() )
							{
								Tweener.addTween( volume, { volume:(volumeSeeker.extra.pos*100)/volumeBar.extra.size, time:.4, onUpdate:function(){ channel.soundTransform = volume; } } );
							}
							else
							{
								Tweener.addTween( volume, { volume:0, time:.4, onUpdate:function(){ channel.soundTransform = volume; } } );
							}
							break;
						
						case 'sharebutton':
							System.setClipboard( share );
							break;
						
						case 'downloadbutton':
							navigateToURL( _streamPath, '_blank' );
							break;
					}
					break;
			}
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					     GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get name():String { return _name; }
		
		public function set name(value:String):void { _name = value; }
		
		public function get sound():Sound { return _stream; }
		
		public function set sound(value:Sound):void { _sound = value;}
		
		public function get soundPath():String { return _streamPath; }
		
		public function set streamPath(value:String):void { _soundPath = value; }
		
		public function get duration():Number { return _duration; }
		
		public function set duration(value:Number):void { _duration = value; }
				
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
		
		public function get enablePlaylist():Boolean { return _enablePlaylist; }
		
		public function set enablePlaylist(value:Boolean):void 
		{
			_enablePlaylist = value;
			playList.visible = value;
			playListButton.visible = value;
		}
		
		public function get playListContent():Array { return _playListContent; }
		
		public function set playListContent(value:Array):void { _playListContent = value; }
		
		public function get interfaceZindexList():Object { return _interfaceZindexList; }
		
		public function set interfaceZindexList(value:Object):void 
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