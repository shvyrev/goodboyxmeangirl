/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import railk.as3.transform.item.*;
	import railk.as3.transform.utils.*;
	import railk.as3.display.MarchingAntsSelect;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.Clone;
	import railk.as3.utils.Key;
	
	public class TransformManager
	{
		private static var _stage:Stage;
		private static var itemsList:ObjectList;
		private static var walker:ObjectNode;
		
		private static const CTRL:String = '17';
		private static const SPACEBAR:String = '32';
		private static const SHIFT:String = '16';
		private static const TAB:String = '9';
		private static const DEL:String = '46';
		private static const C:String = '67';
		private static const V:String = '86';
		private static const A:String = '65';
		private static const Z:String = '90';
		private static const S:String = '83';
		
		private static var select:MarchingAntsSelect;
		
		private static var itemInteracting:Boolean=false;
		
		
		public static function init( stage:Stage ):void
		{
			_stage = stage;
			itemsList = new ObjectList();
		}
		
		private function initListeners():void
		{
			_stage.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			_stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			_stage.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		private function delListeners():void
		{
			_stage.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			_stage.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		public static function enable():void
		{
			walker = itemsList.head;
			while ( walker ) {
				_stage.addChild( walker.data );
				walker.data.x = walker.data.X;
				walker.data.y = walker.data.Y;
				walker = walker.next;
			}
			
			//select = new MarchingAntsSelect(true);
			//_stage.addChildAt( select, _stage.numChildren-1 );
		}
		
		public static function disable():void
		{
			walker = itemsList.head;
			while ( walker ) {
				_stage.addChild( walker.data );
				walker.data.dispose();
				walker = walker.next;
			}
			_stage.removeChild( select );
		}
		
		public static function add( name:String, object:* ):void 
		{
			itemsList.add([name, new TransformItem(name, object)]);
			initItemListeners( itemsList.tail.data );
		}
		
		public static function initItemListeners( item:TransformItem ):void
		{
			item.addEventListener( TransformManagerEvent.ON_ITEM_OPEN, manageEvent, false, 0, true);
			item.addEventListener( TransformManagerEvent.ON_ITEM_SELECTED, manageEvent, false, 0, true);
			item.addEventListener( TransformManagerEvent.ON_ITEM_MOVING, manageEvent, false, 0, true);
			item.addEventListener( TransformManagerEvent.ON_ITEM_STOP_MOVING, manageEvent, false, 0, true);
		}
		
		public static function delItemListeners( item:TransformItem ):void
		{
			item.removeEventListener( TransformManagerEvent.ON_ITEM_OPEN, manageEvent);
			item.removeEventListener( TransformManagerEvent.ON_ITEM_SELECTED, manageEvent);
			item.removeEventListener( TransformManagerEvent.ON_ITEM_MOVING, manageEvent);
			item.removeEventListener( TransformManagerEvent.ON_ITEM_STOP_MOVING, manageEvent);
		}
		
		public static function addMultiple( args:Array ):void 
		{
			var i:int = 0;
			for ( i; i < args.length; i++) 
			{
				itemsList.add([args[i].name, new TransformItem(args[i].name, args[i].object)]);
				initItemListeners( itemsList.tail.data );
			}
		}
		
		public static function duplicate( name:String ):*
		{
			return Clone.deep( itemsList.getObjectByName(name).data );
		}
		
		public static function bringTofront():void
		{
			
		}
		
		public static function moveMultiple():Array
		{
			return new Array();
		}
		
		
		public static function rotateMultiple():Array
		{
			return new Array();
		}
		
		
		public static function scaleMultiple():Array
		{
			return new Array();
		}
		
		
		public static function remove( name:String ):void 
		{
			itemsList.getObjectByName( name).data.dispose();
			itemsList.remove( name );
		}
		
		public static function dispose():void
		{
			removeAll();
			itemsList = null;
		}
		
		public static function removeAll():void 
		{
			walker = itemsList.head;
			while ( walker ) {
				walker.data.dispose();
				walker = walker.next;
			}
			itemsList.clear();
		}
		
		private static function manageEvent( evt:* ):void
		{
			switch( evt.type)
			{
				case Event.ENTER_FRAME :
					break;
				
				case MouseEvent.MOUSE_DOWN :
					break;
					
				case MouseEvent.MOUSE_UP :
					break;
				
				case MouseEvent.MOUSE_MOVE :
					break;
					
				case TransformManagerEvent.ON_ITEM_OPEN :
					break;
				
				case TransformManagerEvent.ON_ITEM_SELECTED :
					break;
					
				case TransformManagerEvent.ON_ITEM_MOVING :
					break;
					
				case TransformManagerEvent.ON_ITEM_STOP_MOVING :
					break;
					
			}
		}
	}
}