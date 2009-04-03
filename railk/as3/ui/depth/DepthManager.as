/**
 * Depth manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.depth
{
	public class DepthManager
	{
		private var target:*;
		public function DepthManager( target:* ):void {
			this.target = target;
		}
		
		public function changeDepth( name:String, depth:int ):void {
			var i:int = target.numChildren;
			while( --i > -1 )
				if( target.getChildAt(i).name == name) target.swapChildren( target, target.getChildAt(depth) ):
		}
		
		public function get length():int { return target.numChildren; }
	}
	
}