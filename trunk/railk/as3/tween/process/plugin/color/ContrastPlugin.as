package railk.as3.tween.process.plugin.color {

	import railk.as3.tween.process.plugin.helpers.ColorMatrixHelper;
	import railk.as3.tween.process.plugin.color.IColor;
	public class ContrastPlugin extends Array implements IColor {
		
		private var lumR:Number = 0.212671;
		private var lumG:Number = 0.715160;
		private var lumB:Number = 0.072169;
		private var identityMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var resultMatrix:Array;
		
		public function ContrastPlugin(p_matrix:Array = null) { resultMatrix = identityMatrix.slice(); }
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'contrast'; }
		public function apply( prop:*, amount:Number):Array {
			var n:Number = prop * amount;
			if (isNaN(n)) return resultMatrix;
			n += 0.01;
			var temp:Array =  [n,0,0,0,128 * (1 - n),
							   0,n,0,0,128 * (1 - n),
							   0,0,n,0,128 * (1 - n),
							   0,0,0,1,0];
			return ColorMatrixHelper.applyMatrix(temp, resultMatrix);
		}
		public function setMatrix(m:Array):void { resultMatrix = m; }
		public function reset():Array { return identityMatrix; }
	}	
}