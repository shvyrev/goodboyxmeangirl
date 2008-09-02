/**
* Draw shapes and pixels shapes
* 
* @author Richard Rodney
*/

package railk.as3.display.drawingShape
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import railk.as3.utils.DynamicRegistration;
	
	
	public class DrawingShape extends DynamicRegistration
	{
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
		
		
		/**
		 * 
		 * @param	...args   {width:,height:,points:[{A(x,y),B(x,y)},...]}
		 */
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  DRAW PIXELS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function drawPixelShape( color:uint, data:Object ):void {
			var result:Bitmap = new Bitmap( new BitmapData( data.width, data.height, true, 0x00FFFFFF ) );
			for ( var i:int = 0; i < data.points.length; i++ ){
				var x:int = data.points[i].A.x;
				var y:int = data.points[i].A.y;
				var dx:int = data.points[i].B.x - data.points[i].A.x;
				var dy:int = data.points[i].B.y - data.points[i].A.y;
				var absDx:Number;
				var absDy:Number;
				var sqrDist:Number = Math.sqrt( dx * dx + dy * dy );
				
				if (dx == 0 && dy == 0 ) result.bitmapData.setPixel32( x,y,color );
				else
				{
					var yLonger:Boolean=false;
					if (dx < 0)  absDx = -dx; else absDx = dx;
					if (dy < 0)  absDx = -dy; else absDy = dy;
					if (absDy>absDx) {
						var swap=dy;
						dy=dx;
						dx=swap;				
						yLonger=true;
					}
					var decInc:int;
					if (dx==0) decInc=0;
					else decInc = (dy << 16) / dx;

					if (yLonger) {
						if (dx>0) {
							dx+=y;
							for (var j:int = 0x8000 + (x << 16); y <= dx; y++) {
								result.bitmapData.setPixel32( j >> 16,y,color );
								j+=decInc;
							}
						}
						dx+=y;
						for (j = 0x8000 + (x << 16); y >= dx; y--) {
							result.bitmapData.setPixel32( j >> 16,y,color );
							j-=decInc;
						}
					}

					if (dx>0) {
						dx+=x;
						for (j = 0x8000 + (y << 16); x <= dx; x++) {
							result.bitmapData.setPixel32( x,j >> 16,color );
							j+=decInc;
						}
					}
					dx+=x;
					for (j = 0x8000 + (y << 16); x >= dx; x--) {
						result.bitmapData.setPixel( x,j >> 16,color );
						j-=decInc;
					}
				}	
			}
			this.addChild( result );
		}
	}
}