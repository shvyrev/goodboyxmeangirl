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
		public function RoundRectangleShape(color:uint,X:int,Y:int,W:int,H:int,cornerW:int,cornerH:int,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'roundRectangle';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.drawRoundRect(X,Y,W,H,cornerW,cornerH);
			this.graphicsCopy.endFill();
		}
	}
	
}