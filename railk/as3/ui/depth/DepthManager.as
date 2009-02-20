/**
 * Depth manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.depth
{
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	
	public class DepthManager
	{
		private var target:*;
		private var childList:DLinkedList;
		
		public function DepthManager( target:* ):void
		{
			this.target = target;
		}
		
		public function sync():void
		{
			childList = new DLinkedList();
			for (var i:int = 0; i <target.numChildren ; i++) 
			{
				var child:* = target.getChildAt(i);
				childList.add( [child.name,child] )
			}
		}
		
		public function changeDepth( name:String, depth:int ):void
		{
			target.swapChildren( childList.getNodeByName( name ).data, childList.getNodeByID(depth).data ):
		}
		
		public function dispose():void
		{
			childList.clear();
		}
		
		public function get length():int { return target.numChildren; }
	}
	
}