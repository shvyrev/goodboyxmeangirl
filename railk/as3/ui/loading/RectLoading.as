/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import railk.as3.display.graphicShape.*;
	import railk.as3.display.RegistrationPoint;
	
	public class RectLoading extends RegistrationPoint
	{	
		private var bar:RectangleShape;
		private var bg:RectangleShape;
		private var _percent:Number;
		private var _color:uint;
		
		public function RectLoading(bgColor:uint,color:uint,x:Number,y:Number,height:Number,width:Number) { 
			super();
			_color = color;
			bg = new RectangleShape(bgColor,x,y,width,height);
			bar = new RectangleShape(color,x,y,1,height);
			this.addChild(bg);
			this.addChild(bar)
		}
		
		public function get color():uint { return _color; }
		public function set color( value:uint ):void { 
			bar.color = value;
			_color = value;
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			bar.width =  (value*bg.width)*.01;
		}
	}
}