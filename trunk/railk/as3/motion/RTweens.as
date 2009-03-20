/**
 * 
 * RTween with pool system for high numbers of tweens at a time;
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.utils.Pool;
	public class RTweens extends RTween
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
			return pool.pick(target, duration, props, options, position); 
		}
		
		/**
		 * Class
		 */
		override public function dispose():void {
			super.dispose();
			props=[];
			pool.release(this);
		}
	}
}