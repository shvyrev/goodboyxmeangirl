/**
 * 
 * RTween MatrixTransform utility
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MatrixTransform 
	{
		public var instance : DisplayObject;
		private var registrationPt : Point = new Point();
		private var _innerRegistrationPt : Point = new Point();
		private var _skewX : Number = 0;
		private var _skewY : Number = 0;
		private var _scaleX : Number = 0;
		private var _scaleY : Number = 0;
		private var _tXOffset : Number = 0;
		private var _tYOffset : Number = 0;
		private var degreeRads : Number = (Math.PI / 180);
		private var radsDegree : Number = (180 / Math.PI);

		public function MatrixTransform(instance : DisplayObject) {
			var mtx : Matrix = instance.transform.matrix;
			this.instance = instance;
			
			_skewX = Math.atan2(-mtx.c, mtx.d);
			_skewY = Math.atan2(mtx.b, mtx.a);
			_scaleX = Math.sqrt(mtx.a * mtx.a + mtx.b * mtx.b);
			_scaleY = Math.sqrt(mtx.c * mtx.c + mtx.d * mtx.d);
			
			registrationX = instance.x;
			registrationY = instance.y;
		}
		public function set registrationX(pixels : Number) : void {
			registrationPt.x = pixels;
			_innerRegistrationPt.x = (registrationPt.x - instance.x);
		}

		public function get registrationX() : Number {
			return registrationPt.x;
		}
		public function set registrationY(pixels : Number) : void {
			registrationPt.y = pixels;
			_innerRegistrationPt.y = (registrationPt.y - instance.y);
		}

		public function get registrationY() : Number {
			return registrationPt.y;
		}
		public function set tx(offset : Number) : void {
			_tXOffset = offset;
			
			updateRegistration();
		}

		public function get tx() : Number {
			return _tXOffset;
		}
		public function set ty(offset : Number) : void {
			_tYOffset = offset;
			
			updateRegistration();
		}

		public function get ty() : Number {
			return _tYOffset;
		}
		public function set degree(value : Number) : void {
			rotation = value * degreeRads;
		}

		public function get degree() : Number {
			return instance.rotation;
		}
		public function set rotation(rads : Number) : void {
			skewY = rads;
			skewX = rads;
		}

		public function get rotation() : Number {
			return instance.rotation * degreeRads;
		}
		public function set scaleX(amount : Number) : void {
			_scaleX = amount;
			
			var mtx : Matrix = instance.transform.matrix;
			
			mtx.a = _scaleX * Math.cos(_skewY);
			mtx.b = _scaleX * Math.sin(_skewY);

			instance.transform.matrix = mtx;
			
			updateRegistration();
		}

		public function get scaleX() : Number {
			return _scaleX;
		}
		public function set scaleY(amount : Number) : void {
			_scaleY = amount;
			
			var mtx : Matrix = instance.transform.matrix;
			
			mtx.c = _scaleY * -Math.sin(_skewX);
			mtx.d = _scaleY * Math.cos(_skewX);

			instance.transform.matrix = mtx;
			
			updateRegistration();
		}

		public function get scaleY() : Number {
			return _scaleY;
		}
		public function set skewY(rads : Number) : void {
			_skewY = rads;
			
			var mtx : Matrix = instance.transform.matrix;
			
			mtx.a = _scaleX * Math.cos(_skewY);
			mtx.b = _scaleX * Math.sin(_skewY);
			
			instance.transform.matrix = mtx;
			
			updateRegistration();
		}

		public function get skewY() : Number {
			return _skewY;
		}
		public function set skewYDegree(value : Number) : void {
			skewY = value * degreeRads;
		}

		public function get skewYDegree() : Number {
			return _skewY * radsDegree;
		}
		public function set skewX(rads : Number) : void {
			_skewX = rads;
			
			var mtx : Matrix = instance.transform.matrix;
			
			mtx.c = -_scaleY * Math.sin(_skewX);
			mtx.d = _scaleY * Math.cos(_skewX);
			
			instance.transform.matrix = mtx;
			
			updateRegistration();
		}

		public function get skewX() : Number {
			return _skewX;
		}
		public function set skewXDegree(value : Number) : void {
			skewX = value * degreeRads;
		}

		public function get skewXDegree() : Number {
			return _skewX * radsDegree;
		}
		private function updateRegistration() : void {
			var mtx : Matrix = instance.transform.matrix;
			
			var pt : Point = mtx.deltaTransformPoint(_innerRegistrationPt);
			mtx.tx = registrationPt.x - pt.x + _tXOffset;
			mtx.ty = registrationPt.y - pt.y + _tYOffset;
			
			instance.transform.matrix = mtx;
		}
		public function toString() : String {
			return "MatrixTransform {registrationX:" + registrationX + ", registrationY:" + registrationY + ", matrix:" + instance.transform.matrix + "}";
		}
	}
}
