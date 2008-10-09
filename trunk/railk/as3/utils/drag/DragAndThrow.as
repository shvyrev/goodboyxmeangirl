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
	
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class DragAndThrow
	{
		private static var _stage:Stage;
		private static var itemsList:ObjectList;
		private static var walker:ObjectNode
		
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
			itemsList.add( [name, new DragItem(_stage,name,o,orientation,useRect,bounds)] );
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
	}
}