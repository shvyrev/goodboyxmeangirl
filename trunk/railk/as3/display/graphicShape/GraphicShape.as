/**
* Display graphishapes
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.display.graphicShape {
	
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.geom.Matrix;
	import flash.display.Graphics;
	import flash.geom.Point;
	import railk.as3.display.RegistrationPoint;
	
	public class GraphicShape extends RegistrationPoint 
	{	
		public var graphicsCopy:*;
		protected var copy:Boolean;
		protected var _type:String;
		
		
		public function GraphicShape(copy:Boolean=false) {
			super();
			this.copy = copy;
			if ( copy ) graphicsCopy = new GraphicCopy(graphics);
			else graphicsCopy = graphics;
		}
		
		override public function toString():String {
			return '[ GRAPHICSHAPE > ' + this.name.toUpperCase() + ', (type:' + this._type + ') ]';
		}
		
		public function get color():uint { return this.transform.colorTransform.color; }
		public function set color(value:uint):void {
			var newCol:ColorTransform = new ColorTransform();
			var t:Transform = new Transform(this);
			newCol.color = value;
			t.colorTransform = newCol;
		}
		
		public function get type():String { return _type; }
	}
}