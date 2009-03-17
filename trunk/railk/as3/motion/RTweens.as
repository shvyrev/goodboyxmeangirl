/**
 * 
 * RTween with pool system for high numbers of tweens at a time;
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.utils.TweenPool;
	public class RTweens
	{	
		static private var pool:TweenPool;
		
		/**
		 * init pool and tweenClass and module if claas permit it;
		 */
		static public function init( size:Number=10, growthRate:Number=10, ...modules ):void {
			pool = new TweenPool( size, growthRate);
		}
		
		/**
		 * actions
		 */
		static public function to( target:*= null, duration:Number = NaN, props:Object = null, options:Object = null, position:Number=0 ):IRTween {
			if ( options ) options['onDispose'] = pool.release;
			else options = { onDispose:pool.release };
			return pool.pick(target, duration, props, options, position); 
		}
	}
}