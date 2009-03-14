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
	public class RTween
	{
		/**
		 * for specila actions like colorTransform, color etc please enable the correspondant modules
		 */
		static public function enable( ...modules ):Boolean { return true; }
		
		/**
		 * actions
		 */
		static public function to( target:*=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ):IRTween { return new StandartTween(target, duration, props, options, position); }
		static public function alphaTo( target:*, duration:Number, alpha:Number, ease:Function=null ):IRTween { return new StandartTween(target, duration, {alpha:alpha}, {ease:ease}); }
		static public function scaleTo( target:*, duration:Number, scaleX:Number, scaleY:Number, ease:Function=null ):IRTween { return new StandartTween(target, duration, {scaleX:scaleX, scaleY:scaleY}, {ease:ease}); }
		static public function moveTo( target:*, duration:Number, x:Number, y:Number, ease:Function=null ):IRTween { return new StandartTween(target, duration, {x:x, y:y}, {ease:ease}); }
		static public function rotateTo( target:*, duration:Number, rotation:Number, ease:Function=null ):IRTween { return new StandartTween(target, duration, {rotation:rotation}, {ease:ease}); }
		static public function volumeTo( target:*, duration:Number, volume:Number, ease:Function=null):IRTween { return new StandartTween(target, duration, {volume:volume }, {ease:ease}); }
		static public function colorTo( target:*, duration:Number, color:uint, ease:Function=null ):IRTween { return new StandartTween(target, duration, {color:color}, {ease:ease}); }
		static public function contrastTo( target:*, duration:Number, contrast:Number, ease:Function=null ):IRTween { return new StandartTween(target, duration, {contrast:contrast}, {ease:ease}); }
		static public function brightnessTo( target:*, duration:Number, brightness:Number, ease:Function=null ):IRTween { return new StandartTween(target, duration, {brightness:brightness}, {ease:ease}); }
	}
}