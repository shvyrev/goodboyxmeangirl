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
	public class RTweeny extends LiteTween
	{
		/**
		 * actions
		 */
		static public function to( target:Object=null,duration:Number=NaN,props:Object=null,options:Object=null,position:Number=0 ):RTweeny { return new RTweeny(target,duration,props,options,position); }

		/**
		 * Constructeur
		 */
		public function RTweeny( target:Object,duration:Number,props:Object,options:Object,position:Number ) { super(target,duration,props,options,position); }
		
	}	
}