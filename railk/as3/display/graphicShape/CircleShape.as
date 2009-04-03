﻿/**
 * Circle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class CircleShape extends GraphicShape
	{
		public function CircleShape(color:uint,X:int,Y:int,radius:Number,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'cercle';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color,alpha);
			this.graphicsCopy.drawCircle(radius,radius,radius);
			this.graphicsCopy.endFill();
		}
	}
	
}