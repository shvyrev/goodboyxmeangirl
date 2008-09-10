package railk.as3.tween.process.plugin.color {
	public interface IColor {
		function getType():String;
		function getSubType():String;
		function apply( m:Array, n:Number, amount:Number=NaN):Array;

	}
}