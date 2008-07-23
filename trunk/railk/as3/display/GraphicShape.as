/**
* Display graphishapes
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.display {
	
	//_________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	//_________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.DynamicRegistration;
	
	
	public class GraphicShape extends DynamicRegistration {
	
		/**
		 * 
		 * @param	...args   new point(x,y),.../ or an array of point
		 */
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   DRAW SHAPE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function drawShape( color:uint, ...args ):void {
			var i:int;
			this.graphics.clear();
			this.graphics.beginFill(color);
			
			if ( args[0] is Point ){
				this.graphics.moveTo( args[0].x, args[0].y );
				for ( i= 1; i < args.length; i++ )
				{
					this.graphics.lineTo( args[i].x, args[i].y );
				}
			}
			else if ( args[0] is Array )
			{
				this.graphics.moveTo( args[0][0].x, args[0][0].y );
				for ( i= 1; i < args[0].length; i++ )
				{
					this.graphics.lineTo( args[0][i].x, args[0][i].y );
				}
			}
			this.graphics.endFill();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  DEGRADE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
		public function gradient(colors:Array, W:int, H:int, rotation:int, type:String, alphas:Array, ratios:Array, hide:Boolean=false):void {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(W, H, rotation, 0, 0);

			this.graphics.clear();
			this.graphics.beginGradientFill(type, colors, alphas, ratios, matrix, "pad","RGB"); 
			this.graphics.lineTo(W, 0);
			this.graphics.lineTo(W, H);
			this.graphics.lineTo(0, H);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
			(hide == true) ? this.alpha = 0 : this.alpha = 100;
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	RECTANGLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRect(X,Y,W,H);
			this.graphics.endFill();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TRIANGLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	A  point
		 * @param	B  point
		 * @param	C  point
		 * @param	color
		 */
		public function triangle (A:Point, B:Point, C:Point, color:uint):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.moveTo( A.x, A.y );
			this.graphics.lineTo( B.x, B.y );
			this.graphics.lineTo( C.x, C.y );
			this.graphics.endFill();
		}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  ROUND RECTANGLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(X,Y,W,H,cornerW,cornerH);
			this.graphics.endFill();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   CERCLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
			this.graphics.clear();
			this.graphics.beginFill(color,alpha);
			this.graphics.drawCircle(radius,radius,radius);
			this.graphics.endFill();
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	CAMEMBERT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
		public function camembert (color:uint, X:int, Y:int, radius:int, startAngle:int, endAngle:int, segments:int):void {
			//angle
			var rad:Number = Math.PI/180;
			var segm:Number = (endAngle-startAngle)/segments;
			
			//--erase existing
			this.graphics.clear();
			//camembert évolutif
			this.graphics.beginFill(color,1);
			this.graphics.moveTo(X,Y);
			this.graphics.moveTo(X+radius*Math.cos(startAngle*rad), Y+radius*Math.sin(startAngle*rad));
			for (var s:Number = startAngle+segm; s<=endAngle+1; s += segm) {
				var c_x = radius*Math.cos(s*rad);
				var c_y = radius*Math.sin(s*rad);
				var a_x = c_x+radius*Math.tan(segm/2*rad)*Math.cos((s-90)*rad);
				var a_y = c_y+radius*Math.tan(segm/2*rad)*Math.sin((s-90)*rad);
				this.graphics.curveTo(a_x+x, a_y+y, c_x+x, c_y+y);
			}
			this.graphics.lineTo(X, Y);
			this.graphics.endFill();
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   ARC CIRCLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		* 
		* @param	centerX
		* @param	centerY
		* @param	radius
		* @param	startAngle
		* @param	arcAngle
		* @param	steps
		*/
		public function arcCircle(epaisseur:int, color:uint, centerX:int, centerY:int, radius:int, startAngle:int, arcAngle:int, precision:int):void {
			//--erase existing
			this.graphics.clear();
			//
			startAngle = startAngle/360;
			arcAngle = arcAngle/360;
			//--
			var twoPI = 2 * Math.PI;
			var angleStep = arcAngle/precision;
			var X = centerX + Math.cos(startAngle * twoPI) * radius;
			var Y = centerY + Math.sin(startAngle * twoPI) * radius;
			//--
			this.graphics.lineStyle( epaisseur, color,1,false,"normal","square","round",3 );
			this.graphics.moveTo(X, Y);
			for(var i=1; i<=precision; i++){
				var angle = startAngle + i * angleStep;
				X = centerX + Math.cos(angle * twoPI) * radius;
				Y = centerY + Math.sin(angle * twoPI) * radius;
				this.graphics.lineTo(X, Y);
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	   ARC RIBBON
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function arcRibbon( epaisseur:int, color:uint, radius:int, cornerRadius:int, arcAngle:int, precision:int):void {
			
			//--vars
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
			this.graphics.clear();
			this.graphics.beginFill( color );
			this.graphics.lineStyle( lineThickness, color, 100, false, "normal", "round", "round");
			
			//--first pointand line
			X = innerRadius * Math.cos(radInnerCornerAngle);
			Y = innerRadius * Math.sin(radInnerCornerAngle);
			this.graphics.moveTo( X,Y );
			X = outerRadius * Math.cos(radOuterCornerAngle);
			Y = outerRadius * Math.sin(radOuterCornerAngle);
			this.graphics.lineTo(X, Y);
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
					graphics.curveTo(controlX, controlY, X, Y);
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
				graphics.curveTo(controlX, controlY, X, Y);
			}
			
			//--inner Shape
			if (innerRadius > 0)
			{
				angle = arcAngle - innerCornerAngle;
				X = innerRadius * Math.cos(toRadians(angle));
				Y = innerRadius * Math.sin(toRadians(angle));
				graphics.lineTo(X, Y);
				
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
						graphics.curveTo(controlX, controlY, X, Y);
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
						graphics.curveTo(controlX, controlY, X, Y);
					}
				}
			}
			else
			{
				graphics.lineTo(innerRadius, 0);
			}
			
			this.graphics.endFill();
		}	


		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   RIBBON UTILITY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function toRadians( degree:Number ):Number {
			return degree * 0.0174532925;
		}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	PIXEL SURFACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		* 
		* @param	color
		* @param	W
		* @param	H
		* @param	espaceW  minimum = 1
		* @param	espaceH  minimum = 1
		* @param	pair
		*/
		public function pixel( color:uint, W:int, H:int, espaceW:int, espaceH:int, pair:Boolean=false ):void { 	
			//initialisation
			var flagPair:int=0;
			var X:int = 0;
			var Y:int = 0;
			var bmp:Bitmap = new Bitmap( new BitmapData( W, H, true, 0x00FFFFFF ) );
			bmp.name = 'bmp';
			
			//pair
			if (flagPair == 0){ X=0; if(!pair){ flagPair = 1; } }
			else if (flagPair == 1) { X=1; flagPair = 0; }

			//calcul du nombre de pixel par ligne et du nombre de ligne
			var nbCol:int = Math.ceil( W/espaceW );
			var nbLigne:int = Math.ceil( H/espaceH );
			
			var m:Boolean = true;
			var xLoop:int = 0;
			var yLoop:int = 0;
			while (true) {
				m ? xLoop++ : --xLoop;
				
				bmp.bitmapData.setPixel32(X, Y, color);
				X = X+espaceW;
				
				if (xLoop == nbCol || xLoop == 0) {
					if (yLoop++ == nbLigne) break;
					m = !m;
					
					if (flagPair == 0){ X=0; if(!pair){ flagPair = 1; } }
					else if (flagPair == 1) { X=1; flagPair = 0; }
					Y = Y+espaceH;
				}
			}
			
			this.addChild( bmp );
		}
		
		public function erasePixel():void { 
			this.removeChild( this.getChildByName( 'bmp' ) );
		}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	PIXEL PATTERN
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		* 
		* @param	W 	largeur de la surface sur laquelle appliquer le pattern
		* @param	H 	hauteur de la surface sur laquelle appliquer le pattern
		* @param	color 	Object du type { flat:0xFF000000,trans:0x060000000 }
		* @param	pattern 	object de type {11:1, ....nn:n} ou n ---> 0=noColor, 1=flatColor, 2=transparentColor
		* @param	patternH	taille du pattern en hauteur
		* @param	patternW	taille du pattern en largeur
		* @return
		*/
		public function pattern( W:int, H:int, color:Object, pattern:Object, patternH:int, patternW:int ):void {
			
			//initialisation
			var X:int = 0;
			var Y:int = 0;
			var bmp:Bitmap = new Bitmap( new BitmapData( W, H, true, 0x00FFFFFF ) );
			
			//nombre de lignes/col de pattern
			var nbLigne = Math.ceil( H/patternH );
			var nbCol = Math.ceil( W/patternW );
			
			
			var m:Boolean = true;
			var xLoop:int = 0;
			var yLoop:int = 0;
			var nx:int;
			while (true) {
				nx = m ? xLoop++ : --xLoop;
				
				for( var i:int=1;i<=patternH;i++ ){
					for( var j:int=1;j<=patternW;j++ ){
						if( pattern[String(i)+String(j)] == 1) {
							bmp.bitmapData.setPixel32(X, Y, color.flat);
						}
						else if( pattern[String(i)+String(j)] == 2) {
							bmp.bitmapData.setPixel32(X, Y, color.trans);
						}
						X += 1;
					}
					Y+=1;
					X-=patternW;
				}
				
				
				X = patternW * nx;
				Y-=patternH;
				
				if (xLoop == nbCol+1 || xLoop == 0) {
					if (yLoop++ == nbLigne) break;
					m = !m;
					Y = patternH * yLoop;
					X = 0;
				}
			}
			
			this.addChild( bmp );
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	 PERLIN NOISE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		* 
		* @param	bmp            bitmapdata ou ecrire le perlinnoise
		* @param	grayscale      true or false
		* @return
		*/
		public function pnoise( bmp:BitmapData, grayscale:Boolean=true ):BitmapData {
			var seed:Number = Math.floor(Math.random() * 30);
			bmp.perlinNoise(2, 1, 1, seed, true, false, 7, grayscale, null);
			
			return bmp;
		}
	}
}