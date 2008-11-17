/**
 * Depth manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.depth
{
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class DepthManager
	{
		private var target:*;
		private var childList:ObjectList;
		
		public function DepthManager( target:* ):void
		{
			this.target = target;
		}
		
		public function sync():void
		{
			childList = new ObjectList();
			for (var i:int = 0; i <target.numChildren ; i++) 
			{
				var child:* = target.getChildAt(i);
				childList.add( [child.name,child] )
			}
		}
		
		public function changeDepth( name:String, depth:int ):void
		{
			target.swapChildren( childList.getObjectByName( name ).data, childList.getObjectByID(depth).data ):
		}
		
		public function dispose():void
		{
			childList.clear();
		}
		
		public function get length():int { return target.numChildren; }
	}
	
}