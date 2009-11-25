/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import railk.as3.display.graphicShape.RectangleShape;
	import railk.as3.display.RegistrationPoint;
	
	public class RectLoading extends RegistrationPoint implements ILoading
	{	
		public var bar:RectangleShape;
		public var bg:RectangleShape;
		private var folower:*;
		
		private var _percent:Number;
		private var _color:uint;
		
		public function RectLoading(bgColor:uint,color:uint,x:Number,y:Number,width:Number,height:Number,folower:*=null) { 
			super();
			this.folower = folower;
			_color = color;
			bg = new RectangleShape(bgColor, x, y, width, height);
			bar = new RectangleShape(color, x, y, 1, height);
			this.addChild(bg);
			this.addChild(bar)
		}
		
		public function get color():uint { return _color; }
		public function set color( value:uint ):void {
			var c:ColorTransform = new ColorTransform();
			var t:Transform = new Transform(bar);
			c.color = value;
			t.colorTransform = c;
			_color = value;
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			bar.width =  (value * bg.width) * .01;
			if(folower!=null) folower.x = bar.width;
		}
	}
}