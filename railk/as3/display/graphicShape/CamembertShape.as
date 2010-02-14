/**
 * Camembert shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class CamembertShape extends GraphicShape
	{
		/**
		* 
		* @param	color
		* @param	X
		* @param	Y
		* @param	radius
		* @param	startAngle
		* @param	endAngle
		* @param	segments
		* @param	type  null:plein, "L":ligne, "FL":ligne et plein
		* @return
		*/
		public function CamembertShape(color:uint=0x000000,X:Number=0,Y:Number=0,radius:Number=10,startAngle:Number=0,endAngle:Number=360,segments:int=100,holeRadius:Number=5,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'camembert';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color,1);
			this.drawCamembert(X, Y, radius, startAngle, endAngle, segments);
			if(holeRadius) this.drawCamembert(X, Y, holeRadius, startAngle, endAngle, segments);
			this.graphicsCopy.endFill();
			this.color = color;
		}
		
		private function drawCamembert( X:Number, Y:Number, radius:Number, startAngle:Number, endAngle:Number, segments:int):void {
			var rad:Number = Math.PI/180;
			var segm:Number = (endAngle-startAngle)/segments;
			this.graphicsCopy.moveTo(X,Y);
			this.graphicsCopy.moveTo(X+radius*Math.cos(startAngle*rad), Y+radius*Math.sin(startAngle*rad));
			for (var s:Number = startAngle+segm; s<=endAngle+1; s += segm) {
				var c_x:Number = radius*Math.cos(s*rad);
				var c_y:Number = radius*Math.sin(s*rad);
				var a_x:Number = c_x+radius*Math.tan(segm/2*rad)*Math.cos((s-90)*rad);
				var a_y:Number = c_y+radius*Math.tan(segm/2*rad)*Math.sin((s-90)*rad);
				this.graphicsCopy.curveTo(a_x+x, a_y+y, c_x+x, c_y+y);
			}
			this.graphicsCopy.lineTo(X, Y);
		}
	}
	
}