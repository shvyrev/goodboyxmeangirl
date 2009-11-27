/**
 * Twins entry point
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.tweens.Normal;
	import railk.as3.motion.utils.Pool;
	public function twin(target:Object = null,autoStart:Boolean=true):Normal { return Pool.getInstance().pick(target,autoStart); }
}
