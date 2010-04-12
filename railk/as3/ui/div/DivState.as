/**
 * Div State
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	internal final class DivState
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		protected var div:IDiv;
		
		public function DivState(div:IDiv) { this.div = div; }
		
		public function init():void {
			this.x = div.x;
			this.y = div.y;
			this.width = div.width;
			this.height = div.height;
		}
		
		public function dispose():void { div = null; }
	}
}