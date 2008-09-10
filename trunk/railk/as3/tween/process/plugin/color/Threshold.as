package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Threshold extends Array implements IColor {
		private static var lumR:Number = 0.212671;
		private static var lumG:Number = 0.715160;
		private static var lumB:Number = 0.072169;
		public function Threshold() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'threshold'; }
		public function apply( m:Array, n:Number, amount:Number=NaN):Array {
			if (isNaN(n)) return m;
			var temp:Array = [lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						0,           0,           0,           1,  0]; 
			return Helper.applyMatrix(temp, m);
		}
	}	
}