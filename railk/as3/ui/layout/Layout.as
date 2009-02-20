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
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	
	public class Layout
	{
		private var blocsList:DLinkedList;
		private var blocsDepth:DepthManager;
				
		public function Layout( parent:Object,structure:LayoutStruct )
		{
			blocsDepth = new DepthManager(parent);
			blocsList = new DLinkedList();
			
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
			blocsList.getNodeByGroup(name);
		}
		
		private function placeBlocs( itemName:String ):void
		{
			var item:DListNode = itemList.getNodeByName( itemName );
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