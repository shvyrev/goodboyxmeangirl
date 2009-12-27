﻿/**
 * 
 * dynamic registration point with change event for each value
 * 
 * @author Richard Rodney
 * @version 0.3
 */

package railk.as3.display 
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class RegistrationPoint extends Sprite
	{
		private var rp:Point;
		private var _x2:Number = 0;
		private var _y2:Number = 0;
		private var _scaleX2:Number = 1;
		private var _scaleY2:Number = 1;
		private var _scaleXY:Number = 1;
		private var _rotation2:Number = 0;
		public var dispatch:Boolean = true;
		
		public function RegistrationPoint() {
			super();
			setRegistration(0,0);
		}
		
		public function setRegistration(x:Number, y:Number):void { rp = new Point(x, y); }
		public function getRegistration():Point { return rp; }
		
		/**
		 * OVERRIDES
		 */
		override public function set x(value:Number):void { super.x = value; dispatchChange(); }
		override public function set y(value:Number):void { super.y = value; dispatchChange(); }
		override public function set width(value:Number):void { super.width = value; dispatchChange(); }
		override public function set height(value:Number):void { super.height = value; dispatchChange(); }
		
		/**
		 * X2
		 */
		public function get x2():Number { return global.x; }
		public function set x2(value:Number):void {
			this.x += value - global.x;
			this._x2 = value;
		}

		/**
		 * Y2
		 */
		public function get y2():Number { return global.y; }
		public function set y2(value:Number):void {
			this.y += value - global.y;
			this._y2 = value;
		}
		
		/**
		 * SCALEX2
		 */
		public function get scaleX2():Number { return this._scaleX2; }
		public function set scaleX2(value:Number):void {
			this.setProperty( value, 'scaleX' );
			this._scaleX2 = value;
		}
		
		/**
		 * SCALEY2
		 */
		public function get scaleY2():Number { return this._scaleY2; }
		public function set scaleY2(value:Number):void {
			this.setProperty( value, 'scaleY' );
			this._scaleY2 = value;
		}
		
		/**
		 * SCALEXY
		 */
		public function get scaleXY():Number { return this._scaleXY; }
		public function set scaleXY(value:Number):void {
			this.setProperty( value, 'scaleX', 'scaleY' );
			this._scaleXY = value;
		}
		
		/**
		 * ROTATION2
		 */
		public function get rotation2():Number { return this._rotation2; }
		public function set rotation2(value:Number):void {
			this.setProperty( value, 'rotation' );
			this._rotation2 = value;
		}
		
		/**
		 * MOUSE
		 */
		public function get mouseX2():Number { return this.mouseX - global.x; }
		public function get mouseY2():Number { return this.mouseY - global.y; }
		
		/**
		 * UTILITIES
		 */
		private function get global():Point {
			if (!this.parent) return this.localToGlobal(rp);
			return this.parent.globalToLocal(this.localToGlobal(rp));
		}
		
		private function setProperty(value:Number, ...props):void {
			var a:Point = global;
			for (var i:int = 0; i < props.length; ++i) this[props[i]] = value;
			var b:Point = global;
			this.x -= b.x -a.x;
			this.y -= b.y -a.y;
			dispatchChange();
		}
		
		/**
		 * EVENT MANAGEMENT
		 */
		public function dispatchChange(evt:Event = null):void { if (hasEventListener(Event.CHANGE) && dispatch) dispatchEvent( evt?evt:new Event(Event.CHANGE,false,true) ); }
	}
}