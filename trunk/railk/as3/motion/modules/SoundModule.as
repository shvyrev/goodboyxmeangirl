﻿/** *  * RTween Sound Module *  * @author Richard Rodney * @version 0.1 */package railk.as3.motion.modules {	import flash.media.SoundTransform;		public class SoundModule {		static public function update( target:Object, props:Array, ratio:Number ):Array {			if( props[0] == 'pan') target.soundTransform = props[1] = pan( ratio, props[2], props[3], target.soundTransform.volume );			else if( props[0] == 'volume') target.soundTransform  = props[1] = volume( ratio, props[2], props[3], target.soundTransform.pan );			return props;		}				static private function volume( n:Number, bv:Number, ev:Number, p:Number ):SoundTransform { return new SoundTransform(ev-(1-n),p); }		static private function pan( n:Number, bp:Number, ep:Number, v:Number ):SoundTransform { return new SoundTransform(v,ep-(1-n)); }	}}