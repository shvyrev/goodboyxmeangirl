﻿/** *  * RTween Text Module *  * @author Richard Rodney * @version 0.1 */package railk.as3.motion.modules {	import flash.geom.ColorTransform;	public class TextModule {		static public function update( target:Object, props:Array, ratio:Number ):Array {			if( props[0] == 'text') target.text = props[1] = text( ratio, props[2], props[3] );			else if ( props[0] == 'textColor') target.textColor = props[1] = color( ratio, props[2], props[3] );			return props;		}				static private function color( n:Number, bc:uint, ec:uint ):uint {			var b:ColorTransform = new ColorTransform(), e:ColorTransform = new ColorTransform(), result:ColorTransform, r:Number=1-n;			b.color = bc;			e.color = ec;			return (new ColorTransform( b.redMultiplier*r+e.redMultiplier*n, b.greenMultiplier*r+e.greenMultiplier*n, b.blueMultiplier*r+e.blueMultiplier*n, b.alphaMultiplier*r+e.alphaMultiplier*n, b.redOffset*r+e.redOffset*n, b.greenOffset*r+e.greenOffset*n, b.blueOffset*r+e.blueOffset*n, b.alphaOffset*r+e.alphaOffset*n )).color;		}				static private function text( n:Number, bt:String, et:String  ):String {			var i:int=0, maxLetters:int = (bt.length > et.length)?bt.length:et.length, x:Number = 1/maxLetters, index:int = int(n/x), currentLetters:Array = [], nextLetters:Array = [], reg:RegExp = new RegExp(',','g');			for (i=0; i <  bt.length; i++) { nextLetters.push(  bt.charAt(i) ); }			for (i = 0; i <  et.length; i++) { currentLetters.push(  et.charAt(i) ); }			for (i = 0; i < index ; i++) { currentLetters[i] = (nextLetters[i])?nextLetters[i]:''; }			return currentLetters.toString().replace(reg, '');		}	}}