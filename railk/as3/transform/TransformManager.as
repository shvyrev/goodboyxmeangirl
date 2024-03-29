/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import railk.as3.transform.item.*;
	import railk.as3.transform.utils.*;
	import railk.as3.display.MarchingAntsSelect;
	import railk.as3.display.RegistrationPoint;
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	import railk.as3.ui.LinkedObject;
	import railk.as3.ui.key.*;
	import railk.as3.utils.Clone;
	
	
	public class TransformManager
	{
		private static var _stage:Stage;
		private static var itemsList:DLinkedList;
		private static var walker:DListNode;
		private static var select:MarchingAntsSelect;
		
		private static var itemInteracting:Boolean=false;
		
		
		/**
		 * INIT
		 * 
		 * @param	stage
		 */
		public static function init( stage:Stage ):void
		{
			_stage = stage;
			itemsList = new DLinkedList();
			if ( !Key.initialized ) Key.initialize( stage );
		}
		
		/**
		 * MANAGE LISTENERS
		 */
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
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																			  ENABLE TRANSFORM MANAGER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function enable():void
		{
			walker = itemsList.head;
			while ( walker ) {
				_stage.addChild( walker.data.master );
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
				_stage.addChild( walker.data.master );
				walker.data.dispose();
				walker = walker.next;
			}
			_stage.removeChild( select );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	 ADD OBJECTS TO THE TRANSFORM LIST
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function add( name:String, object:* ):void 
		{	
			if( getType(object) == 'text') itemsList.add([name, new LinkedObject( new TransformText(_stage, name, object), object)]);
			else
			{
				itemsList.add([name, new LinkedObject( new TransformItem(_stage, name, object,manageChilds( name,object)), object)]);
			}
			initItemListeners( itemsList.tail.data.master );
		}
		
		public static function addMultiple( args:Array ):void 
		{
			var i:int = 0;
			for ( i; i < args.length; i++) 
			{
				if( getType(args[i].object) == 'text') itemsList.add([args[i].name, new LinkedObject( new TransformText(_stage, args[i].name, args[i].object), args[i].object)]);
				else
				{
					itemsList.add([args[i].name, new LinkedObject( new TransformItem(_stage,args[i].name,args[i].object, manageChilds( args[i].name, args[i].object) ),args[i].object)]);
				}
				initItemListeners( itemsList.tail.data.master );
			}
		}
		
		public static function manageChilds(name:String, object:*):DLinkedList
		{
			var childList:DLinkedList = new DLinkedList();
			if (object.numChildren > 0 )
			{
				for (var i:int = 0; i <object.numChildren ; i++) 
				{
					var child:* = object.getChildAt(i);
					if( getType(child) == 'text') childList.add([child.name, new LinkedObject( new TransformText(_stage, child.name, child), child)]);
					else 
					{
						childList.add([child.name, new LinkedObject( new TransformItem(_stage, child.name, child, manageChilds( child.name, child ) ), child)]);
					}
				}
				
			}
			else childList = null;
			
			return childList;
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																		  DUPLICATE AN EXISTING OBJECT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function duplicate( name:String ):*
		{
			return Clone.deep( itemsList.getNodeByName(name).data );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	 					BRING TO FRONT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function bringTofront():void
		{
			
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																MANAGE MULTIPLE OBJECT TRANSFORMATIONS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						REMOVE OBJECTS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function remove( name:String ):void 
		{
			itemsList.getNodeByName( name).data.master.dispose();
			itemsList.remove( name );
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
		
		public static function getItem( name:String ):*
		{
			return itemsList.getNodeByName(name).data;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																							 UTILITIES
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private static function getType(object:*):String
		{
			if ( object is TextField ) return 'text';
			return 'object';
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																							   DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function dispose():void
		{
			removeAll();
			itemsList = null;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						 MANAGE EVENTS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
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
				
				default : break;	
			}
		}
	}
}