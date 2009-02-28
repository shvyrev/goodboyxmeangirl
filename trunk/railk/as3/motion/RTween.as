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
		 * vars
		 */
		static public const VERSION:String = '0.1';
		static private var mod:Boolean = false;
		
		/**
		 * for specila actions like colorTransform, color etc please enable the correspondant modules
		 */
		static public function enable( ...modules ):void { mod=true; }
		
		/**
		 * actions
		 */
		static public function to( target:*, duration:Number=NaN, props:Object=null, options:Object=null ):IRTween { return StandartTween.to(target, duration, props, options); }
		//static public function from( target:*, duration:Number, props:Object, options:Object = null ):IRTween { return tween(target).from(target, duration, props, options) as IRTween; }
		//static public function fromTo( target:*, duration:Number, props:Object, options:Object = null ):IRTween { return tween(target).fromTo(target, duration, props, options) as IRTween; }
		//static public function alphaTo( target:*, duration:Number, alpha:Number, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, {alpha:alpha}, {ease:ease}) as IRTween; }
		//static public function scaleTo( target:*, duration:Number, scaleX:Number, scaleY:Number, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, {scaleX:scaleX, scaleY:scaleY}, {ease:ease}) as IRTween; }
		//static public function moveTo( target:*, duration:Number, x:Number, y:Number, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, {x:x, y:y}, {ease:ease}) as IRTween; }
		//static public function rotateTo( target:*, duration:Number, rotation:Number, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, {rotation:rotation}, {ease:ease}) as IRTween; }
		//static public function filterTo( target:*, duration:Number, filter:*, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, props, {ease:ease}) as IRTween; }
		//static public function soundTransformTo( target:*, duration:Number, volume:Number, pan:Number, ease:Function=null):IRTween { return tween('StandartTween').to(target, duration, props, {ease:ease}) as IRTween; }
		//static public function colorTo( target:*, duration:Number, color:uint, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, props, {ease:ease}) as IRTween; }
		//static public function colorTransformTo( target:*, duration:Number, color:uint, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, props, {ease:ease}) as IRTween; }
		//static public function contrastTo( target:*, duration:Number, contrast:Number, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, props, {ease:ease}) as IRTween; }
		//static public function brightnessTo( target:*, duration:Number, brightness:Number, ease:Function=null ):IRTween { return tween('StandartTween').to(target, duration, props, {ease:ease}) as IRTween; }
	}
	
}