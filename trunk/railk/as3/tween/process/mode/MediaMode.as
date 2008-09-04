package railk.as3.tween.process.mode {
	import railk.as3.tween.process.plugin.IPlugin;
	import railk.as3.tween.process.plugin.color.TintPlugin;
	import railk.as3.tween.process.plugin.PluginManager;
	import railk.as3.tween.process.plugin.sound.SoundPlugin;
	import railk.as3.tween.process.plugin.text.TextPlugin;
	public class MediaMode implements IMode {
		private var manager:IPlugin;
		private var plugins:Array;
		public function MediaMode():void { 
			manager = new PluginManager();
			plugins = [new TintPlugin(), new SoundPlugin(), new TextPlugin()]
		}
		public function getManager():IPlugin { return manager; }
		public function getPlugins():Array { return plugins; }
		public function enabled():Boolean { return true; }
	}
}