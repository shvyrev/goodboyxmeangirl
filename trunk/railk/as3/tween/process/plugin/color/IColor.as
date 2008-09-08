package railk.as3.tween.process.plugin.color {
	public interface IColor {
		function getType():String;
		function getSubType():String;
		function apply( prop:*, amount:Number):Array;
		function setMatrix(m:Array):void;
		function reset():Array;
	}
}