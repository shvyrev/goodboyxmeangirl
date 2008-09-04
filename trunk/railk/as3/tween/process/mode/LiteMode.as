package railk.as3.tween.process.mode {
	import railk.as3.tween.process.plugin.IPlugin;
	public class LiteMode implements IMode {
		public function LiteMode():void {}
		public function getManager():IPlugin { return null; }
		public function getPlugins():Array { return null; }
		public function enabled():Boolean { return false; }
	}
}