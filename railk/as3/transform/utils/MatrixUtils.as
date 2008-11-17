/**
* 
* Matrix transformation utility
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform.utils 
{
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import fl.motion.MatrixTransformer;

    public class MatrixUtils 
	{
		// ________________________________________________________________________________________ VARIABLES
		private var _target:*;
		private var t:Transform;
		private var m:Matrix;
		private var m2:Matrix;
		
		private var oX:Number;
		private var oY:Number;
		private var distX:Number=0;
		private var distY:Number=0;
		private var lastDistX:Number=0;
		private var lastDistY:Number=0;
		private var regDistX:Number=0;
		private var regDistY:Number=0;
		private var tWidth:Number;
		private var tHeight:Number;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								  INIT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function MatrixUtils(target:*):void
		{
			_target = target;
			t = new Transform(target);
			m = target.transform.matrix; 
			m2 = new Matrix();
			
			oX = target.x;
			oY = target.y;
			tWidth = target.width;
			tHeight = target.height;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   TRANSFORMER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function scaleX( dist:Number, constraint:String ):void
		{
			if ( constraint == 'LEFT')
			{
				m2.a = m.a - (dist/tWidth)*m.a;
				m2.tx = dist + oX;
				distX = lastDistX + dist;
			}
			else {
				m2.a = m.a + (dist / tWidth) * m.a;
				m2.tx = oX;
			}
			m2.ty = oY;
			t.matrix = m2;
		}
		
		public function scaleY( dist:Number, constraint:String ):void
		{
			if ( constraint == 'UP')
			{
				m2.d = m.d - (dist/tHeight)*m.d;
				m2.ty = dist + oY;
				distY = lastDistY + dist;
			}
			else {
				m2.d = m.d + (dist / tHeight) * m.d;
				m2.ty = oY;
			}	
			m2.tx = oX;
			t.matrix = m2;
		}
		
		public function scaleXY( distX:Number, distY:Number, constraint:String ):void
		{
			switch( constraint )
			{
				case 'LEFT_UP':
					m2.a = m.a - (distX/tWidth)*m.a;
					m2.d = m.d - (distY/tHeight)*m.d;
					m2.ty = distY + oY;
					m2.tx = distX + oX;
					this.distY = lastDistY + distY;
					this.distX = lastDistX + distX;
					break;
				
				case 'LEFT_DOWN':
					m2.a = m.a - (distX/tWidth)*m.a;
					m2.d = m.d + (distY/tHeight)*m.d;
					m2.ty = oY;
					m2.tx = distX + oX;
					this.distX = lastDistX + distX;
					break;
				
				case 'RIGHT_UP':
					m2.a = m.a + (distX/tWidth)*m.a;
					m2.d = m.d - (distY/tHeight)*m.d;
					m2.ty = distY + oY;
					m2.tx = oX;
					this.distY = lastDistY + distY;
					break;
					
				case 'RIGHT_DOWN':
					m2.a = m.a + (distX/tWidth)*m.a;
					m2.d = m.d + (distY/tHeight)*m.d;
					m2.ty =  oY;
					m2.tx =  oX;
					break;	
			}	
			t.matrix = m2;
		}
		
		public function skewX( dist:Number, constraint:String ):void
		{
			m2.c = m.c + (dist/tHeight) * m.d;
			m2.tx = oX;
			m2.ty = oY;
			t.matrix = m2;
		}
		
		public function skewY( dist:Number, constraint:String ):void
		{
			m2.b = m.b + (dist/tWidth) * m.a;
			m2.tx = oX;
			m2.ty = oY;
			t.matrix = m2;
		}

		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			APPLY MATRIX MODIFICATIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function apply(...args):void
		{
			tWidth = int( tWidth*(m2.a/m.a) );
			tHeight = int( tHeight*(m2.d/m.d) );
			m.tx = oX = m2.tx;
			m.ty = oY = m2.ty;
			m.a = m2.a;
			m.b = m2.b;
			m.c = m2.c;
			m.d = m2.d;
			lastDistX = distX;
			lastDistY = distY;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   UPDATE POISTION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function update():void
		{
			oX = _target.x;
			oY = _target.y;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		GET BOUNDS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get bounds():Rectangle
		{
			return new Rectangle(distX, distY, _target.width, _target.height);
		}
    }
}
