package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	import railk.as3.tween.process.plugin.helpers.ColorMatrixHelper;
	public class GreyscalePlugin extends Array implements IColor {
		
		private var lumR:Number = 0.212671;
		private var lumG:Number = 0.715160;
		private var lumB:Number = 0.072169;
		private var identityMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var resultMatrix:Array;
		
		public function GreyscalePlugin(p_matrix:Array = null) { resultMatrix = identityMatrix.slice(); }
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'greyscale'; }
		public function apply( prop:*, amount:Number):Array {
			if (isNaN(prop)) return resultMatrix;
			amount = 1*prop;
			var inv:Number = 1 - amount;
			var temp:Array = [.3,.59,.11,0,0,.3,.59,.11,0,0,.3,.59,.11,0,0,0,0,0,1,0];
			return ColorMatrixHelper.applyMatrix(temp, resultMatrix);
		}
		public function setMatrix(m:Array):void { resultMatrix = m; }
		public function reset():Array { return identityMatrix; }
	}	
}