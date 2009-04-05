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
	
	public class CircleLoading extends RegistrationPoint
	{	
		private var cercle:CircleShape;
		private var bg:CircleShape;
		private var masker:CamembertShape;
		private var radius:Number;
		private var _percent:Number;
		private var _color:uint;
		
		public function CircleLoading( color:uint, bgColor:uint, radius:Number ) { 
			super();
			_color = color;
			this.radius = radius;
			bg = new CircleShape(bgColor,0,0,radius);
			cercle = new CircleShape(color,0,0,radius);
			cercle.alpha = 0;
			masker = new CamembertShape(0x000000,0,0,radius,0,0,100);
			masker.rotation = -90;
			
			this.addChild(bg);
			this.addChild(cercle);
			this.addChild(mask);
			cercle.mask = masker;	
		}
		
		public function get color():uint { return _color; }
		public function set color( value:uint ):void {
			cercle.color = value; 
			_color = value;
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			masker = new CamembertShape(_color,0,0,radius+10,0,(((!value)?1:value)*360)*.01,100);
			cercle.alpha = 1;
		}
	}
}