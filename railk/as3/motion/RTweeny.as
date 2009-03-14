/**
 * 
 * lightweight Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.tween.LiteTween;
	public class RTweeny
	{
		/**
		 * actions
		 */
		static public function to( target:*=null,duration:Number=NaN,props:Object=null,options:Object=null,position:Number=0 ):IRTween { return new LiteTween(target,duration,props,options,position); }
	}	
}