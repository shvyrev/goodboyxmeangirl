/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import railk.as3.display.RegistrationPoint;
	
	public class RectLoading extends RegistrationPoint
	{	
		private var bar:Shape;
		private var bg:Shape;
		private var _percent:Number;
		private var _color:uint;
		
		public function RectLoading(bgColor:uint,color:uint,x:Number,y:Number,width:Number,height:Number) { 
			super();
			_color = color;
			bg = new Shape();
			bg.graphics.beginFill(bgColor);
			bg.graphics.drawRect(x,y,width,height);
			bg.graphics.endFill();
			
			bar = new Shape();
			bar.graphics.beginFill(color);
			bar.graphics.drawRect(x,y,1,height);
			bar.graphics.endFill();
			
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
			bar.width =  (value*bg.width)*.01;
		}
	}
}