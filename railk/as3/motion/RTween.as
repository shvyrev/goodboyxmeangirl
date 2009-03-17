/**
 * 
 * RTween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.tween.StandartTween;
	public class RTween extends StandartTween
	{
		/**
		 * for special actions like colorTransform, color etc please enable the correspondant modules
		 */
		static public function enable( ...modules ):Boolean { return true; }
		
		/**
		 * actions
		 */
		static public function to( target:*=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ):RTween { return new RTween(target, duration, props, options, position); }
		static public function alphaTo( target:*, duration:Number, alpha:Number, ease:Function=null ):RTween { return new RTween(target, duration, {alpha:alpha}, {ease:ease}); }
		static public function scaleTo( target:*, duration:Number, scaleX:Number, scaleY:Number, ease:Function=null ):RTween { return new RTween(target, duration, {scaleX:scaleX, scaleY:scaleY}, {ease:ease}); }
		static public function moveTo( target:*, duration:Number, x:Number, y:Number, ease:Function=null ):RTween { return new RTween(target, duration, {x:x, y:y}, {ease:ease}); }
		static public function rotateTo( target:*, duration:Number, rotation:Number, ease:Function=null ):RTween { return new RTween(target, duration, {rotation:rotation}, {ease:ease}); }
		static public function volumeTo( target:*, duration:Number, volume:Number, ease:Function=null):RTween { return new RTween(target, duration, {volume:volume }, {ease:ease}); }
		static public function colorTo( target:*, duration:Number, color:uint, ease:Function=null ):RTween { return new RTween(target, duration, {color:color}, {ease:ease}); }
		static public function contrastTo( target:*, duration:Number, contrast:Number, ease:Function=null ):RTween { return new RTween(target, duration, {contrast:contrast}, {ease:ease}); }
		static public function brightnessTo( target:*, duration:Number, brightness:Number, ease:Function=null ):RTween { return new RTween(target, duration, {brightness:brightness}, {ease:ease}); }
		
		/**
		 * Constructeur
		 */
		public function RTween( target:Object=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ) { super(target,duration,props,options,position); }
		
	}
}