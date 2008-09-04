package railk.as3.tween.process.mode {
	import railk.as3.tween.process.plugin.IPlugin;
	public interface IMode {
		function getManager():IPlugin;
		function getPlugins():Array;
		function enabled():Boolean;
	}
}