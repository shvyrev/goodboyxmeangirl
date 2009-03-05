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
		static public function to( target:*, duration:Number=NaN, props:Object=null, options:Object=null ):IRTween { return StandartTween.to(target, duration, props, options); }
		static public function alphaTo( target:*, duration:Number, alpha:Number, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {alpha:alpha}, {ease:ease}); }
		static public function scaleTo( target:*, duration:Number, scaleX:Number, scaleY:Number, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {scaleX:scaleX, scaleY:scaleY}, {ease:ease}); }
		static public function moveTo( target:*, duration:Number, x:Number, y:Number, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {x:x, y:y}, {ease:ease}); }
		static public function rotateTo( target:*, duration:Number, rotation:Number, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {rotation:rotation}, {ease:ease}); }
		static public function volumeTo( target:*, duration:Number, volume:Number, ease:Function=null):IRTween { return StandartTween.to(target, duration, {volume:volume }, {ease:ease}); }
		static public function colorTo( target:*, duration:Number, color:uint, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {color:color}, {ease:ease}); }
		static public function contrastTo( target:*, duration:Number, contrast:Number, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {contrast:contrast}, {ease:ease}); }
		static public function brightnessTo( target:*, duration:Number, brightness:Number, ease:Function=null ):IRTween { return StandartTween.to(target, duration, {brightness:brightness}, {ease:ease}); }
	}
	
}