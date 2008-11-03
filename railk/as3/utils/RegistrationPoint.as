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

	public class RegistrationPoint extends Sprite
	{
		private var rp						 :Point;
		private var _a                       :Point;
		private var _b                       :Point;
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
		}
		
		public function setRegistration(x:Number=0, y:Number=0):void
		{
			rp = new Point(x, y);
		}
		
		public function get reg():Point{
			_a = this.getOrigin();
			return _a;
		}
		
		//X
		public function set x2(value:Number):void {
			_a = this.getOrigin();
			this.x += value - _a.x;
			this._x2 = value;
		}
		public function get x2():Number {
			return this.getOrigin().x;
		}

		//Y
		public function set y2(value:Number):void {
			_a = this.getOrigin();
			this.y += value - _a.y;
			this._y2 = value;
		}
		public function get y2():Number {
			return this.getOrigin().y;
		}
		
		//scaleX
		public function set scaleX2(value:Number):void {
			_a = this.getOrigin();
			this.scaleX = value;
			_b = this.getOrigin();
			this.x -= _b.x - _a.x;
			this.y -= _b.y - _a.y;
			this._scaleX2 = value;
		}
		public function get scaleX2():Number {
			return this._scaleX2;
		}
		
		//scaleY
		public function set scaleY2(value:Number):void {
			_a = this.getOrigin();
			this.scaleY = value;
			_b = this.getOrigin();
			this.x -= _b.x - _a.x;
			this.y -= _b.y - _a.y;
			this._scaleY2 = value;
		}
		public function get scaleY2():Number {
			return this._scaleY2;
		}
		
		//scaleXY
		public function set scaleXY(value:Number):void {
			_a = this.getOrigin();
			this.scaleX = value;
			this.scaleY = value;
			_b = this.getOrigin();
			this.x += _a.x - _b.x;
			this.y += _a.y - _b.y;
			this._scaleXY = value;
		}
		public function get scaleXY():Number {
			return this._scaleXY;
		}
		
		//rotation
		public function set rotation2(value:Number):void {
			_a = this.getOrigin();
			this.rotation = value;
			_b = this.getOrigin();
			this.x += _a.x -_b.x;
			this.y += _a.y -_b.y;
			this._rotation2 = value;
		}
		public function get rotation2():Number {
			return this._rotation2;
		}
		
		
		//getter mouseX et mouse Y
		public function get mouseX2():Number {
			_a = this.getOrigin();
			return this.mouseX - _a.x;
		}
		public function get mouseY2():Number {
			_a = this.getOrigin();
			return this.mouseY - _a.y;
		}
		
		//recuperation du centre du clip
		private function getOrigin():Point{
			return rp;
		}
	}
}