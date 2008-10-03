/**
* 
* MultiLoader class
* 
* @author richard rodney
* @version 0.2
*/

package railk.as3.data.loader {
	
	// __________________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
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
	import railk.as3.data.loader.loaderItems.MultiLoaderItem;
	import railk.as3.utils.objectList.*;
	

	public class MultiLoader extends EventDispatcher {
		
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
		private var itemsList                                :ObjectList;
		private var walker                                   :ObjectNode;
		
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
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
			itemsList = new ObjectList();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					MLOADER MANAGEMENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	nbSlot | maximum recommended slots is 7
		 */
		public function start( nbSlot:int = 7 ):void {
			_maxSlots = nbSlot;
			walker = itemsList.head;
			while ( _takenSlots < _maxSlots && walker ) 
			{
				if( walker.data.state == MultiLoaderItem.WAITING ){
					var file:MultiLoaderItem = walker.data;
					walker.data.state = MultiLoaderItem.LOADING;
					file.load();
					_takenSlots += 1;
				}	
				walker = walker.next;
			}
			
			initMLoaderListener();
			_state = "start";
			
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"Multiloader "+MloaderName+" is started" };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		public function stop():void {
			walker = itemsList.head;
			while ( walker ) {
				var file:MultiLoaderItem = walker.data;
				if ( file.state == MultiLoaderItem.LOADING ) {
					file.stop();
					file.state = MultiLoaderItem.WAITING;
				}
				walker = walker.next;
			}
			
			_state = "stop";
			
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"Multiloader "+MloaderName+" is stopped" };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERSTOPPED, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		
		public function destroy():void {
			stop();
			delMLoaderListener();
			walker = itemsList.head;
			while ( walker ) 
			{
				var file:MultiLoaderItem = walker.data;
				delItemListeners( file );
				file.dispose();
				file = null;
				walker = walker.next;
			}
			MLoaderList[MloaderName] = null;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   ITEM MANAGEMENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	url  | the path of the file to download
		 * @param	priority  | -1=non-prioritaire / 0=normal / 1=prioritaire
		 * @param	mode            'sameDomain' | 'externalDomain' only for SWF file;
		 * @param	preventCache |  true / if you want to avoide the broswer cache for the files
		 * @param	bufferSize  | 0=loading the whole before playing / XX=the number of second to buffer before playing
		 * @param	saveAs  | allow the file to be saved by the user
		 */
		public function add( url:String, name:String =  "", args:Object = null, priority:int = 0, mode:String = 'sameDomain', preventCache:Boolean = false, bufferSize:int = 0, saveAs:Boolean = false ):void 
		{
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
			//--
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
		public function forceLoad( url:String, name:String =  "", args:Object = null, mode:String = 'sameDomain', preventCache:Boolean = false, bufferSize:int = 100, saveAs:Boolean = false ):void 
		{
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
			//--
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
			var t:ObjectNode = itemsList.getObjectByName( name );
			if ( t )
			{
				var file:MultiLoaderItem = t.data;
				delItemListeners( file );
				file.dispose();
				file = null;
				itemsList.removeObjectNode( t );
				result = true;
			}
			else result = false;
			
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
			loop:while ( walker ) 
			{
				var file:MultiLoaderItem = walker.data ;
				if ( file.url == url ) {
					delItemListeners( file );
					file.dispose();
					file = null;
					itemsList.removeObjectNode( walker );
					result = true;
					break loop;
				}
				else {
					result = false;
				}
				walker = walker.next;
			}
			return result;
		}
		
		
		public function removeAll():void {
			walker = itemsList.head;
			while ( walker ) {
				var file:MultiLoaderItem = walker.data ;
				delItemListeners( file );
				file.dispose();
				file = null;
				//--
				var currentNode:ObjectNode = walker;
				walker = walker.next;
				itemsList.removeObjectNode( currentNode );
			}
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   ITEM PROPERTIES
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function getItemType( url:String ):String 
		{
			var tmpString:String = url;
			var urlParse:Array = tmpString.split("/");
			tmpString = urlParse[urlParse.length - 1];
			var sep:int = tmpString.indexOf('.');
			var ext:String = tmpString.substring( sep );
			
			return types[ext.toLowerCase()];
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					LOADING MANAGEMENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function loadNext():void 
		{
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"******load next files******" };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERLOADNEXT, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////	

			walker = itemsList.head;
			while ( walker ) 
			{
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
		
		private function checkFile():void 
		{
			var waiting:Boolean = false;
			var loading:Boolean = false;
			
			walker = itemsList.tail;
			while ( walker ) 
			{
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
			if ( waiting == true ) { loadNext(); }
			else {
				if ( loading == false && _state != 'stop' ) 
				{
					delMLoaderListener();
					_state = "stop";
					///////////////////////////////////////////////////////////////
					var args:Object = { info:"Multiloader "+MloaderName+" is finished" };
					eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERCOMPLETE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////	
				}	
			}
		}
		
		private function sortList( itm:MultiLoaderItem ):void 
		{
			var inserted:Boolean = false;
			
			walker = itemsList.head;
			while ( walker ) {
				if( itm.priority > walker.data.priority ){
					itemsList.insertBefore( walker, itm.name, itm );
					inserted = true;
					break;
				}
				walker = walker.next;
			}
			
			if ( inserted == false ) {
				itemsList.add( [itm.name,itm] )
			}
			
			walker = itemsList.head;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			      LISTENERS MANAGEMENT 
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initItemListeners( item:MultiLoaderItem ):void {
			item.addEventListener( Event.OPEN, onItemBegin, false, 0, true );
			item.addEventListener( ProgressEvent.PROGRESS, onItemProgress, false, 0, true );
			item.addEventListener( Event.COMPLETE, onItemComplete, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ONERRORLOADINGITEM, onErrorLoadingItem, false, 0, true );
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
			item.removeEventListener( MultiLoaderEvent.ONERRORLOADINGITEM, onErrorLoadingItem );
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
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   LISTENERS FUNCTIONS 
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function onItemBegin( evt:Event ):void 
		{
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"item "+evt.currentTarget.url+" is loading", item:evt.currentTarget };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemProgress( evt:ProgressEvent ):void 
		{	
			var percent = evt.currentTarget.percentLoaded;
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"item " +evt.currentTarget.url+ " on progress", item:evt.currentTarget, percent:percent };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMPROGRESS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemComplete( evt:Event ):void 
		{
			evt.currentTarget.state = MultiLoaderItem.LOADED;
			_takenSlots -= 1;
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"item " +evt.currentTarget.url+ " is Complete", item:evt.currentTarget };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMCOMPLETE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
			//onload le suivant ou non 
			checkFile();
		}
		
		private function onErrorLoadingItem( evt:MultiLoaderEvent ):void 
		{	
			eEvent = new MultiLoaderEvent( evt.type, { info:evt.info, item:evt.item } );
			dispatchEvent( eEvent );
			
			//onload le suivant ou non 
			checkFile();
		}
		
		private function onItemHttpStatus( evt:HTTPStatusEvent ):void 
		{	
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"error" + evt };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMHTTPSTATUS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onItemNetStatus( evt:NetStatusEvent ):void 
		{	
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
			var args:Object = { info: message +" "+ evt };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONITEMNETSTATUS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onMLoaderProgress( evt:Event ):void 
		{
			var percent:Number = 0;
			
			walker = itemsList.head;
			while ( walker ) {
                percent += walker.data.percentLoaded;
				walker = walker.next;
			}
			
			percent = Math.floor( percent/itemNumber );
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"Multiloader "+MloaderName+" on progress", percent:percent };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONMULTILOADERPROGRESS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onStreamReady( evt:MultiLoaderEvent ):void 
		{	
			///////////////////////////////////////////////////////////////
			var args:Object = { info:evt.info, item:evt.item };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMREADY, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onStreamBuffering( evt:MultiLoaderEvent ):void 
		{	
			///////////////////////////////////////////////////////////////
			var args:Object = { info:evt.info, item:evt.item };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMBUFFERING, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function onStreamPlayed( evt:MultiLoaderEvent ):void 
		{	
			///////////////////////////////////////////////////////////////
			var args:Object = { info:evt.info, item:evt.item };
			eEvent = new MultiLoaderEvent( MultiLoaderEvent.ONSTREAMPLAYED, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		 TO STRING 
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String { return itemsList.toString(); }
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   GETTERS/SETTERS 
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get maxSlot():int { return _maxSlots; }
		
		public function set maxSlot( maxSlots:int ):void { _maxSlots = maxSlots;}
		
		public function get availableSlot():int { return _maxSlots-_takenSlots; }
		
		public function get state():String { return _state; }
		
		public function get role():String { return MloaderRole; }
		
		public function set role( role:String ):void { MloaderRole = role; }
		
		public function getItemByName( name:String ):MultiLoaderItem { return itemsList.getObjectByName( name ).data; }
		
		public function getItemByArgs( type:String, name:String ):MultiLoaderItem {
			walker = itemsList.head;
			while ( walker ) 
			{
				if ( walker.data.args != null && walker.data.args[ type ] != undefined ) {
					if ( walker.data.args[ type ] == name ) {
						var result = walker.data;
					}
				}	
				walker = walker.next;
			}
			return result;
		}
		
		public function getItems():Array { return itemsList.toArray(); }
		
		public function getItemsContent():Array {
			var result:Array = new Array();
			walker = itemsList.head;
			while ( walker ) 
			{
				result.push( walker.data.content );
				walker = walker.next;
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