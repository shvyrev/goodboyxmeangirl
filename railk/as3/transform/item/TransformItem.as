/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform.item {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.transform.TransformManagerEvent;
	import railk.as3.transform.utils.*;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.InfoBulle;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.LinkedObject;
	
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
		private var editFlag:Sprite;
		private var contour:Sprite;
		private var statesList:ObjectList;
		private var shapes:ObjectList;
		private var walker:ObjectNode;
		private var hasChildren:Boolean = false;
		private var transformObject:MatrixUtils;
		private var transformAction:TransformItemAction;
		private var entryPoint:Point;
		
		private var eEvent:TransformManagerEvent;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function TransformItem( name:String, object:* )
		{
			statesList = new ObjectList();
			shapes = new ObjectList();
			transformAction = new TransformItemAction();
			transformObject = new MatrixUtils( object );
			entryPoint = new Point();
			
			this.name = name;
			this.object = object;
			this.type = getType();
			if ( this.object.numChildren > 0 ) this.hasChildren = true;
			
			getRegPoints();
			createEditFlag();
			createShapes();
			initListeners();
			this.changeRegistration( CENTER.x, CENTER.y);
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			ENABLE THE TRANSFORM TOOLS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createEditFlag():void
		{
			contour = GraphicUtils.contour(TL.x, TL.y, WIDTH, HEIGHT );
			addChild( contour );
			
			editFlag = GraphicUtils.bg(TL.x, TL.y, WIDTH, HEIGHT );
			editFlag.alpha = 0;
			addChild( editFlag );
		}
		
		
		private function createShapes():void
		{
			shapes.add( ['tlPoint', GraphicUtils.corner(0xFF000000,TL.x, TL.y,0)] );
			shapes.add( ['blPoint', GraphicUtils.corner(0xFF000000,BL.x, BL.y,-90)] );
			shapes.add( ['trPoint', GraphicUtils.corner(0xFF000000,TR.x, TR.y,90)] );
			shapes.add( ['brPoint', GraphicUtils.corner(0xFF000000,BR.x, BR.y,180)] );
			shapes.add( ['centerPoint', GraphicUtils.regPoint(CENTER.x, CENTER.y)] );
			shapes.add( ['tPoint', GraphicUtils.border(T.x, T.y,90)] );
			shapes.add( ['lPoint', GraphicUtils.border(L.x, L.y,0)] );
			shapes.add( ['rPoint', GraphicUtils.border(R.x, R.y,180)] );
			shapes.add( ['bPoint', GraphicUtils.border(B.x, B.y, -90)] );			
			
			walker = shapes.head;
			while ( walker ) {
				addChild( walker.data );
				walker.data.name = walker.name;
				var hover:GraphicShape = GraphicUtils.hover();
				hover.name = walker.name;
				hover.x2 = walker.data.x2;
				hover.y2 = walker.data.y2;
				addChild( hover );
				var lk:LinkedObject = new LinkedObject(hover, walker.data);
				enableActions( walker.name, lk );
				walker.data.visible = true;
				walker = walker.next;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			ENABLE THE TRANSFORM TOOLS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		private function enableActions( name:String, item:* ):void
		{
			switch( name )
			{
				case 'tlPoint' :
					//transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); },null, null, null, function() { scale(item,'UP'); } );
					break;
				case 'blPoint' :
					//transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); },null, null, null, function() { scale(item,'UP'); } );
					break;
				case 'trPoint' :
					//transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); },null, null, null, function() { scale(item,'UP'); } );
					break;
				case 'brPoint' :
					//transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); },null, null, null, function() { scale(item,'UP'); } );
					break;
				case 'centerPoint' :
					//transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); },null, null, null, function() { scale(item,'UP'); } );
					break;
				case 'tPoint' :
					transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); }, function() { transformObject.apply(); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { scale(item, 'UP'); } );
					break;
				case 'lPoint' :
					transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); }, function() { transformObject.apply(); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { scale(item,'LEFT'); } );
					break;
				case 'rPoint' :
					transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); }, function() { transformObject.apply(); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { scale(item,'RIGHT'); } );
					break;
				case 'bPoint' :
					transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); }, function() { transformObject.apply(); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { scale(item, 'DOWN'); } );
					break;
			}
		}
		
		private function scale( item:*, constraint:String='' ):void
		{
			switch( constraint )
			{
				case 'UP' :
				case 'DOWN' :
					item.y2 = mouseY;
					transformObject.scaleY( item.y2 - entryPoint.y, constraint);
					break;
					
				case 'LEFT' :
				case 'RIGHT' :
					item.x2 = mouseX;
					transformObject.scaleX( item.x2 - entryPoint.x, constraint);
					break;
			}
		}
		
		private function skew( item:*, constraint:String='' ):void
		{
			
		}
		
		private function rotate( item:* ):void
		{
			
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  MANAGE LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							 UTILITIES
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function getBound():Rectangle
		{
			return object.getBounds(object.parent);
		}
		
		
		private function getType():String
		{
			if ( object is TextField ) return 'text';
			return 'object';
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void
		{
			
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  MANAGE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case MouseEvent.ROLL_OVER :
					editFlag.alpha = .5;
					break;
					
				case MouseEvent.ROLL_OUT :
					editFlag.alpha = 0;
					//disableEditMode();
					break;
					
				case MouseEvent.CLICK :
					enableEditMode();
					//////////////////////////////////////////////////////////////
					eEvent = new TransformManagerEvent( TransformManagerEvent.ON_ITEM_SELECTED, { item:this } );
					dispatchEvent( eEvent );
					//////////////////////////////////////////////////////////////
					break;
				
				case MouseEvent.DOUBLE_CLICK :
					//////////////////////////////////////////////////////////////
					eEvent = new TransformManagerEvent( TransformManagerEvent.ON_ITEM_OPEN, { item:this } );
					dispatchEvent( eEvent );
					//////////////////////////////////////////////////////////////
					break;
				
				case MouseEvent.MOUSE_UP :
					stopDrag();
					transformObject.update();
					this.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					statesList.add([statesList.length, new TransformItemState(object)] );
					//////////////////////////////////////////////////////////////
					eEvent = new TransformManagerEvent( TransformManagerEvent.ON_ITEM_MOVING, { item:this } );
					dispatchEvent( eEvent );
					//////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.MOUSE_DOWN :
					this.startDrag();
					this.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					//////////////////////////////////////////////////////////////
					eEvent = new TransformManagerEvent( TransformManagerEvent.ON_ITEM_STOP_MOVING, { item:this } );
					dispatchEvent( eEvent );
					//////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.MOUSE_MOVE :
					object.x = this.x;
					object.y = this.y;
					evt.updateAfterEvent()
					break;		
			}
		}
	}
	
}