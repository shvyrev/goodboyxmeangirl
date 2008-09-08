package railk.as3.tween.process.plugin.color {

	import railk.as3.tween.process.plugin.helpers.ColorMatrixHelper;
	import railk.as3.tween.process.plugin.color.IColor;
	public class SaturationPlugin extends Array implements IColor {
		
		private var lumR:Number = 0.212671;
		private var lumG:Number = 0.715160;
		private var lumB:Number = 0.072169;
		private var identityMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var resultMatrix:Array;
		
		public function SaturationPlugin(p_matrix:Array = null) { resultMatrix = identityMatrix.slice(); }
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'saturation'; }
		public function apply( prop:*, amount:Number):Array {
			var n:Number = prop * amount;
			if (isNaN(n)) return resultMatrix;
			var inv:Number = 1 - n;
			var r:Number = inv * lumR;
			var g:Number = inv * lumG;
			var b:Number = inv * lumB;
			var temp:Array = [r + n, g     , b     , 0, 0,
							  r     , g + n, b     , 0, 0,
							  r     , g     , b + n, 0, 0,
							  0     , 0     , 0     , 1, 0];
			return ColorMatrixHelper.applyMatrix(temp, resultMatrix);
		}
		public function setMatrix(m:Array):void { resultMatrix = m; }
		public function reset():Array { return identityMatrix; }
	}	
}