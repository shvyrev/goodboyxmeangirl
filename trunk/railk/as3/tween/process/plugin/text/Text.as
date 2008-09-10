package railk.as3.tween.process.plugin.text {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import railk.as3.utils.Utils
	public class Text implements IText {
		public function Text():void { }
		public function getType():String { return 'text' };
		public function changeColor( o:Object):void {
			var start:ColorTransform = new ColorTransform();
			start.color = o.info.target.textColor;
			var end:ColorTransform = new ColorTransform();
			end.color = o.info.color;
			var n:Number = o.target.progress, r:Number = 1 - n;
			var result:ColorTransform = new ColorTransform(start.redMultiplier * r + end.redMultiplier * n,
																		  start.greenMultiplier * r + end.greenMultiplier * n,
																		  start.blueMultiplier * r + end.blueMultiplier * n,
																		  start.alphaMultiplier * r + end.alphaMultiplier * n,
																		  start.redOffset * r + end.redOffset * n,
																		  start.greenOffset * r + end.greenOffset * n,
																		  start.blueOffset * r + end.blueOffset * n,
																		  start.alphaOffset * r + end.alphaOffset * n);
			o.info.target.textColor = result.color;
		}
		public function changeText( o:Object):void {
			var maxLetters:int = (o.info.text.length > o.info.target.text.length) ? o.info.text.length : o.info.target.text.length ;
			var x:Number = 1 / maxLetters;
			var currentLetters:Array = new Array();
			var nextLetters:Array = new Array();
			for (var i:int = 0; i <  o.info.text.length; i++) { nextLetters.push(  o.info.text.charAt(i) ); }
			for (i = 0; i <  o.info.target.text.length; i++) { currentLetters.push(  o.info.target.text.charAt(i) ); }
			var index:int = int(Number(o.target.progress) / x);
			for (i = 0; i < index ; i++) 
			{
				currentLetters[i] = (nextLetters[i]) ? nextLetters[i] : '';
			}
			var reg:RegExp = new RegExp(',','g');
			o.info.target.text = currentLetters.toString().replace(reg, '');
		}
	}
}