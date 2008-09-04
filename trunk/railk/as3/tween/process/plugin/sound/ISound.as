package railk.as3.tween.process.plugin.sound {
	public interface ISound
	{
		function getType():String;
		function pan(target:Object, value:Number):void;
		function volume(target:Object, value:Number):void;
	}
}