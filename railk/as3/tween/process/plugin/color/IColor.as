package railk.as3.tween.process.plugin.color {
	public interface IColor {
		function getType():String;
		function setBrightness(n:Number):Array;
		function setContrast(n:Number):Array
		function setHue(n:Number):Array;
		function setSaturation(n:Number):Array;
		function setThreshold(n:Number):Array;
		function setColor(color:uint, amount:Number=1):Array;
	}
}