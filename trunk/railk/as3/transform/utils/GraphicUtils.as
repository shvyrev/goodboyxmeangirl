package railk.as3.transform.utils {
	
	import flash.display.Sprite;
	import railk.as3.utils.DynamicRegistration;
	import railk.as3.display.drawingShape.DrawingShape;
	import railk.as3.display.GraphicShape;
	import railk.as3.display.DashedLine;
	
    public class GraphicUtils extends Sprite
    {	
		public static function rotate():GraphicShape
		{
			var rotate:GraphicShape = new GraphicShape();
			rotate.donut(0x000000, 0, 0, 163, 140);
			return rotate;
		}
		
		public static function corner(color:uint,x:Number,y:Number,rotation:Number):DrawingShape
		{
			var corner:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:14, height:14,  pixels:[ 
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,[color,1],[0xFFFFFFFF,1],
					1,[color,1],1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,[color,1],[0xFFFFFFFF,1],
					1,[color,1],1,1,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,
					[0xFFFFFFFF,1],1,1,[color,1],[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,[color,1],[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,[color,1],[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,[color,1],[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,[color,1],1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,0,
					1,1,1,1,1,0,0,0,0,0,0,0,0,0
				] 
			}; 
			corner.drawPixelArrayShape( data );
			corner.setRegistration(6, 6);
			corner.rotation2 = rotation;
			corner.x2 = x;
			corner.y2 = y;
			corner.alpha = .7;
			//corner.addChild( hover() );
			return corner;
		}
		
		public static function cornerSelected(x:Number,y:Number,rotation:Number):DrawingShape
		{
			var corner:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:24, height:23,  pixels:[ 
					0,0,0,0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,[0xFF000000,1],1,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,[0xFF000000,1],1,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,0,0,
					0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,[0xFF000000,1],1,0,0,0,0,0,
					0,0,0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFF000000,1],1,0,0,0,
					0,0,0,1,[0xFF000000,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFFFFFFFF,1],0,0,
					0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,[0xFF000000,1],1,0,
					0,1,[0xFF000000,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					1,[0xFF000000,1],1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,1,[0xFF000000,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,1,[0xFF000000,1],1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,[0xFFFFFFFF,1],1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,1,[0xFF000000,1],1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,[0xFFFFFFFF,1],1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,1,[0xFF000000,1],1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,[0xFFFFFFFF,1],1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				] 
			}; 
			corner.drawPixelArrayShape( data );
			corner.setRegistration(11, 11);
			corner.rotation2 = rotation;
			corner.x2 = x;
			corner.y2 = y;
			corner.alpha = .25;
			return corner;
		}
		
		public static function border(x:Number,y:Number,rotation:Number):DrawingShape
		{
			var border:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:10, height:19, pixels:[ 
					[0xFFFFFFFF,1],1,1,1,1,1,0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],1,1,1,1,
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,1,1,1,1,[0xFFFFFFFF,1],
					[0xFFFFFFFF,1],1,1,1,1,1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],1,1,1,1,
					[0xFFFFFFFF,1],1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],0,0,0,0,
					1,[0xFF000000,1],1,1,1,[0xFFFFFFFF,1],0,0,0,0,
					[0xFFFFFFFF,1],1,1,1,[0xFF000000,1],[0xFFFFFFFF,1],0,0,0,0,
					1,1,1,1,1,1,0,0,0,0
				] 
			}; 
			border.drawPixelArrayShape( data );
			border.setRegistration(6, 9);
			border.rotation2 = rotation;
			border.x2 = x;
			border.y2 = y;
			border.alpha = .7;
			//border.addChild( hover() );
			return border;
		}
		
		public static function borderSelected(x:Number,y:Number,rotation:Number):DrawingShape
		{
			var borderSel:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:10, height:19, pixels:[ 
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,1,1,
					1,[0xFFFFFFFF,1],1,1,1,1,1,1,1,[0xFF000000,1],
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
			borderSel.setRegistration(10, 9);
			borderSel.rotation2 = rotation;
			borderSel.x2 = x;
			borderSel.y2 = y;
			borderSel.alpha = .25;
			return borderSel;
		}
		
		public static function plus():DrawingShape
		{
			var plus:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:8, height:8, pixels:[ 
					0,0,0,[0xFFFFFFFF,1],1,0,0,0,
					0,0,[0xFFFFFFFF,1],1,[0xFF000000,1],1,0,0,
					0,1,1,[0xFF000000,1],1,[0xFFFFFFFF,1],1,0,
					[0xFFFFFFFF,1],1,1,1,1,1,[0xFF000000,1],1,
					1,[0xFF000000,1],1,1,1,1,1,[0xFFFFFFFF,1],
					0,1,[0xFFFFFFFF,1],1,[0xFF000000,1],1,1,0,
					0,0,1,[0xFF000000,1],1,[0xFFFFFFFF,1],0,0,
					0,0,0,1,1,0,0,0
				] 
			}; 
			plus.drawPixelArrayShape( data );
			plus.setRegistration( 4, 4);
			return plus;
		}
		
		public static function moins():DrawingShape
		{
			var moins:DrawingShape = new DrawingShape();
			var data:Object =  { 
				width:9, height:4, pixels:[ 
					0,[0xFFFFFFFF,1],1,1,1,1,1,1,0,
					[0xFFFFFFFF,1],1,1,1,1,1,1,[0xFF000000,1],1,
					1,[0xFF000000,1],1,1,1,1,1,1,[0xFFFFFFFF,1],
					0,1,1,1,1,1,1,1,0
				] 
			}; 
			moins.drawPixelArrayShape( data );
			moins.setRegistration(4, 2);
			return moins;
		}
		
		public static function regPoint(x,y):DynamicRegistration
		{
			var regPoint:DynamicRegistration = new DynamicRegistration();
			regPoint.graphics.lineStyle(.5,0xFFFFFF,1);
			regPoint.graphics.beginFill(0x000000, 1);
			regPoint.graphics.drawCircle(x, y, 6);
			regPoint.graphics.drawCircle(x, y, 3);
			regPoint.graphics.drawCircle(x, y, 1.5);
			regPoint.graphics.endFill();
			regPoint.alpha = .8;
			return regPoint;
		}
		
		public static function contour(x,y,w,h):Sprite
		{
			var contour:Sprite = new Sprite();
			contour.graphics.lineStyle( 1, 0x000000, 1,true,'normal','square','miter' );
			contour.graphics.moveTo(x-1, y-1);
			contour.graphics.lineTo(x+w, y-1);
			contour.graphics.lineTo(x+w, y+h);
			contour.graphics.lineTo(x-1, y+h);
			contour.graphics.lineTo(x - 1, y - 1);
			contour.alpha = .12;
			return contour;
		}
		
		public static function bg(x,y,w,h):Sprite
		{
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x000000,.5);
			bg.graphics.moveTo(x-1, y-1);
			bg.graphics.lineTo(x+w, y-1);
			bg.graphics.lineTo(x+w, y+h);
			bg.graphics.lineTo(x-1, y+h);
			bg.graphics.lineTo(x-1, y-1);
			bg.graphics.endFill();
			return bg;
		}
		
		public static function hover():GraphicShape
		{
			var hover:GraphicShape = new GraphicShape();
			hover.alpha = .4;
			hover.cercle(0xFF0000, 0, 0, 25);
			return hover;
		}
	}
}	