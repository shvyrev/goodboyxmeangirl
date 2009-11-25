/**
 * Triangle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	import flash.geom.Point;
	public class TriangleShape extends GraphicShape
	{
		public function TriangleShape(A:Point,B:Point,C:Point,color:uint,lineThickness:Number=NaN, lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'triangle';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.moveTo( A.x, A.y );
			this.graphicsCopy.lineTo( B.x, B.y );
			this.graphicsCopy.lineTo( C.x, C.y );
			this.graphicsCopy.endFill();
		}
	}
}