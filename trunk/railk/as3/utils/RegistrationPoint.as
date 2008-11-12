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
	import flash.geom.Rectangle;
	import fl.motion.MatrixTransformer;

	public class RegistrationPoint extends Sprite
	{
		private var rp						 :Point;
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
		
		public function setRegistration(x:Number, y:Number):void
		{
			rp = new Point(x, y);
		}
		
		public function get reg():Point{
			return global;
		}
		
		//X
		public function set x2(value:Number):void {
			this.x += value - global.x;
			this._x2 = value;
		}
		public function get x2():Number {
			return global.x;
		}

		//Y
		public function set y2(value:Number):void {
			this.y += value - global.y;
			this._y2 = value;
		}
		public function get y2():Number {
			return global.y;
		}
		
		//scaleX
		public function set scaleX2(value:Number):void {
			this.setProperty( value, 'scaleX' );
			this._scaleX2 = value;
		}
		public function get scaleX2():Number {
			return this._scaleX2;
		}
		
		//scaleY
		public function set scaleY2(value:Number):void {
			this.setProperty( value, 'scaleY' );
			this._scaleY2 = value;
		}
		public function get scaleY2():Number {
			return this._scaleY2;
		}
		
		//scaleXY
		public function set scaleXY(value:Number):void {
			this.setProperty( value, 'scaleX', 'scaleY' );
			this._scaleXY = value;
		}
		public function get scaleXY():Number {
			return this._scaleXY;
		}
		
		//rotation
		public function set rotation2(value:Number):void {
			this.setProperty( value, 'rotation' );
			this._rotation2 = value;
		}
		public function get rotation2():Number {
			return this._rotation2;
		}
		
		//getter mouseX et mouse Y
		public function get mouseX2():Number {
			return this.mouseX - global.x;
		}
		public function get mouseY2():Number {
			return this.mouseY - global.y;
		}
		
		private function get global():Point
		{
			if (!rp) 
			{
				var bounds:Rectangle = this.getBounds(this.parent);
				rp = new Point((bounds.left + bounds.width) * .5, (bounds.top + bounds.height) * .5);
			}
			if (!this.parent) return this.localToGlobal(rp);
			return this.parent.globalToLocal(this.localToGlobal(rp));
		}
		
		private function setProperty(value:Number, ...props):void
		{
			var a:Point = global;
			for (var i:int = 0; i < props.length; i++) 
			{
				this[props[i]] = value;
			}
			var b:Point = global;
			this.x -= b.x -a.x;
			this.y -= b.y -a.y;
		}
	}
}