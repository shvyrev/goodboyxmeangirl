package railk.as3.tween.process.plugin.text {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	public class TextPlugin implements IText {
		public function TextPlugin():void { }
		public function getType():String { return 'text' };
		public function changeColor( target:Object, color:uint, n:Number ):void{
			var start:ColorTransform = target.transform.colorTransform;
			var end:ColorTransform = new ColorTransform();
			end.color = color;
			var result:ColorTransform = new ColorTransform();
			result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier)*n;
			result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier)*n;
			result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier)*n;
			result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier)*n;
			result.redOffset = start.redOffset + (end.redOffset - start.redOffset)*n;
			result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset)*n;
			result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset)*n;
			result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * n;
			target.transform.colorTransform = result;
		}
		public function changeText( target:Object, value:String, progress:Number ):void {
			var currentTextLength;
			var nextLetters:Array = new Array();
			for (var i:int = 0; i < value.length; i++) { nextLetters.push( value.charAt(i) ); }
		}
	}
}