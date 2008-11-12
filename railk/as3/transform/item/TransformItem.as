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
		private var linkedObjectList:ObjectList;
		private var walker:ObjectNode;
		private var hasChildren:Boolean = false;
		private var transformObject:MatrixUtils;
		private var transformFlag:MatrixUtils;
		private var transformAction:TransformItemAction;
		private var entryPoint:Point;
		
		private var eEvent:TransformManagerEvent;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function TransformItem( name:String, object:* )
		{	
			statesList = new ObjectList();
			shapes = new ObjectList();
			linkedObjectList = new ObjectList();
			this.name = name;
			this.object = object;
			this.type = getType();
			if ( this.object.numChildren > 0 ) this.hasChildren = true;
			
			transformAction = new TransformItemAction();
			transformObject = new MatrixUtils( object );
			entryPoint = new Point();
			
			getRegPoints();
			createEditFlag();
			createShapes();
			initListeners();
			this.changeRegistration( CENTER.x, CENTER.y);
			
			
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																			ENABLE THE TRANSFORM TOOLS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function createEditFlag():void
		{
			contour = GraphicUtils.contour(TL.x, TL.y, WIDTH, HEIGHT );
			addChild( contour );
			
			editFlag = GraphicUtils.bg(TL.x, TL.y, WIDTH, HEIGHT );
			editFlag.alpha = 0;
			addChild( editFlag );
			transformFlag = new MatrixUtils( editFlag );
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
				linkedObjectList.add([walker.name,lk])
				enableActions( walker.name, lk );
				walker.data.visible = false;
				walker = walker.next;
			}
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																			ENABLE THE TRANSFORM TOOLS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
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
			var move:Function;
			switch( name )
			{
				case 'tlPoint' :
					move = function() { scale(item, 'LEFT_UP'); replace( transformObject.bounds, name ); };
					break;
				case 'blPoint' :
					move = function() { scale(item, 'LEFT_DOWN'); replace( transformObject.bounds, name ); };
					break;
				case 'trPoint' :
					move = function() { scale(item, 'RIGHT_UP'); replace( transformObject.bounds, name ); };
					break;
				case 'brPoint' :
					move = function() { scale(item, 'RIGHT_DOWN'); replace( transformObject.bounds, name ); };
					break;
				case 'centerPoint' :
					move = function() { item.x2 = mouseX; item.y2 = mouseY; changeRegistration(mouseX, mouseY) };
					break;
				case 'tPoint' :
					move = function() { scale(item, 'UP'); replace( transformObject.bounds, name ); };
					break;
				case 'lPoint' :
					move =  function() { scale(item, 'LEFT'); replace( transformObject.bounds, name ); };
					break;
				case 'rPoint' :
					move = function() { scale(item,'RIGHT'); replace( transformObject.bounds, name ); };
					break;
				case 'bPoint' :
					move = function() { scale(item, 'DOWN'); replace( transformObject.bounds, name ); };
					break;
			}
			transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); }, function() { transformObject.apply(); transformFlag.apply(); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { entryPoint = new Point(item.x2, item.y2); }, move );

		}
		
		private function scale( item:*, constraint:String='' ):void
		{
			switch( constraint )
			{
				case 'UP' :
				case 'DOWN' :
					item.y2 = mouseY;
					transformObject.scaleY( item.y2 - entryPoint.y, constraint);
					transformFlag.scaleY( item.y2 - entryPoint.y, constraint);
					break;
					
				case 'LEFT' :
				case 'RIGHT' :
					item.x2 = mouseX;
					transformObject.scaleX( item.x2 - entryPoint.x, constraint);
					transformFlag.scaleX( item.x2 - entryPoint.x, constraint);
					break;
				
				case 'LEFT_UP' :
				case 'LEFT_DOWN' :
				case 'RIGHT_UP' :
				case 'RIGHT_DOWN' :
					item.x2 = mouseX;
					item.y2 = mouseY;
					transformObject.scaleXY( item.x2 - entryPoint.x, item.y2-entryPoint.y, constraint);
					transformFlag.scaleXY( item.x2 - entryPoint.x, item.y2 - entryPoint.y, constraint);
					break;
			}
		}
		
		private function skew( item:*, constraint:String='' ):void
		{
			
		}
		
		private function rotate( item:* ):void
		{
			
		}
		
		private function replace( bounds:Rectangle, except:String ):void
		{
			walker = linkedObjectList.head;
			while ( walker )
			{
				if (walker.name != except ) 
				{
					switch(walker.name )
					{
						case 'tlPoint' :
							walker.data.x2 = bounds.x;
							walker.data.y2 = bounds.y;
							break;
						case 'blPoint' :
							walker.data.x2 = bounds.x;
							walker.data.y2 = bounds.height + bounds.y;
							break;
						case 'trPoint' :
							walker.data.x2 = bounds.width + bounds.x;
							walker.data.y2 = bounds.y;
							break;
						case 'brPoint' :
							walker.data.x2 = bounds.width + bounds.x;
							walker.data.y2 = bounds.height + bounds.y;
							break;
						case 'centerPoint' :
							//trace( this.reg );
							break;
						case 'tPoint' :
							walker.data.x2 = bounds.width*.5 + bounds.x;
							walker.data.y2 = bounds.y;
							break;
						case 'lPoint' :
							walker.data.x2 = bounds.x;
							walker.data.y2 = bounds.height*.5 + bounds.y;
							break;
						case 'rPoint' :
							walker.data.x2 = bounds.width + bounds.x;
							walker.data.y2 = bounds.height*.5 + bounds.y;
							break;
						case 'bPoint' :	
							walker.data.x2 = bounds.width*.5  + bounds.x;
							walker.data.y2 = bounds.height + bounds.y;
							break;
					}
				}	
				walker = walker.next;
			}
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					  MANAGE LISTENERS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																							 UTILITIES
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function getBound():Rectangle
		{
			return object.getBounds(object.parent);
		}
		
		
		private function getType():String
		{
			if ( object is TextField ) return 'text';
			return 'object';
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																							   DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function dispose():void
		{
			
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case MouseEvent.ROLL_OVER :
					editFlag.alpha = .5;
					enableEditMode();
					break;
					
				case MouseEvent.ROLL_OUT :
					editFlag.alpha = 0;
					disableEditMode();
					break;
					
				case MouseEvent.CLICK :
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
					object.x = this.localToGlobal( new Point(editFlag.x,editFlag.y) ).x;
					object.y = this.localToGlobal( new Point(editFlag.x,editFlag.y) ).y;
					evt.updateAfterEvent()
					break;		
			}
		}
	}
	
}