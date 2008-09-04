package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.ITint;
	import flash.geom.ColorTransform;
	public class  TintPlugin implements ITint {
		public function TintPlugin():void { };
		public function getType():String { return 'tint'; }
		public function setTint( target:Object, color:uint, n:Number ):void {
			var start:ColorTransform = target.transform.colorTransform;
			var end:ColorTransform = new ColorTransform();
			end.color = color;
			var result:ColorTransform = new ColorTransform();
			result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier)*n;
			result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier)*n;
			result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier)*n;
			result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier)*n;
			result.redOffset = start.redOffset + (end.redOffset - start.redOffset)*n;
			result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset)*n;
			result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset)*n;
			result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * n;
			target.transform.colorTransform = result;
		}
	}
	
}