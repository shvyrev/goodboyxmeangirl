/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
*/

package railk.as3.transform {
	
	import flash.display.Stage;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.Clone;
	
	public class TransformManager
	{
		private var stage:Stage;
		private var itemsList:ObjectList;
		
		public static function init( stage:Stage ):void
		{
			this.stage = stage;
			itemsList = new ObjectList();
		}
		
		public static function enable( name:String, object:* ):void 
		{
			itemsList.add([name, new TransformItem(name,object)])
		}
		
		public static function enableMultiple( args:Array ):void 
		{
			var i:int = 0;
			for ( i; i < args.length; i++) 
			{
				itemsList.add([args[i].name,new TransformItem(args[i].name,args[i].object)])
			}
		}
		
		public static function remove( name:String ):void 
		{
			itemsList.getObjectByName( name).data.dispose();
			itemsList.remove( name );
		}
		
		public static function removeAll():void 
		{
			walker = itemslist.head;
			while ( walker ) {
				walker.data.dispose();
				walker = walker.next;
			}
			itemsList.clear();
		}
	}
}