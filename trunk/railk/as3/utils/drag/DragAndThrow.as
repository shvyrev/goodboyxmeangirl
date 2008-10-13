/**
 * 
 * drag and trown object with bounds or not
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.drag
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import railk.as3.event.CustomEvent;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class DragAndThrow extends EventDispatcher
	{
		private static var _stage:Stage;
		private static var itemsList:ObjectList;
		private static var walker:ObjectNode
		protected static var disp:EventDispatcher;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
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
		// 																						 	   	 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( stage:Stage )
		{
			_stage = stage;
			itemsList = new ObjectList();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   ENABLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	o
		 * @param	orientation
		 * @param	useRect			object passed must contain a public object name content where the content to scroll is
		 * @param	bounds
		 */
		public static function enable( name:String, o:Object, orientation:String, useRect:Boolean=false, bounds:Rectangle=null  )
		{
			itemsList.add( [name, new DragItem(_stage, name, o, orientation, useRect, bounds)] );
			itemsList.tail.data.addEventListener( 'onScrollListDrag', manageEvent, false, 0, true );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							PROG DRAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function drag( name:String, x:Number, y:Number ):void
		{
			var from:ObjectNode = itemsList.getObjectByName( name );
			if ( from == itemsList.head )
			{
				walker = from.next;
				while ( walker ) {
					move( walker.data,x,y );
					walker = walker.next;
				}
			}
			else if (from == itemsList.tail )
			{
				walker = from.prev;
				while ( walker ) {
					move( walker.data,x,y );
					walker = walker.prev;
				}
			}
			else
			{
				var prev:ObjectNode = from.prev;
				while ( prev ) {
					move( prev.data,x,y );
					prev = prev.prev;
				}
				
				var next:ObjectNode = from.next;
				while ( next ) {
					move( next.data,x,y );
					next = next.next;
				}
			}
		}
		
		private static function move( item:DragItem, x:Number, y:Number ):void
		{
			if ( item.useRect )
			{
				var rect:Rectangle = item.o.content.scrollRect;
				rect.y = y;
				rect.x = x;
				item.o.content.scrollRect = rect;
			}
			else 
			{
				item.o.y = y;
				item.o.x = x;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):void
		{
			itemsList.getObjectByName( name ).data.dispose();
			itemsList.remove( name );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function dispose():void 
		{
			walker = itemsList.head;
			while ( walker ) 
			{
				walker.data.dispose();
				walker = walker.next;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function toString():String
		{
			return itemsList.toString();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function manageEvent(evt:CustomEvent):void
		{
			switch(evt.type)
			{
				case 'onScrollListDrag' :
					dispatchEvent( new CustomEvent( evt.type, {name:evt.name} ) );
					break;
			}
		}
	}
}