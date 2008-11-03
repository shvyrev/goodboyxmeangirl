/**
 * 
 * dynamic registration point
 * 
 * @author Richard Rodney
 * @version 0.2
 */
package railk.as3.utils {
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Matrix;

	public class RegistrationPoint extends Sprite
	{
		private var rp						 :Point;
		private var rpT                      :Point;
		private var _x2                      :Number;
		private var _y2                      :Number;
		private var _scaleX2                 :Number;
		private var _scaleY2                 :Number;
		private var _scaleXY                 :Number;
		private var _rotation2               :Number;
		
		
		public function RegistrationPoint() 
		{
			_x2 = 0;
			_y2 = 0;
			_scaleX2 = 1;
			_scaleY2 = 1;
			_scaleXY = 1;
			_rotation2 = 0;
			rp = new Point(0, 0);
		}
		
		public function setRegistration(x:Number=0, y:Number=0):void
		{
			rp = new Point(x, y);
		}
		
		public function get reg():Point{
			return rp;
		}
		
		//X
		public function set x2(value:Number):void {
			this.x += value - rp.x;
			this._x2 = value;
		}
		public function get x2():Number {
			return rp.x;
		}

		//Y
		public function set y2(value:Number):void {
			this.y += value - rp.y;
			this._y2 = value;
		}
		public function get y2():Number {
			return rp.y;
		}
		
		//scaleX
		public function set scaleX2(value:Number):void {
			this.scaleX = value;
			rpT = this.transform.matrix.deltaTransformPoint(rp);
			this.x -= rpT.x - rp.x;
			this.y -= rpT.y - rp.y;
			this._scaleX2 = value;
		}
		public function get scaleX2():Number {
			return this._scaleX2;
		}
		
		//scaleY
		public function set scaleY2(value:Number):void {
			this.scaleY = value;
			rpT = this.transform.matrix.deltaTransformPoint(rp);
			this.x -= rpT.x - rp.x;
			this.y -= rpT.y - rp.y;
			this._scaleY2 = value;
		}
		public function get scaleY2():Number {
			return this._scaleY2;
		}
		
		//scaleXY
		public function set scaleXY(value:Number):void {
			this.scaleX = value;
			this.scaleY = value;
			rpT = this.transform.matrix.deltaTransformPoint(rp);
			this.x += rp.x - rpT.x;
			this.y += rp.y - rpT.y;
			this._scaleXY = value;
		}
		public function get scaleXY():Number {
			return this._scaleXY;
		}
		
		//rotation
		public function set rotation2(value:Number):void {
			this.rotation = value;
			rpT = this.transform.matrix.deltaTransformPoint(rp);
			this.x += rp.x -rpT.x;
			this.y += rp.y -rpT.y;
			this._rotation2 = value;
		}
		public function get rotation2():Number {
			return this._rotation2;
		}
		
		//getter mouseX et mouse Y
		public function get mouseX2():Number {
			return this.mouseX - rp.x;
		}
		public function get mouseY2():Number {
			return this.mouseY - rp.y;
		}

	}
}