/**
 * DIV MARGIN
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.div
{
	public class DivMargin
	{
		public var top:Number=0;
		public var right:Number=0;
		public var bottom:Number=0;
		public var left:Number = 0;
		public function init(...args):void { 
			if (args.length == 1) top = right = bottom = left = args[0];
			else {
				top = args[0];
				right = args[1];
				bottom = args[2];
				left = args[3];
			}
		}
	}
}