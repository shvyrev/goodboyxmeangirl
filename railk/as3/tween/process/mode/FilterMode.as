package railk.as3.tween.process.mode {
	import railk.as3.tween.process.plugin.color.*;
	import railk.as3.tween.process.plugin.filters.BevelFilterPlugin;
	import railk.as3.tween.process.plugin.filters.BlurFilterPlugin;
	import railk.as3.tween.process.plugin.filters.DropShadowFilterPlugin;
	import railk.as3.tween.process.plugin.filters.GlowFilterPlugin;
	import railk.as3.tween.process.plugin.IPlugin;
	import railk.as3.tween.process.plugin.PluginManager;
	import railk.as3.tween.process.plugin.sound.SoundPlugin;
	import railk.as3.tween.process.plugin.text.TextPlugin;
	public class FilterMode implements IMode {
		private var manager:IPlugin;
		private var plugins:Array;
		public function FilterMode():void { 
			manager = new PluginManager();
			plugins = [  new ColorizePlugin(), new BrightnessPlugin(), new HuePlugin(), new ContrastPlugin(), new SaturationPlugin(), new ThresholdPlugin(), new TintPlugin(), new TextPlugin(), new SoundPlugin(), new BevelFilterPlugin(), new BlurFilterPlugin(), new DropShadowFilterPlugin(), new GlowFilterPlugin() ]
		}
		public function getManager():IPlugin { return manager; }
		public function getPlugins():Array { return plugins; }
		public function enabled():Boolean { return true; }
	}
}