/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
*/

package railk.as3.transform {
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	import railk.as3.event.CustomEvent;
	
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.InfoBulle;
	import railk.as3.transform.utils.*;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class TransformItem extends RegistrationPoint
	{
		public var X:Number;
		public var Y:Number;
		
		private var TL:Point;
		private var BL:Point;
		private var L:Point;
		private var TR:Point;
		private var BR:Point;
		private var R:Point;
		private var B:Point;
		private var T:Point;
		private var CENTER:Point;
		private var WIDTH:Number;
		private var HEIGHT:Number;
		
		private var type:String;
		private var object:*;
		private var editFlag:Shape;
		private var cursors:ObjectList;
		private var shapes:ObjectList;
		private var walker:ObjectNode;
		private var hasChildren:Boolean = false;
		private var states:TransformItemState;
		
		
		public function TransformItem( name:String, object:* )
		{
			this.name = name;
			this.object = object;
			this.type = getType();
			if ( this.object.numChildren > 0 ) hasChildren = true;
			getRegPoints();
			this.changeRegistration( CENTER.x, CENTER.y);
			createEditFlag();
			
			cursors = new ObjectList();
			shapes = new ObjectList();
			createCursors();
			createShapes();
			initListeners();
		}
		
		private function createEditFlag():void
		{
			editFlag = GraphicUtils.bg(TL.x, TL.y, WIDTH, HEIGHT );
			editFlag.alpha = 0;
			addChild( editFlag );
		}
		
		private function createCursors():void
		{
			//cursors.add( ['rotate', GraphicUtils.rotateCursor()] );
			//cursors.add( ['move', GraphicUtils.moveCursor()] );
			//cursors.add( ['scale', GraphicUtils.scaleCursor()] );
			
			walker = cursors.head;
			while ( walker ) {
				addChild( walker.data );
				walker.data.visible = false;
				walker = walker.next;
			}
		}
		
		private function createShapes():void
		{
			shapes.add( ['contour', GraphicUtils.contour(TL.x,TL.y,WIDTH,HEIGHT )] );
			//shapes.add( ['tlPoint', GraphicUtils.regPoint(TL.x, TL.y)] );
			//shapes.add( ['blPoint', GraphicUtils.regPoint(BL.x, BL.y)] );
			//shapes.add( ['trPoint', GraphicUtils.regPoint(TR.x, TR.y)] );
			//shapes.add( ['brPoint', GraphicUtils.regPoint(BR.x, BR.y)] );
			//shapes.add( ['centerPoint', GraphicUtils.regPoint(CENTER.x, CENTER.y)] );
			//shapes.add( ['tPoint', GraphicUtils.regPoint(T.x, T.y)] );
			//shapes.add( ['lPoint', GraphicUtils.regPoint(L.x, L.y)] );
			//shapes.add( ['rPoint', GraphicUtils.regPoint(R.x, R.y)] );
			//shapes.add( ['bPoint', GraphicUtils.regPoint(B.x, B.y)] );
			
			walker = shapes.head;
			while ( walker ) {
				addChild( walker.data );
				walker.data.visible = false;
				walker = walker.next;
			}
		}
		
		public function changeRegistration(x:Number, y:Number):void
		{
			super.setRegistration( x, y );
		}
		
		private function getRegPoints():void
		{
			X = object.x;
			Y = object.y;
			WIDTH = object.width;
			HEIGHT = object.height;
			CENTER = new Point( WIDTH * .5,  HEIGHT * .5);
			TL = new Point(0, 0);
			BL = new Point(0, HEIGHT );
			L = new Point(0,  HEIGHT*.5)
			TR = new Point(WIDTH, 0);
			BR = new Point(WIDTH, HEIGHT);
			R = new Point(WIDTH, HEIGHT*.5 );
			B = new Point( WIDTH*.5, HEIGHT);
			T = new Point( WIDTH*.5, 0);
		}
		
		public function enableEditMode():void
		{
			walker = shapes.head;
			while ( walker ) {
				walker.data.visible = true;
				walker = walker.next;
			}
		}
		
		public function disableEditMode():void
		{
			walker = shapes.head;
			while ( walker ) {
				walker.data.visible = false;
				walker = walker.next;
			}
		}
		
		public function initListeners():void
		{
			this.buttonMode = true;
			this.doubleClickEnabled = true;
			this.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.DOUBLE_CLICK, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
		}
		
		public function delListeners():void
		{
			this.buttonMode = false;
			this.doubleClickEnabled = false;
			this.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			this.removeEventListener( MouseEvent.CLICK, manageEvent );
			this.removeEventListener( MouseEvent.DOUBLE_CLICK, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
		}
		
		
		private function getBound():Rectangle
		{
			return object.getBounds(object.parent);
		}
		
		
		private function getType():String
		{
			if ( object is TextField ) return 'text';
			return 'object';
		}
		
		
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case MouseEvent.ROLL_OVER :
					editFlag.alpha = .5;
					break;
					
				case MouseEvent.ROLL_OUT :
					editFlag.alpha = 0;
					disableEditMode();
					break;
					
				case MouseEvent.CLICK :
					enableEditMode();
					break;
				
				case MouseEvent.DOUBLE_CLICK :
					dispatchEvent( new CustomEvent( 'onTransformItemOpen', { item:this } ) );
					break;
				
				case MouseEvent.MOUSE_UP :
					stopDrag();
					this.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					break;
					
				case MouseEvent.MOUSE_DOWN :
					this.startDrag();
					this.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					break;
					
				case MouseEvent.MOUSE_MOVE :
					object.x = this.x;
					object.y = this.y;
					break;		
			}
		}
	}
	
}