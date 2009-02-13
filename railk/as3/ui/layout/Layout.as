/**
 * Layout Manager Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.display.VSprite;
	import railk.as3.ui.depth.DepthManager;
	import railk.as3.data.objectList.ObjectList;
	import railk.as3.data.objectList.ObjectNode;
	
	public class Layout
	{
		private var blocsList:ObjectList;
		private var blocsDepth:DepthManager;
				
		public function Layout( parent:Object,structure:LayoutStruct ):void
		{
			blocsDepth = new DepthManager(parent);
			blocsList = new ObjectList();
			
			var baseBlocs:Array = structure.blocs
			for ( var i:int = 0; i < baseBlocs.length; i++)
			{
				blocsList.add([baseBlocs.name, new LayoutBloc(parent,baseBlocs.name,baseBlocs.x,baseBlocs.y,baseBlocs.width,baseBlocs.height)]);
				(blocsList.tail.data as LayoutBloc).addSubBlocs
			}
			blocsDepth.sync();
		}
		
		public function getBloc(name:String):void
		{
			blocsList.getObjectByGroup(name);
		}
		
		private function placeBlocs( itemName ):void
		{
			var item:ObjectNode = itemList.getObjectByName( itemName );
			if ( item == itemList.head )
			{
				walker = itemList.head.next;
				while ( walker ) 
				{
					walker.data.y=walker.prev.data.nextY;
					walker = walker.next;
				}
			}
			else if (item != itemList.tail )
			{
				walker = item.next;
				while ( walker ) {
					 walker.data.y=walker.prev.data.nextY;
					walker = walker.next;
				}
			}
		}
		
		private function dispose():void
		{
			
		}

	}
	
}