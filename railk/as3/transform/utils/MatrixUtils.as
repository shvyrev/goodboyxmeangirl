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
		public function scaleX( dist:Number ):void
		{
			m2.a = m.a + (dist/tWidth)*m.a;
			m2.tx = oX;
			m2.ty = oY;
			t.matrix = m2;
		}
		
		public function scaleY( dist:Number ):void
		{
			m2.d = m.d + (dist/tHeight)*m.d;
			m2.tx = oX;
			m2.ty = oY;
			t.matrix = m2;
		}
		
		public function skewX( dist:Number ):void
		{
			m2.c = m.c + (dist/tHeight) * m.d;
			m2.tx = oX;
			m2.ty = oY;
			t.matrix = m2;
		}
		
		public function skewY( dist:Number ):void
		{
			m2.b = m.b + (dist/tWidth) * m.a;
			m2.tx = oX;
			m2.ty = oY;
			t.matrix = m2;
			
		}

		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			APPLY MATRIX MODIFICATIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function apply():void
		{
			tWidth = int( tWidth*(m2.a/m.a) );
			tHeight = int( tHeight*(m2.d/m.d) );
			m.a = m2.a;
			m.b = m2.b;
			m.c = m2.c;
			m.d = m2.d;
		}
    }
}
