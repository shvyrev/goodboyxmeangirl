package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Hue extends Array implements IColor {
		private static var lumR:Number = 0.212671;
		private static var lumG:Number = 0.715160;
		private static var lumB:Number = 0.072169;
		public function Hue() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'hue'; }
		public function apply( m:Array , n:Number, amount:Number=NaN):Array {
			if (isNaN(n)) return m;
			n *= Math.PI / 180;
			var c:Number = Math.cos(n);
			var s:Number = Math.sin(n);
			var temp:Array = [(lumR + (c * (1 - lumR))) + (s * (-lumR)), (lumG + (c * (-lumG))) + (s * (-lumG)), (lumB + (c * (-lumB))) + (s * (1 - lumB)), 0, 0, (lumR + (c * (-lumR))) + (s * 0.143), (lumG + (c * (1 - lumG))) + (s * 0.14), (lumB + (c * (-lumB))) + (s * -0.283), 0, 0, (lumR + (c * (-lumR))) + (s * (-(1 - lumR))), (lumG + (c * (-lumG))) + (s * lumG), (lumB + (c * (1 - lumB))) + (s * lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			return Helper.applyMatrix(temp, m);
		}
	}	
}