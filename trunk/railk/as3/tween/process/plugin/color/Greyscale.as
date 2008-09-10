package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Greyscale extends Array implements IColor {
		public function Greyscale() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'greyscale'; }
		public function apply( m:Array, n:Number, amount:Number=NaN):Array {
			if (isNaN(n)) return m;
			var inv:Number = 1 - n;
			var temp:Array = [.3,.59,.11,0,0,.3,.59,.11,0,0,.3,.59,.11,0,0,0,0,0,1,0];
			return Helper.applyMatrix(temp, m);
		}
	}	
}