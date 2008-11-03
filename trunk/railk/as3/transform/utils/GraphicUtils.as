package railk.as3.transform.utils {
	
	import flash.display.Shape;
	import railk.as3.display.drawingShape.DrawingShape;
	import railk.as3.display.GraphicShape;
	
    public class GraphicUtils extends Shape
    {	
		public static function rotate():Object
		{
			var rotate:GraphicShape = new GraphicShape();
			rotate.donut(0x000000, 0, 0, 163, 140);
			return rotate;
		}
		
		public static function corner(color:uint):Object
		{
			var corner:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:14, height:14,  pixels:[ 
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,
					1,[color,1],1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[color,1],1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[color,1],1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[color,1],1,1,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,1,1,1,1,0,0,0,0,0,0,0,0,0
				] 
			}; 
			corner.drawPixelArrayShape( data );
			corner.setRegistration(7, 7);
			return corner;
		}
		
		public static function cornerSelected(color:uint):Object
		{
			var corner:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:24, height:24,  pixels:[ 
					0,0,0,0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,
					0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,
					0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,
					0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,
					0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,
					0,1,[0xFF000000,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					1,[0xFF000000,1],1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					1,[0xFF000000,1],1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					1,[0xFF000000,1],1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,1,[0xFF000000,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,1,[0xFF000000,1],1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,1,[0xFF000000,1],1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,1,[0xFF000000,1],1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,1,[0xFF000000,1],1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,1,[0xFF000000,1],1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,1,[0xFF000000,1],0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0
				] 
			}; 
			corner.drawPixelArrayShape( data );
			corner.setRegistration(7, 7);
			return corner;
		}
		
		public static function border():Object
		{
			var border:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:10, height:19, pixels:[ 
					[0xFFFFFFFF,1],1,1,1,1,1,0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],1,1,1,1,
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],1,1,1,1,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					1,1,1,1,1,1,0,0,0,0
				] 
			}; 
			border.drawPixelArrayShape( data );
			border.setRegistration(6, 9.5);
			return border;
		}
		
		public static function borderSelected():Object
		{
			var borderSel:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:10, height:19, pixels:[ 
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,
					1,1,[0xFF000000,1],1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],[0xFF000000,1],1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],1,[0xFF000000,1],1,1,1,1,1,1,1,
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1
				] 
			}; 
			borderSel.drawPixelArrayShape( data );
			borderSel.setRegistration(10, 9.5);
			return borderSel;
		}
		
		public static function plus():Object
		{
			var plus:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:8, height:8, pixels:[ 
					0,0,0,[0xFFFFFFFF,1],1,0,0,0,
					0,0,1,[0xFF000000,1],1,[0xFFFFFFFF,1],0,0,
					0,1,1,[0xFF000000,1],1,[0xFFFFFFFF,1],1,0,
					1,[0xFF000000,1],1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,[0xFFFFFFFF,1],
					0,1,1,[0xFF000000,1],1,[0xFFFFFFFF,1],1,0,
					0,0,1,[0xFF000000,1],1,[0xFFFFFFFF,1],0,0,
					0,0,0,[0xFFFFFFFF,1],1,0,0,0
				] 
			}; 
			plus.drawPixelArrayShape( data );
			plus.setRegistration( 4, 4);
			return plus;
		}
		
		public static function moins():Object
		{
			var moins:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:9, height:4, pixels:[ 
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,0,
					1,[0xFF000000,1],1,1,1,1,1,1,[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,[0xFFFFFFFF,1],
					0,1,1,1,1,1,1,1,0
				] 
			}; 
			moins.drawPixelArrayShape( data );
			moins.setRegistration(4.5, 2);
			return moins;
		}
		
		public static function regPoint(x,y):Shape
		{
			var regPoint:Shape = new Shape();
			regPoint.graphics.beginFill(0x00CCFF);
			regPoint.graphics.moveTo(x-5, y-5);
			regPoint.graphics.lineTo(x+5, y-5);
			regPoint.graphics.lineTo(x+5, y+5);
			regPoint.graphics.lineTo(x-5,y+5);
			regPoint.graphics.moveTo(x-5, y-5);
			regPoint.graphics.endFill();
			return regPoint;
		}
		
		public static function contour(x,y,w,h):Shape
		{
			var contour:Shape = new Shape();
			contour.graphics.lineStyle( 1, 0xFF0000, 1,true,'normal','square','miter' );
			contour.graphics.moveTo(x-1, y-1);
			contour.graphics.lineTo(x+w, y-1);
			contour.graphics.lineTo(x+w, y+h);
			contour.graphics.lineTo(x-1, y+h);
			contour.graphics.lineTo(x-1, y-1);
			return contour;
		}
		
		public static function bg(x,y,w,h):Shape
		{
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x000000,.5);
			bg.graphics.moveTo(x-2, y-2);
			bg.graphics.lineTo(x+w+1, y-2);
			bg.graphics.lineTo(x+w+1, y+h+1);
			bg.graphics.lineTo(x-2, y+h+1);
			bg.graphics.lineTo(x-2, y-2);
			bg.graphics.endFill();
			return bg;
		}
	}
}	