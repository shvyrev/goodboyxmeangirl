package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	import railk.as3.tween.process.plugin.helpers.ColorMatrixHelper;
	public class ColorizePlugin extends Array implements IColor {
		
		private var lumR:Number = 0.212671;
		private var lumG:Number = 0.715160;
		private var lumB:Number = 0.072169;
		private var identityMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var resultMatrix:Array;
		
		public function ColorizePlugin(p_matrix:Array = null) { resultMatrix = identityMatrix.slice(); }
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'colorize'; }
		public function apply( prop:*, amount:Number):Array {
			resultMatrix = identityMatrix.slice();
			if (isNaN(prop)) return resultMatrix;
			else if (isNaN(amount)) amount = 1;
			var r:Number = ((prop >> 16) & 0xff) / 255;
			var g:Number = ((prop >> 8)  & 0xff) / 255;
			var b:Number = (prop         & 0xff) / 255;
			var inv:Number = 1 - amount;
			var temp:Array =  [inv + amount * r * lumR, amount * r * lumG,       amount * r * lumB,       0, 0,
							  amount * g * lumR,        inv + amount * g * lumG, amount * g * lumB,       0, 0,
							  amount * b * lumR,        amount * b * lumG,       inv + amount * b * lumB, 0, 0,
							  0, 				          0, 					     0, 					    1, 0];		
			return ColorMatrixHelper.applyMatrix(temp, resultMatrix);
		}
		public function setMatrix(m:Array):void { resultMatrix = m; }
		public function reset():Array { return identityMatrix; }
	}	
}