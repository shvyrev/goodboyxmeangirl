package railk.as3.tween.process.plugin.color {

	import flash.filters.ColorMatrixFilter;
	public class ColorPlugin implements IFilters {
		
		private static var _ID_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		public var matrix:Array;
		
		public function ColorPlugin() { this.matrix = _ID_MATRIX.slice(); }
		public function getType() { return 'color' }
		public function setBrightness(n:Number):void {}
		public function setContrast(n:Number):void {}
		public function setHue(n:Number):void {}
		public function setSaturation(n:Number):void {}
		public function setThreshold(n:Number):void {}
		public function setColorize(color:uint, amount:Number=1):void {}
	}
	
}