package railk.as3.tween.process.plugin.color {
	public interface IColor {
		function getType():String;
		function setBrightness(n:Number):void;
		function setContrast(n:Number):void;
		function setHue(n:Number):void;
		function setSaturation(n:Number):void;
		function setThreshold(n:Number):void;
		function setColorize(color:uint, amount:Number = 1):void;
	}
}