package railk.as3.tween.process.plugin.color {
	import railk.as3.tween.process.plugin.color.ITint;
	import flash.geom.ColorTransform;
	public class  Tint implements ITint {
		public function Tint():void {};
		public function getType():String { return 'tint'; }
		public function apply( o:Object):void {
			var n:Number = o.target.progress, r:Number = 1 - n, sc:Object = o.info.color, ec:Object = o.info.endColor;
			o.info.target.transform.colorTransform = new ColorTransform(sc.redMultiplier * r + ec.redMultiplier * n,
																		  sc.greenMultiplier * r + ec.greenMultiplier * n,
																		  sc.blueMultiplier * r + ec.blueMultiplier * n,
																		  sc.alphaMultiplier * r + ec.alphaMultiplier * n,
																		  sc.redOffset * r + ec.redOffset * n,
																		  sc.greenOffset * r + ec.greenOffset * n,
																		  sc.blueOffset * r + ec.blueOffset * n,
																		  sc.alphaOffset * r + ec.alphaOffset * n);
		}
	}	
}