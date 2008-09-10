package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Saturation extends Array implements IColor {
		private static var lumR:Number = 0.212671;
		private static var lumG:Number = 0.715160;
		private static var lumB:Number = 0.072169;
		public function Saturation() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'saturation'; }
		public function apply( m:Array, n:Number, amount:Number=NaN):Array {
			if (isNaN(n)) return m;
			var inv:Number = 1 - n;
			var r:Number = inv * lumR;
			var g:Number = inv * lumG;
			var b:Number = inv * lumB;
			var temp:Array = [r + n, g     , b     , 0, 0,
							  r     , g + n, b     , 0, 0,
							  r     , g     , b + n, 0, 0,
							  0     , 0     , 0     , 1, 0];
			return Helper.applyMatrix(temp, m);
		}
	}	
}