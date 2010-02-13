/**
* Display graphishapes
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.display.graphicShape {
	
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import railk.as3.display.UISprite;
	
	public class GraphicShape extends UISprite 
	{	
		public var graphicsCopy:*;
		protected var copy:Boolean;
		protected var _type:String;
		protected var c:ColorTransform;
		
		public function GraphicShape(copy:Boolean=false) {
			super();
			this.copy = copy;
			if ( copy ) graphicsCopy = new GraphicCopy(graphics);
			else graphicsCopy = graphics;
			c = this.transform.colorTransform;
		}
		
		public function execute(method:String,params:Array):void {
			this.graphicsCopy[method].apply(null, params);
		}
		
		override public function toString():String {
			return '[ GRAPHICSHAPE > ' + this.name.toUpperCase() + ', (type:' + this._type + ') ]';
		}
		
		public function get type():String { return _type; }
		
		public function get color():uint { return this.transform.colorTransform.color; }
		public function set color(value:uint):void {
			this.transform.colorTransform = new ColorTransform(0-c.redMultiplier, 0-c.greenMultiplier, 0-c.blueMultiplier, 1, ((value >> 16) & 0xff)-c.redOffset, ((value >> 8) & 0xff)-c.greenOffset, (value & 0xff)-c.blueOffset);
		}
	}
}