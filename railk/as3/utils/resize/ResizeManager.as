/**
* 
* Static class ResizeManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.resize {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.resize.ResizeManagerEvent;
	
	
	public class ResizeManager {
		
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                             :EventDispatcher;
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var itemList                           :ObjectList;
		private static var walker                             :ObjectNode;
		
		//____________________________________________________________________________________ VARIABLES ITEM
		private static var _maxWidth                          :Number=0;
		private static var _maxheight                         :Number=0;
		
		// _______________________________________________________________________________ VARIABLE EVENEMENT
		private static var eEvent                             :ResizeManagerEvent;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init():void 
		{
			itemList = new ObjectList();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			 ADD ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	displayObject
		 * @param	action
		 * @param	group
		 */
		public static function add( name:String, displayObject:Object, action:Function = null, group:String = 'main' ):void 
		{
			itemList.add( [name,displayObject,group,action] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			MOVE ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function itemAction( name:String, width:Number, height:Number ):void 
		{
			_maxheight = height;
			_maxWidth = width;
			itemList.getObjectByName( name ).action.apply();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		MOVE ALL ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function groupAction( width:Number, height:Number, group:String = 'main' ):void 
		{
			_maxheight = height;
			_maxWidth = width;
			walker = itemList.head;
			loop:while ( walker ) {
				if ( walker.group == group ) {
					walker.action.apply();
				}
				walker = walker.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE ITEMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):void 
		{
			itemList.remove( name );
			///////////////////////////////////////////////////////////////
			var args:Object = { info:'removed'+ name +'item' };
			eEvent = new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ONE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		public static function removeAll():void 
		{
			itemList.clear();
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"removed all item" };
			eEvent = new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ALL, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		public static function getItemContent( name:String ):* { return itemList.getObjectByName( name ).data; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function toString():String { return itemList.toString(); }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		static public function get maxWidth():Number { return _maxWidth; }
		
		static public function set maxWidth(value:Number):void { _maxWidth = value; }
		
		static public function get maxHeight():Number { return _maxheight; }
		
		static public function set maxHeight(value:Number):void { _maxheight = value; }
	}
}