package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Contrast extends Array implements IColor {
		public function Contrast() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'contrast'; }
		public function apply( m:Array, n:Number, amount:Number=NaN):Array {
			if (isNaN(n)) return m;
			n += 0.01;
			var temp:Array =  [n,0,0,0,128 * (1 - n),
							   0,n,0,0,128 * (1 - n),
							   0,0,n,0,128 * (1 - n),
							   0,0,0,1,0];
			return Helper.applyMatrix(temp,m);
		}
	}	
}