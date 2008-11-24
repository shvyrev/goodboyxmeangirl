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
    import flash.geom.Point;
    import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

    public class MatrixUtils 
	{
		// ________________________________________________________________________________________ VARIABLES
		private var _target:*;
		private var _assieteX:Number=0;
		private var _assieteY:Number=0;
		private var t:Transform;
		private var m:Matrix;
		private var m2:Matrix;
		
		private var oX:Number;
		private var oY:Number;
		private var distX:Number=0;
		private var distY:Number = 0;
		private var lastSkewX:Number=0;
		private var lastSkewY:Number = 0;
		private var lastDistX:Number=0;
		private var lastDistY:Number=0;
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
			m2 = new Matrix(1,0,0,1,m.tx,m.ty);
			
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
			m2.c = m.c + (dist / tHeight) * m.d;
			if ( constraint == 'UP' )
			{
				m2.tx = oX-dist;
			}
			else
			{
				m2.tx = oX;
			}
			m2.ty = oY;
			t.matrix = m2;
			_assieteX =  lastSkewX + dist;
		}
		
		public function skewY( dist:Number, constraint:String ):void
		{
			m2.b = m.b + (dist/tWidth) * m.a;
			m2.tx = oX;
			if ( constraint == 'LEFT' )
			{
				m2.ty = oY-dist;
			}
			else
			{
				m2.ty = oY;
			}
			t.matrix = m2;
			_assieteY = lastSkewY + dist;		
		}
		
		
		public function rotate( x:Number, y:Number, angle:Number ):void
		{
			var p:Point = new Point(x, y);
			var a:Point = _target.parent.globalToLocal(_target.localToGlobal(p));
			_target.rotation = angle;
			var b:Point = _target.parent.globalToLocal(_target.localToGlobal(p));
			_target.x -= (b.x -a.x);
			_target.y -= (b.y -a.y);
			m2 = _target.transform.matrix;
		}

		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			APPLY MATRIX MODIFICATIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function apply():void
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
			lastSkewX = _assieteX;
			lastSkewY = _assieteY;
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
		// 																					   	 GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get bounds():Rectangle { return new Rectangle(distX, distY, _target.width, _target.height); }
		
		public function get assieteX():Number { return _assieteX; }
		
		public function get assieteY():Number { return _assieteY; }
    }
}
