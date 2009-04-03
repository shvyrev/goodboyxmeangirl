/**
 * Arc Circle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class ArcCircleShape extends GraphicShape
	{
		public function ArcCircleShape(epaisseur:int,color:uint,centerX:int,centerY:int,radius:int,startAngle:int,arcAngle:int,precision:int,copy:Boolean=false ) {
			super(copy);
			_type = 'arcCircle';
			this.graphicsCopy.clear();
			startAngle = startAngle/360;
			arcAngle = arcAngle/360;
			var twoPI = 2 * Math.PI;
			var angleStep = arcAngle/precision;
			var X = centerX + Math.cos(startAngle * twoPI) * radius;
			var Y = centerY + Math.sin(startAngle * twoPI) * radius;
			this.graphicsCopy.lineStyle( epaisseur, color,1,false,"normal","square","round",3 );
			this.graphicsCopy.moveTo(X, Y);
			for(var i=1; i<=precision; i++){
				var angle = startAngle + i * angleStep;
				X = centerX + Math.cos(angle * twoPI) * radius;
				Y = centerY + Math.sin(angle * twoPI) * radius;
				this.graphicsCopy.lineTo(X, Y);
			}
		}
	}
	
}