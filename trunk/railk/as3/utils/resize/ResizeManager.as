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
		public static function add( name:String, displayObject:*, action:Function = null, group:String = 'main' ):void 
		{
			itemList.add( [name,displayObject,group,action] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			MOVE ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	width
		 * @param	height
		 */
		public static function itemAction( name:String, width:Number, height:Number ):void 
		{
			//--vars
			_maxheight = height;
			_maxWidth = width;
			
			itemList.getObjectByName( name ).action.apply();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		MOVE ALL ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	width
		 * @param	height
		 * @param	name
		 */
		public static function groupAction( width:Number, height:Number, name:String = 'main' ):void 
		{
			//--vars
			_maxheight = height;
			_maxWidth = width;
			
			for ( var i:int = 0; i < itemList.length; i++ ) {
				var node:ObjectNode = itemList.iterate(i);
				if ( node.group == name ) {
					node.action.apply();
				}
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE ITEMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public static function remove( name:String ):void 
		{
			itemList.remove( name );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:'removed'+ name +'item' };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ONE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		

		public function removeAll():void 
		{
			for ( var i:int=0; i < itemList.length; i++ ){
				var nodeName:String = itemList.iterate(i).name;
				itemList.remove( nodeName );
			}	
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"removed all item" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ALL, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public static function getItemContent( name:String ):* 
		{
			return itemList.getObjectByName( name ).data;
		}
		
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public static function toString():String
		{
			return itemList.toString();
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		static public function get maxWidth():Number { return _maxWidth; }
		
		static public function set maxWidth(value:Number):void 
		{
			_maxWidth = value;
		}
		
		static public function get maxheight():Number { return _maxheight; }
		
		static public function set maxheight(value:Number):void 
		{
			_maxheight = value;
		}
		
	}
	
}