package railk.as3.tween.process.plugin.sound {
	import flash.media.SoundTransform;
	public class SoundPlugin implements ISound {
		public function SoundPlugin() {}
		public function getType():String { return 'sound'; }
		public function volume( target:Object, value:Number ):void {
			value = 1 - value;
			target.soundTransform = new SoundTransform(value, target.soundTransform.pan);
		}
		public function pan( target:Object, value:Number ):void {
			target.soundTransform = new SoundTransform(target.soundTransform.volume, value);
		}
	}
}