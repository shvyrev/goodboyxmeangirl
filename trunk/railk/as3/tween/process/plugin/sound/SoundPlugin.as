package railk.as3.tween.process.plugin.sound {
	public class SoundPlugin
	{
		public function volume( value:Number ):void {
			this.proxy.soundTransform = value;
		}
		
		public function pan( value:Number ):void {
			this.proxy.soundTransform = value;
		}
	}
}