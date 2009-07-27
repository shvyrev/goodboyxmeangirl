/**
 * Rectangle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class RectangleShape extends GraphicShape
	{
		public function RectangleShape(color:uint,X:Number,Y:Number,W:Number,H:Number,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'rectangle';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.drawRect(X,Y,W,H);
			this.graphicsCopy.endFill();
		}
	}
	
}