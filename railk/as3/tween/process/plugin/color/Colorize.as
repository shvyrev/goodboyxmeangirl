package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Colorize extends Array implements IColor {
		private static var lumR:Number = 0.212671;
		private static var lumG:Number = 0.715160;
		private static var lumB:Number = 0.072169;
		public function Colorize() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'colorize'; }
		public function apply( m:Array, color:Number, amount:Number=NaN):Array {
			if (isNaN(color)) return m;
			else if (isNaN(amount)) amount = 1;
			var r:Number = ((color >> 16) & 0xff) / 255;
			var g:Number = ((color >> 8)  & 0xff) / 255;
			var b:Number = (color         & 0xff) / 255;
			var inv:Number = 1 - amount;
			var temp:Array =  [inv + amount * r * lumR, amount * r * lumG,       amount * r * lumB,       0, 0,
							  amount * g * lumR,        inv + amount * g * lumG, amount * g * lumB,       0, 0,
							  amount * b * lumR,        amount * b * lumG,       inv + amount * b * lumB, 0, 0,
							  0, 				          0, 					     0, 					    1, 0];		
			return Helper.applyMatrix(temp, m);
		}
	}	
}