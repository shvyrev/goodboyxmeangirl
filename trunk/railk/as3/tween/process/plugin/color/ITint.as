package railk.as3.tween.process.plugin.color {
	public interface ITint {
		function getType():String;
		function apply(target:Object, color:uint, progress:Number):void;
	}
}