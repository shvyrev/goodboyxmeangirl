/**
* 
* MultiLoader class
* 
* @author richard rodney
* @version 0.1
* 
* todo
* 
* 
*/

package railk.as3.data.loader {
	
	// __________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	import flash.media.Sound;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	// __________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.loader.MultiLoaderEvent;
	import railk.as3.data.loader.loaderItems.MultiLoaderItem;
	
	// _____________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	

	public class MultiLoader extends Sprite {
		
		// ________________________________________________________________________________ VARIABLES STATIQUES
		public static var MLoaderList                        :Object={};
		
		// ______________________________________________________________________________ MULTILOADER VRAIABLES
		private var MloaderName                              :String;
		private var MloaderRole                              :String;
		private var MLoaderPercent                           :Number = 1;
		
		private var _maxSlots                                :int = 7;
		private var _takenSlots                              :int = 0;
		private var _state                                   :String = "stop";
		
		
		// _________________________________________________________________________________ ITEMLIST VARIABLES
		private var itemsList                                :DLinkedList;
		private var walker                                   :DListNode;
		private var itr                                      :DListIterator;

		
		// _____________________________________________________________________________________ ITEM VRAIABLES
		private var item                                     :MultiLoaderItem;
		private var itemURL                                  :URLRequest
		private var itemName                                 :String;
		private var itemMode                                 :String;
		private var itemArgs                                 :Object;
		private var itemType                                 :String;
		private var itemPriority                             :int;
		private var itemState                                :String;
		private var itemPreventCache                         :Boolean;
		private var itemBufferSize                           :int;
		private var itemSaveState                            :Boolean;
		private var itemContent                              :*;
		private var itemNumber                               :int = 0;
		
		
		// ____________________________________________________________________________________ TYPES VARIABLES
		private var types                                    :Object = {
            ".jpg":"imgfile", ".jpeg":"imgfile", ".png":"imgfile", ".gif":"imgfile",
            ".swf":"swffile",
            ".xml":"xmlfile",
			".txt":"txtfile", ".js":"txtfile", ".php":"txtfile",
			".drw":"binaryfile", ".flow":"binaryfile", ".flod":"binaryfile", ".zip":"binaryfile",
            ".flv":"flvfile", ".f4v":"flvfile", ".mp4":"flvfile", ".m4a":"flvfile", ".mov":"flvfile", ".mp4v":"flvfile", ".3gp":"flvfile", ".3g2":"flvfile",
            ".mp3":"soundfile", ".f4a":"soundfile", ".f4b":"soundfile"
        }
		
		
		// ___________________________________________________________________________________ EVENT VARIABLES
		private var eEvent                                   :MultiLoaderEvent;		
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		/**
		 * 
		 * @param	name
		 * @param	role
		 * @param	mode   'local'| 'server'
		 */
		public function MultiLoader( name:String, role:String="", mode:String="server" ):void {
			trace("      						 MultiLoader "+name+" initialise");
			trace("---------------------------------------------------------------------------------------");
			//--
			MLoaderList[name] = this;
			MloaderName = name;
			MloaderRole = role;
			//--
			itemsList = new DLinkedList();
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					MLOADER MANAGEMENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		/**
		 * 
		 * @param	nbSlot | maximum recommended slots is 7
		 */
		public function start( nbSlot:int = 7 ):void {
			//initSlots
			_maxSlots = nbSlot;
			//on bouge les fichier a telecharger de la waiting list a la loading list et on les actives
			walker = itemsList.head;
			//--
			while ( _takenSlots < _maxSlots && walker ) {
				//--
				if( walker.data.state == MultiLoaderItem.WAITING ){
					//on lance le t駘馗hargement
					var file:MultiLoaderItem = walker.data;
					walker.data.state = MultiLoaderItem.LOADING;
					file.load();
					//on incr駑ent� les slots pris
					_takenSlots += 1;
				}	
				walker = walker.next;
			}
			
			//mise en place du lsitener pour retourner le pourcentage total de t駘馗harg�
			initMLoaderListener();
			//state
			_state = "start";
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"Multiloader "+MloaderName+" is started" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
		}
		
		
		public function stop():void {
			walker = itemsList.head;
			//--
			while ( walker ) {
				//--
				//on lance le t駘馗hargement
				var file:MultiLoaderItem = walker.data;
				if ( file.state == MultiLoaderItem.LOADING ) {
					file.stop();
					file.state = MultiLoaderItem.WAITING;
				}
				//incrementation
				walker = walker.next;
			}
			
			//state
			_state = "stop";
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"Multiloader "+MloaderName+" is stopped" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERSTOPPED, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		
		public function destroy():void {
			//arrete l'ensemble des download dela loading list et autre liste et supprime l'instace de multiloader
			stop();
			delMLoaderListener();
			//on supprime les listeners de l'ensemble des items mise dans la listes de t駘馗hargement ainsi que les items elles m麥e
			walker = itemsList.head;
			//--
			while ( walker ) {
				//--
				var file:MultiLoaderItem = walker.data;
				delItemListeners( file );
				file.dispose();
				file = null;
				//incrementation
				walker = walker.next;
			}
			
			MLoaderList[MloaderName] = null;
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					   ITEM MANAGEMENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		/**
		 * 
		 * @param	url  | the path of the file to download
		 * @param	priority  | -1=non-prioritaire / 0=normal / 1=prioritaire
		 * @param	mode            'sameDomain' | 'externalDomain';
		 * @param	preventCache |  true / if you want to avoide the broswer cache for the files
		 * @param	bufferSize  | 0=loading the whole before playing / XX=the number of second to buffer before playing
		 * @param	saveAs  | allow the file to be saved by the user
		 */
		public function add( url:String, name:String=  "", args:Object=null, priority:int = 0, mode:String='sameDomain', preventCache:Boolean = false, bufferSize:int = 0, saveAs:Boolean = false ):void {
			//r馗up駻ation du type de fichier ajout�
			itemURL = new URLRequest( url );
			if ( name == "" ) { itemName = url; } else { itemName = name; } 
			itemArgs = args;
			itemMode = mode;
			itemType = getItemType( url );
			itemPriority = priority;
			itemState = MultiLoaderItem.WAITING;
			itemPreventCache = preventCache;
			itemBufferSize = bufferSize;
			itemSaveState = saveAs;
			itemNumber += 1;
			//cre饌tion de l'item
			item = new MultiLoaderItem( itemURL, itemName, itemArgs, itemType, itemPriority, itemState, itemPreventCache, itemBufferSize, itemSaveState, itemMode );
			initItemListeners( item );
			
			/////////////////////////////////////////////////////////////////
			sortList( item );
			/////////////////////////////////////////////////////////////////
		}
		
		
		
		/**
		 * 
		 * @param	url
		 * @param	name
		 * @param	args
		 * @param	mode            'sameDomain' | 'externalDomain';
		 * @param	preventCache
		 * @param	bufferSize
		 * @param	saveAs
		 */
		public function forceLoad( url:String, name:String=  "", args:Object=null, mode:String='sameDomain', preventCache:Boolean=false, bufferSize:int=100, saveAs:Boolean=false ):void {
			//r馗up駻ation du type de fichier ajout�
			itemURL = new URLRequest( url );
			if ( name == "" ) { itemName = url; } else { itemName = name; } 
			if ( args == null) itemArgs = { };
			itemMode = mode;
			itemType = getItemType( url );
			itemPriority = 2;
			itemState = MultiLoaderItem.WAITING;
			itemPreventCache = preventCache
			itemBufferSize = bufferSize;
			itemSaveState = saveAs;
			//cre饌tion de l'item
			item = new MultiLoaderItem( itemURL, itemName, itemArgs, itemType, itemPriority, itemState, itemPreventCache, itemBufferSize, itemSaveState, itemMode );
			initItemListeners( item );
			
			/////////////////////////////////////////////////////////////////
			item.load();
			/////////////////////////////////////////////////////////////////
			
		}
		
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public function removeByName( name:String ):Boolean {
			var result:Boolean;
			walker = itemsList.head;
			//--
			while ( walker ) {
				//--
				var file:MultiLoaderItem = walker.data ;
				if ( file.name == name ) {
					delItemListeners( file );
					file.dispose();
					file = null;
					//suppression du node
					itr = new DListIterator(itemsList, walker);
					itr.remove();
					
					result = true;
				}
				else {
					result = false;
				}
				//incrementation
				walker = walker.next;
			}
			
			return result;
		}
		
		
		/**
		 * 
		 * @param	url
		 * @return
		 */
		public function removeByUrl( url:String ):Boolean {
			var result:Boolean;
			walker = itemsList.head;
			//--
			while ( walker ) {
				//--
				var file:MultiLoaderItem = walker.data ;
				if ( file.url == url ) {
					delItemListeners( file );
					file.dispose();
					file = null;
					//suppression du node
					itr = new DListIterator(itemsList, walker);
					itr.remove();
					
					result = true;
				}
				else {
					result = false;
				}
				//incrementation
				walker = walker.next;
			}
			
			return result;
		}
		
		/**
		 * 
		 * @param	item
		 */
		public function removeAll():void {
			walker = itemsList.head;
			
			while ( walker ) {
				//--
				var file:MultiLoaderItem = walker.data ;
				delItemListeners( file );
				file.dispose();
				file = null;
				//suppression du node
				itr = new DListIterator(itemsList, walker);
				itr.remove();
				//incrementation
				walker = walker.next;
			}
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					   ITEM PROPERTIES
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function getItemType( url:String ):String {
			//recup駻ation de l'extension
			var tmpString:String = url;
			var urlParse:Array = tmpString.split("/");
			tmpString = urlParse[urlParse.length - 1];
			var sep:int = tmpString.indexOf('.');
			var ext:String = tmpString.substring( sep );
			
			//recup駻ation dy type en fonction de l'extension
			var type:String = types[ext.toLowerCase()];
			
			return type;
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					LOADING MANAGEMENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function loadNext():void {

			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"******load next files******" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERLOADNEXT, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////	

			walker = itemsList.head;
			
			while ( walker ) {
				//choix des prochains fichiers � t駘馗harger en fonction de la priorit� et du nombre d'emplacement libre.
				if ( walker.data.state == MultiLoaderItem.WAITING ) {
					walker.data.load();
					walker.data.state = MultiLoaderItem.LOADING;
					_takenSlots += 1;
				}
				if ( _takenSlots == _maxSlots ) {
					trace("*********maxSlots**********");
					break;
				}	
				walker = walker.next;
			}

		}
		
		
		private function checkFile():void {
			//init
			var waiting:Boolean = false;
			var loading:Boolean = false;
			walker = itemsList.tail;
			
			while ( walker ) {
				if ( walker.data.state == MultiLoaderItem.WAITING ) {
					waiting = true;
					break;
				}
				else if ( walker.data.state == MultiLoaderItem.LOADING ) {
					loading = true;
					break;
				}
				walker = walker.prev;
			}
			
			
			//loadNext ?
			if ( waiting == true ) {
				loadNext();
			}
			else {
				if( loading == false ) {
					delMLoaderListener();
					
					//state
					_state = "stop";
					
					///////////////////////////////////////////////////////////////
					//arguments du messages
					var args:Object = { info:"Multiloader "+MloaderName+" is finished" };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERCOMPLETE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////	
				}	
			}
			
		}
		
		
		private function sortList( itm:MultiLoaderItem ):void {
			//--
			var inserted:Boolean = false;
			walker = itemsList.head;
			
			while ( walker ) {
				if( itm.priority > walker.data.priority ){
					itr = new DListIterator(itemsList, walker);
					itemsList.insertBefore( itr, itm );
					inserted = true;
					break;
				}
				walker = walker.next;
			}
			
			if ( inserted == false ) {
				itemsList.append( itm )
			}
			
			walker = itemsList.head;
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																			      LISTENERS MANAGEMENT 
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function initItemListeners( item:MultiLoaderItem ):void {
			item.addEventListener( Event.OPEN, onItemBegin, false, 0, true );
			item.addEventListener( ProgressEvent.PROGRESS, onItemProgress, false, 0, true );
			item.addEventListener( Event.COMPLETE, onItemComplete, false, 0, true );
			item.addEventListener( IOErrorEvent.IO_ERROR, onItemIOerror, false, 0, true );
			item.addEventListener( HTTPStatusEvent.HTTP_STATUS, onItemHttpStatus, false, 0, true );
			item.addEventListener( NetStatusEvent.NET_STATUS, onItemNetStatus, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ONSTREAMREADY, onStreamReady, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ONSTREAMBUFFERING, onStreamBuffering, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ONSTREAMPLAYED, onStreamPlayed, false, 0, true );
		}
		
		private function delItemListeners( item:MultiLoaderItem ):void {
			item.removeEventListener( Event.OPEN, onItemBegin );
			item.removeEventListener( ProgressEvent.PROGRESS, onItemProgress );
			item.removeEventListener( Event.COMPLETE, onItemComplete );
			item.removeEventListener( IOErrorEvent.IO_ERROR, onItemIOerror);
			item.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onItemHttpStatus);
			item.removeEventListener( NetStatusEvent.NET_STATUS, onItemNetStatus );
			item.removeEventListener( MultiLoaderEvent.ONSTREAMREADY, onStreamReady );
			item.removeEventListener( MultiLoaderEvent.ONSTREAMBUFFERING, onStreamBuffering );
			item.removeEventListener( MultiLoaderEvent.ONSTREAMPLAYED, onStreamPlayed );
		}
		
		
		
		private function initMLoaderListener():void {
			this.addEventListener( Event.ENTER_FRAME, onMLoaderProgress );
		}
		
		private function delMLoaderListener():void {
			this.removeEventListener( Event.ENTER_FRAME, onMLoaderProgress );
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																				   LISTENERS FUNCTIONS 
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function onItemBegin( evt:Event ):void {
			
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"item "+evt.currentTarget.url+" is loading", item:evt.currentTarget };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemProgress( evt:ProgressEvent ):void {
			
			var percent = evt.currentTarget.percentLoaded;
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"item " +evt.currentTarget.url+ " on progress", item:evt.currentTarget, percent:percent };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMPROGRESS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemComplete( evt:Event ):void {
			
			evt.currentTarget.state = MultiLoaderItem.LOADED;
			_takenSlots -= 1;
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"item " +evt.currentTarget.url+ " is Complete", item:evt.currentTarget };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMCOMPLETE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
			//onload le suivant ou non 
			checkFile();
		}
		
		private function onItemIOerror( evt:IOErrorEvent ):void {
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"item "+evt.currentTarget.url+" have failed" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMIOERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemHttpStatus( evt:HTTPStatusEvent ):void {
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"error" + evt };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMHTTPSTATUS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemNetStatus( evt:NetStatusEvent ):void {
			
			var message:String;
			
			switch (evt.info.code) {
				case "NetStream.Play.StreamNotFound" :
				    message = "stream error";
					break;
				case "NetStream.Play.Stop" :
					message = "unexpexted stop";
					break;
				case "NetStream.Buffer.Full" :
					trace( "bufferFull" );
					break;
					
				case "NetStream.Buffer.Flush" :
					trace( "bufferFlush" );
					break;	
			}
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info: message +" "+ evt };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMNETSTATUS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		
		private function onMLoaderProgress( evt:Event ):void {
			var percent:Number = 0;
			walker = itemsList.head;
			
			while ( walker ) {
                percent += walker.data.percentLoaded;
				walker = walker.next;
			}
			
			percent = Math.floor( percent/itemNumber );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"Multiloader "+MloaderName+" on progress", percent:percent };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERPROGRESS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onStreamReady( evt:MultiLoaderEvent ):void {
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:evt.info, item:evt.item };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMREADY, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
		}
		
		private function onStreamBuffering( evt:MultiLoaderEvent ):void {
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:evt.info, item:evt.item };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMBUFFERING, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
		}
		
		private function onStreamPlayed( evt:MultiLoaderEvent ):void {
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:evt.info, item:evt.item };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMPLAYED, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
		}
		
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					   GETTERS/SETTERS 
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function get maxSlot():int {
			return _maxSlots;
		}
		
		public function set maxSlot( maxSlots:int ):void {
			_maxSlots = maxSlots;
		}
		
		public function get availableSlot():int {
			return _maxSlots-_takenSlots;
		}
		
		public function get state():String {
			return _state;
		}
		
		public function get role():String {
			return MloaderRole;
		}
		
		public function set role( role:String ):void {
			MloaderRole = role;
		}
		
		public function getItemByName( name:String ):MultiLoaderItem {
			walker = itemsList.head;
			
			while ( walker ) {
				//--
				if ( walker.data.name == name ) {
					var result = walker.data;
				}
				walker = walker.next;
			}
			
			return result;
		}
		
		public function getItemByArgs( type:String, name:String ):MultiLoaderItem {
			walker = itemsList.head;
			while ( walker ) {
				//--
				if ( walker.data.args != null && walker.data.args[ type ] != undefined ) {
					if ( walker.data.args[ type ] == name ) {
						var result = walker.data;
					}
				}	
				walker = walker.next;
			}
			
			return result;
		}
		
		public function getItems():Array {
			//--
			var result:Array = new Array();
			var count:int = 0;
			//--
			walker = itemsList.head;
			
			while ( walker ) {
			//--
				if ( walker.data.name == name ) {
					result[count] = walker.data;
				}
				walker = walker.next;
				count += 1;
			}
			
			return result;
		}
		
		public function getItemContent( name:String, byArgs:Boolean=false, argsType:String="" ):* {
			if(byArgs){ itemContent = getItemByArgs( argsType,name ).content; }
			else { itemContent = getItemByName( name ).content; }
			return itemContent;
		}
		
		
	}
	
}