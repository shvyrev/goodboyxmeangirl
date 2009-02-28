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
		 * vars
		 */
		static public const VERSION:String = '0.1';
		
		/**
		 * actions
		 */
		static public function to( target:*, duration:Number=NaN, props:Object=null, options:Object=null ):IRTween { return LiteTween.to(target, duration, props, options); }
		static public function from( target:*, duration:Number=NaN, props:Object=null, options:Object=null ):IRTween { return LiteTween.to(target, duration, props, options); }
	}	
}