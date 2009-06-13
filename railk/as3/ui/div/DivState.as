/**
 * Div State
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	internal class DivState
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		protected var div:IDiv;
		
		public function DivState(div:IDiv) {
			this.div = div;
			this.x = div.x;
			this.y = div.y;
			this.width = div.width;
			this.height = div.height;
		}
		
		public function update():void {
			x = div.x;
			y = div.y;
			width = div.width;
			height = div.height;
		}
	}
}