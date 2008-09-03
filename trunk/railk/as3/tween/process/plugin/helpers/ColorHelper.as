package railk.as3.tween.process.plugin.helpers {
	public class ColorHelper {
		public static function mix( initColor:uint, endColor:uint, progress:Number ):uint {
			var a:uint = (initColor >>> 24) + ((endColor >>> 24) - (initColor >>> 24)) * progress;
			var r:uint = (initColor >>> 16 & 0xFF) + ((endColor >>> 16 & 0xFF) - (initColor >>> 16 & 0xFF)) * progress;
			var g:uint = (initColor >>>  8 & 0xFF) + ((endColor >>>  8 & 0xFF) - (initColor >>>  8 & 0xFF)) * progress;
			var b:uint = (initColor & 0xFF) + ((endColor & 0xFF) - (initColor & 0xFF)) * progress;
			return  a << 24 | r << 16 | g << 8 | b;
		}
		public function split( color:uint ):Object { return { alpha:color >>> 24, red:color >>> 16 & 0xFF, green:color >>>  8 & 0xFF, blue:color & 0xFF }; } 
	}
}