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
		public function TriangleShape(A:Point=null,B:Point=null,C:Point=null,color:uint=0x000000,lineThickness:Number=NaN, lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'triangle';
			A = (A)?A: new Point(0, -8);
			B = (B)?B: new Point(10, 10);
			C = (C)?C: new Point(-10, 10);
			this.color = color;
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