/**
* Display graphishapes
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.display {
	
	import flash.geom.Matrix;
	import flash.display.Graphics;
	import flash.geom.Point;
	import railk.as3.utils.DynamicRegistration;
	
	
	public class GraphicShape extends DynamicRegistration {
		
		public var graphicsCopy:*;
		public var copy:Boolean;
	
		
		public function GraphicShape(copy:Boolean=false)
		{
			this.copy = copy;
			if ( copy ) graphicsCopy = new GraphicCopy(graphics);
			else graphicsCopy = graphics;
		}
		
		// ��������������������������������������������������������������������������������������������������
		// 																						 	  DEGRADE
		// ��������������������������������������������������������������������������������������������������
		/**
		* 
		* @param	colors     [ 0xffffff, ... ]
		* @param	W
		* @param	H
		* @param	rotation   0 | 360
		* @param	type      'radial' | 'linear'
		* @param	alphas    [ 100, 100, ...]
		* @param	ratios    [ 0, 0xFF, ... ]
		* @param	hide
		* @return
		*/
		public function gradient(colors:Array, W:int, H:int, rotation:int, type:String, alphas:Array, ratios:Array, hide:Boolean = false):void 
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(W, H, rotation, 0, 0);
			
			this.graphicsCopy.clear();
			this.graphicsCopy.beginGradientFill(type, colors, alphas, ratios, matrix, "pad","RGB"); 
			this.graphicsCopy.lineTo(W, 0);
			this.graphicsCopy.lineTo(W, H);
			this.graphicsCopy.lineTo(0, H);
			this.graphicsCopy.lineTo(0, 0);
			this.graphicsCopy.endFill();
			(hide == true) ? this.alpha = 0 : this.alpha = 100;
		}
		
		// ��������������������������������������������������������������������������������������������������
		// 																						 	RECTANGLE
		// ��������������������������������������������������������������������������������������������������
		/**
		* 
		* @param	color
		* @param	X
		* @param	Y
		* @param	W
		* @param	H
		* @return
		*/
		public function rectangle (color:uint, X:int, Y:int, W:int, H:int):void
		{
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.drawRect(X,Y,W,H);
			this.graphicsCopy.endFill();
		}
		
		// ��������������������������������������������������������������������������������������������������
		// 																						 	TRIANGLE
		// ��������������������������������������������������������������������������������������������������
		/**
		 * 
		 * @param	A  point
		 * @param	B  point
		 * @param	C  point
		 * @param	color
		 */
		public function triangle (A:Point, B:Point, C:Point, color:uint):void
		{
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.moveTo( A.x, A.y );
			this.graphicsCopy.lineTo( B.x, B.y );
			this.graphicsCopy.lineTo( C.x, C.y );
			this.graphicsCopy.endFill();
		}
		
		// ��������������������������������������������������������������������������������������������������
		// 																					  ROUND RECTANGLE
		// ��������������������������������������������������������������������������������������������������
		/**
		* 
		* @param	color
		* @param	X
		* @param	Y
		* @param	W
		* @param	H
		* @param	cornerW
		* @param	cornerH
		* @return
		*/
		public function roundRectangle (color:uint, X:int, Y:int, W:int, H:int, cornerW:int, cornerH:int):void
		{
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.drawRoundRect(X,Y,W,H,cornerW,cornerH);
			this.graphicsCopy.endFill();
		}
		
		// ��������������������������������������������������������������������������������������������������
		// 																						 	   CERCLE
		// ��������������������������������������������������������������������������������������������������
		/**
		* 
		* @param	color
		* @param	X
		* @param	Y
		* @param	radius
		* @return
		*/
		public function cercle (color:uint, X:int, Y:int, radius:Number, alpha:Number=-1):void {
			if (alpha == -1){ alpha = 1; }
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill(color,alpha);
			this.graphicsCopy.drawCircle(radius,radius,radius);
			this.graphicsCopy.endFill();
		}
		
		// ��������������������������������������������������������������������������������������������������
		// 																						 	CAMEMBERT
		// ��������������������������������������������������������������������������������������������������
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
		public function camembert (color:uint, X:int, Y:int, radius:int, startAngle:int, endAngle:int, segments:int):void 
		{
			var rad:Number = Math.PI/180;
			var segm:Number = (endAngle-startAngle)/segments;
			
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill(color,1);
			this.graphicsCopy.moveTo(X,Y);
			this.graphicsCopy.moveTo(X+radius*Math.cos(startAngle*rad), Y+radius*Math.sin(startAngle*rad));
			for (var s:Number = startAngle+segm; s<=endAngle+1; s += segm) {
				var c_x = radius*Math.cos(s*rad);
				var c_y = radius*Math.sin(s*rad);
				var a_x = c_x+radius*Math.tan(segm/2*rad)*Math.cos((s-90)*rad);
				var a_y = c_y+radius*Math.tan(segm/2*rad)*Math.sin((s-90)*rad);
				this.graphicsCopy.curveTo(a_x+x, a_y+y, c_x+x, c_y+y);
			}
			this.graphicsCopy.lineTo(X, Y);
			this.graphicsCopy.endFill();
		}
		
		
		// ��������������������������������������������������������������������������������������������������
		// 																						   ARC CIRCLE
		// ��������������������������������������������������������������������������������������������������
		/**
		* 
		* @param	centerX
		* @param	centerY
		* @param	radius
		* @param	startAngle
		* @param	arcAngle
		* @param	steps
		*/
		public function arcCircle(epaisseur:int, color:uint, centerX:int, centerY:int, radius:int, startAngle:int, arcAngle:int, precision:int):void 
		{
			this.graphicsCopy.clear();
			startAngle = startAngle/360;
			arcAngle = arcAngle/360;
			var twoPI = 2 * Math.PI;
			var angleStep = arcAngle/precision;
			var X = centerX + Math.cos(startAngle * twoPI) * radius;
			var Y = centerY + Math.sin(startAngle * twoPI) * radius;
			//--
			this.graphicsCopy.lineStyle( epaisseur, color,1,false,"normal","square","round",3 );
			this.graphicsCopy.moveTo(X, Y);
			for(var i=1; i<=precision; i++){
				var angle = startAngle + i * angleStep;
				X = centerX + Math.cos(angle * twoPI) * radius;
				Y = centerY + Math.sin(angle * twoPI) * radius;
				this.graphicsCopy.lineTo(X, Y);
			}
		}
		
		
		// ��������������������������������������������������������������������������������������������������
		// 																					 	   ARC RIBBON
		// ��������������������������������������������������������������������������������������������������
		public function arcRibbon( epaisseur:int, color:uint, radius:int, cornerRadius:int, arcAngle:int, precision:int):void 
		{
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
			}
			else
			{
				graphicsCopy.lineTo(innerRadius, 0);
			}
			
			this.graphicsCopy.endFill();
		}	

		private function toRadians( degree:Number ):Number {
			return degree * 0.0174532925;
		}
	}
}