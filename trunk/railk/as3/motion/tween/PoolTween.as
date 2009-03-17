/**
 * 
 * Pool Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 */

package railk.as3.motion.tween
{
	import railk.as3.motion.IRTween;
	import railk.as3.motion.tween.StandartTween;
	public class PoolTween extends StandartTween implements IRTween
	{
		public var onDispose:Function;
		override public function dispose():void {
			super.dispose();
			props=[];
			onDispose.apply(null, [this]);
		}
	}		
}