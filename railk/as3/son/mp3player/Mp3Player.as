/**
* Basic extendable mp3 player
* 
* @author Richard Rodney.
* @version 0.2
* 
* TODO:
*   _External config parsing 
* 	_sort new Zindex
* 
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
	import railk.as3.display.GraphicShape;
	import railk.as3.data.parser.Parser;
	import railk.as3.root.Current;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.text.TextLink;
	import railk.as3.utils.DynamicRegistration;
	import railk.as3.utils.link.LinkManager;
	import railk.as3.utils.Logger;
	import railk.as3.utils.tag.TagManager;
	import railk.as3.utils.Utils;
	
	// ___________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	// _______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	
	
	
	public class Mp3Player extends DynamicRegistration  
	{
		// _____________________________________________________________________________ VARIABLES RAPATRIEES
		private var _name                               :String;
		private var _sound                              :Sound;
		private var _soundPath                          :String;
		private var _duration                           :Number;
		private var _width                              :Number;
		private var _height                             :Number;
		private var _playListContent                    :Array;
		private var _config                             :Array;
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
		
		// _______________________________________________________________________________ SORTLIST VARIABLES
		private var sortList                            :DLinkedList;
		private var walker                              :DListNode;
		private var itr                                 :DListIterator;
		
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var container                           :DynamicRegistration;											
		private var bg                                  :DynamicRegistration;
		private var mask                                :DynamicRegistration;
		private var playPauseButton                     :DynamicRegistration;
		private var bufferBar                           :DynamicRegistration;
		private var seekBar                             :DynamicRegistration;
		private var seeker                              :DynamicRegistration;
		private var volumeBar                           :DynamicRegistration;
		private var volumeButton                        :DynamicRegistration;
		private var volumeSeeker                        :DynamicRegistration;
		private var shareButton                         :DynamicRegistration;
		private var downloadButton                      :DynamicRegistration;
		private var playListButton                      :DynamicRegistration;
		private var playList                            :DynamicRegistration;
		private var tagList                             :DynamicRegistration;
		private var bulle                               :DynamicRegistration;
		private var interfaceItemList                   :Object = {
																	bg:bg,
																	playList:playList,
																	bufferBar:bufferBar,
																	seekBar:seekBar,
																	seeker:seeker,
																	playPauseButton:playPauseButton,
																	volumeBar:volumeBar,
																	volumeButton:volumeButton,
																	volumeSeeker:volumeSeeker,
																	shareButton:shareButton,
																	downloadButton:downloadButton,
																	playListButton:playListButton,
																	tagList:tagList,
																	bulle:bulle,
																	mask:mask };
																	
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
		public function init( name:String = '', sound:Sound, width:Number, height:Number, playListContent:Array=null, config:XML=null ):void 
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
			_config = Parser.XMLItem( config );
			
			
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
			container = new Sprite();
			addChild( container );
				
			//--enable volume modification
			volume = new SoundTransform();
			stream.soundTransform = volume;
			
			//--soundchannel
			channel = new SoundChannel()
			channel.soundTransform = volume;
			
			//--prepare interface list
			for ( var prop in _interfaceItemList )
			{
				interfaceItemList[prop].name = prop;
			}
			
			//////////////////////////
			create();
			//////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	  CREATION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function create():void 
		{
			///////////////////////////////
			bg = createBG();
			mask = createMask();
			playPauseButton = createPlayPauseButton();
			bufferBar = createBufferBar();
			seekBar = createSeekBar();
			seeker = createSeeker();
			volumeBar = createVolumeBar();
			volumeButton = createVolumeButton();
			volumeSeeker = createVolumeSeeker();
			shareButton = createShareButton();
			downloadButton = createDownloadButton();
			playListButton = createPlayListButton();
			playList = createPlayList();
			tagList = createTagList();
			bulle = createBulle();
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

			return result; 
		}
		protected function createMask():DynamicRegistration
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
			var sortList:DLinkedList = new DLinkedList();
			var insertMode = insert.split(':')[0];
			var insertPoint = insert.split(':')[1];
			item.name = name;
			
			//--list
			for ( var prop in interfaceItemList )
			{
				sortList.append( interfaceItemList[prop] );
			}
			
			//--sort
			walker = sortList.head;
			while ( walker ) {
				if( insertPoint == walker.data.name ){
					itr = new DListIterator(sortList, walker);
					if ( insertMode == 'before') sortList.insertBefore( itr, item );
					else if ( insertMode == 'after') sortList.insertAfter( itr, item );
					inserted = true;
					break;
				}
				walker = walker.next;
			}
			
			//--to object list
			interfaceItemList = new Object();
			walker = sortList.head;
			while ( walker ) {
				interfaceItemList[walker.data.name] = walker.data;
				walker = walker.next;
			}
			
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  PARSE CONFIG
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function parseConfig( config:Array ):void {}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   SORT ZINDEX
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function sortZindex( zindex:Array ):void {}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 	LAYOUT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createLayout():void {
			for ( var prop in _interfaceItemList )
			{
				if ( interfaceItemList[prop].extra.x != undefined ) interfaceItemList[prop].x =  interfaceItemList[prop].extra.x;
				else if ( interfaceItemList[prop].extra.x2 != undefined ) interfaceItemList[prop].x =  interfaceItemList[prop].extra.x2;
				if ( interfaceItemList[prop].extra.y != undefined ) interfaceItemList[prop].y =  _interfaceItemList[prop].extra.y;
				else if ( interfaceItemList[prop].extra.y2 != undefined ) interfaceItemList[prop].y2 =  interfaceItemList[prop].extra.y2;
				if ( interfaceItemList[prop].extra.alpha != undefined ) interfaceItemList[prop].alpha =  interfaceItemList[prop].extra.alpha;
				
				container.addChild( interfaceItemList[prop] );
			}
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 GESTION LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void 
		{
			channel.addEventListener(  Event.SOUND_COMPLETE, manageEvent, false, 0, true );
			seeker.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			seeker.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			volumeSeeker.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			volumeSeeker.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			volumeButton.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			playPauseButton.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			volumeBar.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			shareButton.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			downloadButton.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		private function delListeners():void 
		{
			channel.removeEventListener(  Event.SOUND_COMPLETE, manageEvent );
			seeker.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			seeker.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			volumeSeeker.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			volumeSeeker.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			volumeButton.removeEventListener( MouseEvent.CLICK, manageEvent );
			playPauseButton.removeEventListener( MouseEvent.CLICK, manageEvent );
			volumeBar.removeEventListener( MouseEvent.CLICK, manageEvent );
			shareButton.removeEventListener( MouseEvent.CLICK, manageEvent );
			downloadButton.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		
		
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
		private function manageEvent( evt:* ):void {
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
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get sound():Sound { return _stream; }
		
		public function set sound(value:Sound):void 
		{
			_sound = value;
		}
		
		public function get soundPath():String { return _streamPath; }
		
		public function set streamPath(value:String):void 
		{
			_soundPath = value;
		}
		
		public function get duration():Number { return _duration; }
		
		public function set duration(value:Number):void 
		{
			_duration = value;
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
		
		public function get enablePlaylist():Boolean { return _enablePlaylist; }
		
		public function set enablePlaylist(value:Boolean):void 
		{
			_enablePlaylist = value;
			playList.visible = value;
			playListButton.visible = value;
		}
		
		public function get playListContent():Array { return _playListContent; }
		
		public function set playListContent(value:Array):void 
		{
			_playListContent = value;
		}
		
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