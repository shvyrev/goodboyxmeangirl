/**
 * 
 * Timeline Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 */

package railk.as3.motion.tween
{
	import railk.as3.motion.IRTween	
	public class TimelineTween extends StandartTween implements IRTween
	{
		public var onDispose:Function;
		override public function dispose():void {
			super.dispose();
			props = [];
			head = false;
			tail = true;
			onDispose.apply(null, [this]);
		}
		
	}		
}