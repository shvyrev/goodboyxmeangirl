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
	
	public class DonutLoading extends RegistrationPoint implements ILoading
	{	
		private var cercle:DonutShape;
		private var bg:DonutShape;
		private var masker:CamembertShape;
		private var _percent:Number;
		private var _color:uint;
		private var radius:Number;
		
		public function DonutLoading( color:uint, bgColor:uint, radius:Number, innerRadius:Number ) { 
			super();
			_color = color;
			this.radius = radius;
			bg = new DonutShape(bgColor,0,0,radius,innerRadius);
			cercle = new DonutShape(color,0,0,radius,innerRadius);
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