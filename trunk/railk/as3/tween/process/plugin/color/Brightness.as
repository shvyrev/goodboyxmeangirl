package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.IColor;
	public class Brightness extends Array implements IColor {
		public function Brightness() {}
		public function getType():String { return 'color'; }
		public function getSubType():String { return 'brightness'; }
		public function apply( m:Array,n:Number, amount:Number=NaN):Array {
			if (isNaN(n)) return m;
			n = (n * 100) - 100;
			return Helper.applyMatrix([1,0,0,0,n,
								0,1,0,0,n,
								0,0,1,0,n,
								0,0,0,1,0,
								0,0,0,0,1], m);
		}
	}	
}