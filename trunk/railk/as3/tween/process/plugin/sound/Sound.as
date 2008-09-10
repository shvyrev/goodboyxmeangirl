package railk.as3.tween.process.plugin.sound {
	import flash.media.SoundTransform;
	public class Sound implements ISound {
		public function Sound() {}
		public function getType():String { return 'sound'; }
		public function volume( o:Object ):void {
			var value:Number = o.target.progress;
			o.info.target.soundTransform = new SoundTransform(value, o.info.target.soundTransform.pan);
		}
		public function pan( o:Object ):void {
			o.info.target.soundTransform = new SoundTransform(o.info.target.soundTransform.volume, o.target.progress);
		}
	}
}