﻿/**** Twin Color Module**@author Richard Rodney*@version 0.1 */package railk.as3.motion.modules {	import flash.geom.ColorTransform;	import railk.as3.motion.utils.Prop;	public class ColorModule {		static public function update( target:Object, props:Prop, ratio:Number ):Prop {			target.transform.colorTransform = props.current = tint( ratio, props.start, props.end, target.alpha);			return props;		}				static private function tint( r:Number, b:ColorTransform, e:ColorTransform, a:Number):ColorTransform {			var q:Number = 1-r;			b.alphaMultiplier = a;			return new ColorTransform(b.redMultiplier+e.redMultiplier*r,b.greenMultiplier+e.greenMultiplier*r,b.blueMultiplier+e.blueMultiplier*r,1,b.redOffset+e.redOffset*r,b.greenOffset+e.greenOffset*r,b.blueOffset+e.blueOffset*r);		}	}}