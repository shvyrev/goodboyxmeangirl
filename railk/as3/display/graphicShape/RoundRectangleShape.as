/**
 * Rectangle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class RoundRectangleShape extends GraphicShape
	{
		public function RoundRectangleShape(color:uint=0x000000,X:Number=0,Y:Number=0,W:Number=100,H:Number=100,cornerW:Number=10,cornerH:Number=10,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'roundRectangle';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.drawRoundRect(X,Y,W,H,cornerW,cornerH);
			this.graphicsCopy.endFill();
			this.setScaleGrid((cornerH > cornerW)?cornerH:cornerW);
			this.color = color;
		}
	}
}