/**
 * 
 * RTween with pool system for high numbers of tweens at a time;
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.tween.PoolTween;
	import railk.as3.motion.utils.Pool;
	public class RTweens extends PoolTween
	{	
		/**
		 * init pool and tweenClass and module if claas permit it;
		 */
		static private var pool:Pool;
		static public function init( size:Number=10, growthRate:Number=10, ...modules ):void {
			pool = new Pool( size, growthRate);
		}
		
		/**
		 * actions
		 */
		static public function to( target:*= null, duration:Number = NaN, props:Object = null, options:Object = null, position:Number=0 ):RTweens {
			if ( options ) options['onDispose'] = pool.release;
			else options = { onDispose:pool.release };
			return pool.pick(target, duration, props, options, position) as RTweens; 
		}
	}
}