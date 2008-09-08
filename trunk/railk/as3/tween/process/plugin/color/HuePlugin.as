package railk.as3.tween.process.plugin.color {

	import railk.as3.tween.process.plugin.helpers.ColorMatrixHelper;
	import railk.as3.tween.process.plugin.color.IColor;
	public class HuePlugin extends Array implements IColor {
		
		private var lumR:Number = 0.212671;
		private var lumG:Number = 0.715160;
		private var lumB:Number = 0.072169;
		private var identityMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var resultMatrix:Array;
		
		public function HuePlugin(p_matrix:Array = null) { resultMatrix = identityMatrix.slice(); }
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'hue'; }
		public function apply( prop:*, amount:Number):Array {
			var n:Number = prop * amount;
			if (isNaN(n)) return resultMatrix;
			n *= Math.PI / 180;
			var c:Number = Math.cos(n);
			var s:Number = Math.sin(n);
			var temp:Array = [(lumR + (c * (1 - lumR))) + (s * (-lumR)), (lumG + (c * (-lumG))) + (s * (-lumG)), (lumB + (c * (-lumB))) + (s * (1 - lumB)), 0, 0, (lumR + (c * (-lumR))) + (s * 0.143), (lumG + (c * (1 - lumG))) + (s * 0.14), (lumB + (c * (-lumB))) + (s * -0.283), 0, 0, (lumR + (c * (-lumR))) + (s * (-(1 - lumR))), (lumG + (c * (-lumG))) + (s * lumG), (lumB + (c * (1 - lumB))) + (s * lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			return ColorMatrixHelper.applyMatrix(temp, resultMatrix);
		}
		public function setMatrix(m:Array):void { resultMatrix = m; }
		public function reset():Array { return identityMatrix; }
	}	
}