package railk.as3.tween.process.utils
{
	import flash.events.IEventDispatcher;
	public interface ITicker extends IEventDispatcher {
		function get position():Number;
		function get interval():Number;
	}
}