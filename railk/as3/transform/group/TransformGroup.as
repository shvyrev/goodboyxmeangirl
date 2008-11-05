/**
* 
* create a group of items
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform.group 
{
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.transform.item.TransformItem;
	
	public class TransformGroup extends RegistrationPoint
	{	
		private var itemsList:ObjectList;
		private var parentsList:ObjectList;
		private var walker:ObjectNode;
		private var t:TransformItem;
		
		public function TransformGroup()
		{
			itemsList = new ObjectList();
			parentsList = new ObjectList();
		}
		
		public function create( name:String, objectArray:Array ):TransformItem
		{
			for (var i:int = 0; i < objectArray.length; i++) 
			{
				parentsList.add( [objectArray[i].parent.name], objectArray[i].parent] );
				itemsList.add([String(i), objectArray[i], objectArray[i].parent.name]);
				this.addChild( objectArray[i] );
			}
			
			t = new TransformItem( name, this );
			return t;
		}
		
		public function add( object:* ):TransformItem
		{
			parentsList.add( [object.parent.name], object.parent] );
			itemsList.add([String(itemsList.length), object, object.parent.name]);
			this.addChild( object );
			t.dispose();
			t = new TransformItem( name, this );
			return t;
		}
		
		public function remove( object:* ):TransformItem
		{
			var name:String = getObjectName( object );
			itemsList.remove( name );
			this.removeChild( object );
			parentsList.getObjectByName(name).data.addChild( object );
			t.dispose();
			t = new TransformItem( name, this );
			return t;
		}
		
		public function dispose():void
		{
			t.dispose();
			walker = itemsList.head;
			while ( walker )
			{
				var name:String = getObjectName( object );
				itemsList.remove( name );
				this.removeChild( object );
				parentsList.getObjectByName(name).data.addChild( object );
				walker = walker.next;
			}
			itemsList.clear();
		}
		
		private function getObjectName(object:*):String
		{
			var result:String;
			walker = itemsList.head;
			loop:while ( walker )
			{
				if (walker.data = object ) {
					result = = walker.name;
					break loop;
				}
				walker = walker.next;
			}
			return result;
		}
	}
}