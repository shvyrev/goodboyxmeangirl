/**
 * Bezier segments
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{	
	public class BezierSegment 
	{
		public var p0:Number;
		public var d1:Number;
		public var d2:Number;
		
		public function BezierSegment(p0:Number, p1:Number, p2:Number) {
			this.p0 = p0;
			d1 = p1 - p0;
			d2 = p2 - p0;
		}
		public function calculate(t:Number):Number { return p0+t*(2*(1-t)*d1+t*d2); }
	}
}