/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
*/

package railk.as3.transform {
	
	import flash.display.Stage;
	import railk.as3.transform.item.*;
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
		
		public static const CTRL:String = '17';
		public static const SPACEBAR:String = '32';
		public static const SHIFT:String = '16';
		public static const TAB:String = '9';
		public static const DEL:String = '46';
		public static const C:String = '67';
		public static const V:String = '86';
		public static const A:String = '65';
		public static const Z:String = '90';
		public static const S:String = '83';
		
		public static function init( stage:Stage ):void
		{
			_stage = stage;
			itemsList = new ObjectList();
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
		}
		
		public static function disable():void
		{
			walker = itemsList.head;
			while ( walker ) {
				_stage.addChild( walker.data );
				walker.data.dispose();
				walker = walker.next;
			}

		}
		
		public static function add( name:String, object:* ):void 
		{
			itemsList.add([name, new TransformItem(name, object)])
		}
		
		public static function addMultiple( args:Array ):void 
		{
			var i:int = 0;
			for ( i; i < args.length; i++) 
			{
				itemsList.add([args[i].name,new TransformItem(args[i].name,args[i].object)])
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
				
			}
		}
	}
}