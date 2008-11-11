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
		private var tWidth:Number;
		private var tHeight:Number;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																								  INIT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
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
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						   TRANSFORMER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function scaleX( dist:Number, constraint:String ):void
		{
			if ( constraint == 'LEFT')
			{
				m2.a = m.a - (dist/tWidth)*m.a;
				m2.tx = dist + oX;
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
			}
			else {
				m2.d = m.d + (dist / tHeight) * m.d;
				m2.ty = oY;
			}	
			m2.tx = oX;
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

		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																			APPLY MATRIX MODIFICATIONS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function apply():void
		{
			tWidth = int( tWidth*(m2.a/m.a) );
			tHeight = int( tHeight * (m2.d / m.d) );
			m.tx = oX = m2.tx;
			m.ty = oY = m2.ty;
			m.a = m2.a;
			m.b = m2.b;
			m.c = m2.c;
			m.d = m2.d;
			
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					   UPDATE POISTION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function update():void
		{
			oX = _target.x;
			oY = _target.y;
		}
    }
}
