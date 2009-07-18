/**
 * COLORS UTILS
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.color 
{
	public dynamic class ColorUtils
	{
		public static function getRGB(rgb:uint):Object {
			var r = rgb >> 16 & 0xff;
			var g = rgb >> 8 & 0xff;
			var b = rgb & 0xff;
			return {r:r, g:g, b:b};
		}
		
		public static function setRGB(r:int,g:int,b:int):uint {
			var rgb:uint = 0;
			rgb += (r<<16);
			rgb += (g<<8);
			rgb += (b);
			return rgb;
		}
		
		public static function getARGB(rgb:uint):Object {
			var a = rgb >> 24 & 0xff;
			var r = rgb >> 16 & 0xff;
			var g = rgb >> 8 & 0xff;
			var b = rgb & 0xff;
			return {a:a, r:r, g:g, b:b};
		}
		
		public static function setARGB(a:int,r:int,g:int,b:int):uint {
			var argb:uint = 0;
			argb += (a<<24);
			argb += (r<<16);
			argb += (g<<8);
			argb += (b);
			return argb;
		}
		
		public static function toGrayscale(c:uint):uint{
			var color:Object = getARGB(c);
			var c = 0;
			c += color.r * .3;
			c += color.g * .59;
			c += color.b * .11;
			color.r = color.g = color.b = c;
			return setARGB(color.a, color.r, color.g, color.b);
		}
		
		public static function RGBToHex(r:int, g:int, b:int):uint{
			var hex:uint = (r << 16 | g << 8 | b);
			return hex;
		}

		public static function HexToRGB(hex:uint):Array{
			var rgb:Array = [];
			var r:int = hex >> 16 & 0xFF;
			var g:int = hex >> 8 & 0xFF;
			var b:int = hex & 0xFF;
			rgb.push(r, g, b);
			return rgb;
		}

		public static function RGBtoHSV(r:int, g:int, b:int):Array{
			var max:uint = Math.max(r, g, b);
			var min:uint = Math.min(r, g, b);
			var hue:Number = 0;
			var saturation:Number = 0;
			var value:Number = 0;
			var hsv:Array = [];

			//get Hue
			if(max == min) hue = 0;
			else if(max == r) hue = (60 * (g-b) / (max-min) + 360) % 360;
			else if(max == g) hue = (60 * (b-r) / (max-min) + 120);
			else if(max == b) hue = (60 * (r-g) / (max-min) + 240);

			//get Value
			value = max;

			//get Saturation
			if(max == 0) saturation = 0;
			else saturation = (max - min) / max;

			hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
			return hsv;
		}

		public static function HSVtoRGB(h:Number, s:Number, v:Number):Array{
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			var rgb:Array = [];

			var tempS:Number = s / 100;
			var tempV:Number = v / 100;

			var hi:int = Math.floor(h/60) % 6;
			var f:Number = h/60 - Math.floor(h/60);
			var p:Number = (tempV * (1 - tempS));
			var q:Number = (tempV * (1 - f * tempS));
			var t:Number = (tempV * (1 - (1 - f) * tempS));

			switch(hi){
				case 0: r = tempV; g = t; b = p; break;
				case 1: r = q; g = tempV; b = p; break;
				case 2: r = p; g = tempV; b = t; break;
				case 3: r = p; g = q; b = tempV; break;
				case 4: r = t; g = p; b = tempV; break;
				case 5: r = tempV; g = p; b = q; break;
			}

			rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
			return rgb;
		}
		
		public static function HexToDeci(hex:String):uint {
			if (hex.substr(0, 2) != "0x") hex = "0x" + hex;
			return new uint(hex);
		}
	}
}