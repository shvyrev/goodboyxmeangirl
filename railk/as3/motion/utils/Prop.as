/**
 * 
 * Prop
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils 
{	
	public class Prop 
	{
		public var prev:Prop;
		public var type:String;
		public var prop:String;
		public var current:*;
		public var start:*;
		public var end:*;
		
		public function Prop( type:String, prop:String, start:*, end:*, rotation:Boolean=false) {
			this.type = type;
			this.prop = prop;
			this.start = current =(rotation)?(start%360+((Math.abs(start%360-end%360)<180)?0:(start%360>end%360)?-360:360)):start;
			this.end = (rotation)?end%360:end;
		}
	}
}