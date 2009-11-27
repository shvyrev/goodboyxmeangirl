/**
 * Numeric tweening along a Bezier curve
 * @author Philippe / http://philippe.elsass.me
 */

package railk.as3.motion.modules 
{
	import railk.as3.motion.utils.Prop;
	import railk.as3.motion.utils.BezierSegment;
	
	public class BezierModule
	{	
		static public function update(target:Object, props:Prop, ratio:Number ):Prop
		{
			var segment:BezierSegment, segments:Array = props.start, last:int = length - 1;
			if (ratio >= 1) target[props.prop] = segments[last].p0 + segments[last].d2;
			else if (segments.length == 1) target[props.prop] = segments[0].calculate(ratio);
			else{
				var index:int = (ratio*segments.length)>>0;
				if (index < 0) index = 0;
				else if (index > last) index = last;
				segment = segments[index];
				ratio = length * (ratio - index / length);
				target[props.prop] = segment.calculate(ratio);
			}
			return props;
		}
	}
}