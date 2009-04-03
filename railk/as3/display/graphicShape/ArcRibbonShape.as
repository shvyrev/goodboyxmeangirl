/**
 * Arc Circle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class ArcRibbonShape extends GraphicShape
	{
		public function ArcRibbonShape(epaisseur:int,color:uint,centerX:int,centerY:int,radius:int,startAngle:int,arcAngle:int,precision:int,copy:Boolean=false ) {
			super(copy);
			_type = 'arcRibbon';
			var X:int;
			var Y:int;
			var controlY:int;
			var controlX:int;
			var angle:Number;
			var radAngle:Number;
			var tanAngle:Number = Math.tan(toRadians( precision*.5 ));;
			var padding = Math.round( cornerRadius*.5 );
			var lineThickness = Math.min( epaisseur, cornerRadius);
			var outLine = Math.round( lineThickness*.5 );
			var outerRadius = radius + epaisseur - outLine;
			var innerRadius = radius + outLine;
			var outerCornerAngle = padding / (Math.PI * 2 * outerRadius) * 360;
			var innerCornerAngle  = padding / (Math.PI * 2 * innerRadius) * 360;
			var radOuterCornerAngle  = toRadians(outerCornerAngle);
			var radInnerCornerAngle = toRadians(innerCornerAngle);
			var demiAngle:Number;
			var innerArcAngle:Number;
			
			//--Begin ribbon shape
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill( color );
			this.graphicsCopy.lineStyle( lineThickness, color, 100, false, "normal", "round", "round");
			
			//--first pointand line
			X = innerRadius * Math.cos(radInnerCornerAngle);
			Y = innerRadius * Math.sin(radInnerCornerAngle);
			this.graphicsCopy.moveTo( X,Y );
			X = outerRadius * Math.cos(radOuterCornerAngle);
			Y = outerRadius * Math.sin(radOuterCornerAngle);
			this.graphicsCopy.lineTo(X, Y);
			angle = outerCornerAngle;
			
			//--outer shape
			while (angle <= arcAngle - outerCornerAngle){

				if( angle != outerCornerAngle )
				{
					radAngle = toRadians(angle);
					demiAngle = toRadians(angle - 90);
					X = outerRadius * Math.cos(radAngle);
					Y = outerRadius * Math.sin(radAngle);
					controlX = X + outerRadius * tanAngle * Math.cos(demiAngle);
					controlY = Y + outerRadius * tanAngle * Math.sin(demiAngle);
					graphicsCopy.curveTo(controlX, controlY, X, Y);
				}
				angle= angle + precision;
			}
			
			//--inner Shape
			innerArcAngle = (arcAngle - outerCornerAngle * 2) % precision;
			if (innerArcAngle > 0)
			{
				tanAngle = Math.tan(toRadians(innerArcAngle / 2));
				angle = arcAngle - outerCornerAngle;
				radAngle = toRadians(angle);
				demiAngle = toRadians(angle - 90);
				X = outerRadius * Math.cos(radAngle);
				Y = outerRadius * Math.sin(radAngle);
				controlX = X + outerRadius * tanAngle * Math.cos(demiAngle);
				controlY = Y + outerRadius * tanAngle * Math.sin(demiAngle);
				graphicsCopy.curveTo(controlX, controlY, X, Y);
			}
			
			//--inner Shape
			if (innerRadius > 0)
			{
				angle = arcAngle - innerCornerAngle;
				X = innerRadius * Math.cos(toRadians(angle));
				Y = innerRadius * Math.sin(toRadians(angle));
				graphicsCopy.lineTo(X, Y);
				
				tanAngle = Math.tan(-toRadians(precision / 2));
				angle = arcAngle - innerCornerAngle;
				
				while (angle > innerCornerAngle) {
					if (angle != arcAngle - innerCornerAngle){
						radAngle = toRadians(angle);
						demiAngle = toRadians(angle - 90);
						X = innerRadius * Math.cos(radAngle);
						Y = innerRadius * Math.sin(radAngle);
						controlX = X + innerRadius * tanAngle * Math.cos(demiAngle);
						controlY = Y + innerRadius * tanAngle * Math.sin(demiAngle);
						graphicsCopy.curveTo(controlX, controlY, X, Y);
					}
					angle = angle - precision;
				}
				
				innerArcAngle = (arcAngle - innerCornerAngle * 2) % precision;
				if (innerArcAngle > 0)
				{
					if (angle <= innerCornerAngle)
					{
						tanAngle = Math.tan(-toRadians(innerArcAngle / 2));
						angle = innerCornerAngle;
						radAngle = toRadians(angle);
						demiAngle = toRadians(angle - 90);
						X = innerRadius * Math.cos(radAngle);
						Y = innerRadius * Math.sin(radAngle);
						controlX = X + innerRadius * tanAngle * Math.cos(demiAngle);
						controlY = Y + innerRadius * tanAngle * Math.sin(demiAngle);
						graphicsCopy.curveTo(controlX, controlY, X, Y);
					}
				}
			} else{
				graphicsCopy.lineTo(innerRadius, 0);
			}
			
			this.graphicsCopy.endFill();
		}
	}
	
	private function toRadians( degree:Number ):Number {
		return degree * 0.0174532925;
	}
	
}