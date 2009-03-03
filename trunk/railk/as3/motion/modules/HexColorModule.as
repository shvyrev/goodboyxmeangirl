﻿/****RTween HExColor Module**@author Richard Rodney*@version 0.1 */package railk.as3.motion.modules {	public class HexColorModule {		static public function update( target:Object, props:Array, ratio:Number ):Array {			target = props[1] = mix( props[2], props[3], ratio);			return props;		}				static private function mix(bc:uint,ec:uint,n:Number):uint {			var q:Number = 1-n;			var a:uint = ((bc >> 24) & 0xFF)*q+((ec >> 24) & 0xFF)*n;			var r:uint = ((bc >> 16) & 0xFF)*q+((ec >> 16) & 0xFF)*n;			var g:uint = ((bc >>  8) & 0xFF)*q+((ec >>  8) & 0xFF)*n;			var b:uint = (bc & 0xFF)*q+(ec & 0xFF)*n;			return  a << 24 | r << 16 | g << 8 | b;		}	}}