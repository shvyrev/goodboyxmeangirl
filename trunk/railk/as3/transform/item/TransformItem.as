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
	import railk.as3.display.DSprite;
	
	
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
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			ENABLE THE TRANSFORM TOOLS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createEditFlag():void
		{
			//contour = GraphicUtils.contour(TL.x, TL.y, WIDTH, HEIGHT );
			//addChild( contour );
			
			editFlag = GraphicUtils.bg(TL.x, TL.y, WIDTH, HEIGHT );
			editFlag.alpha = 0;
			addChild( editFlag );
			transformFlag = new MatrixUtils( editFlag );
		}
		
		
		private function createShapes():void
		{
			shapes.add( ['tBorder', GraphicUtils.skewBorder(TL.x, TL.y, WIDTH, 15,'TOP' )] );
			shapes.add( ['lBorder', GraphicUtils.skewBorder(TL.x, TL.y, 15, HEIGHT,'LEFT')] );
			shapes.add( ['bBorder', GraphicUtils.skewBorder(TL.x, HEIGHT,WIDTH,15,'BOTTOM' )] );
			shapes.add( ['rBorder', GraphicUtils.skewBorder(WIDTH,TL.y,15,HEIGHT,'RIGHT' )] );
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
			if(object is DSprite) CENTER = new Point( WIDTH * .5,  HEIGHT * .5);
			else CENTER = new Point( WIDTH * .5,  HEIGHT * .5);
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
					move = function() { scale(item, 'LEFT_UP'); replace( transformObject.bounds, 'LEFT_UP' ); };
					break;
				case 'blPoint' :
					move = function() { scale(item, 'LEFT_DOWN'); replace( transformObject.bounds, 'LEFT_DOWN' ); };
					break;
				case 'trPoint' :
					move = function() { scale(item, 'RIGHT_UP'); replace( transformObject.bounds, 'RIGHT_UP' ); };
					break;
				case 'brPoint' :
					move = function() { scale(item, 'RIGHT_DOWN'); replace( transformObject.bounds, 'RIGHT_DOWN' ); };
					break;
				case 'centerPoint' :
					move = function() { moveRegPoint(item) };
					break;
				case 'tPoint' :
					move = function() { scale(item, 'UP'); replace( transformObject.bounds, 'UP' ); };
					break;
				case 'lPoint' :
					move =  function() { scale(item, 'LEFT'); replace( transformObject.bounds, 'LEFT' ); };
					break;
				case 'rPoint' :
					move = function() { scale(item,'RIGHT'); replace( transformObject.bounds,'RIGHT' ); };
					break;
				case 'bPoint' :
					move = function() { scale(item, 'DOWN'); replace( transformObject.bounds, 'DOWN' ); };
					break;
				case 'tBorder' :
					move = function() { skew(item, 'UP');  replace( transformObject.bounds, 'UP' ); };
					break;
				case 'lBorder' :
					move = function() { skew(item, 'LEFT');  replace( transformObject.bounds, 'UP' ); };
					break;
				case 'rBorder' :
					move = function() { skew(item, 'RIGHT');  replace( transformObject.bounds, 'UP' ); };
					break;
				case 'bBorder' :
					move = function() { skew(item, 'DOWN');  replace( transformObject.bounds, 'UP' ); };
					break;
			}
			transformAction.enable( name, item, function() { delListeners(); }, function() { initListeners(); }, function() { changeRegistration(CENTER.x, CENTER.y); HEIGHT = transformObject.bounds.height; WIDTH = transformObject.bounds.width; transformObject.apply(); transformFlag.apply(); }, function() { entryPoint = new Point(item.x2, item.y2); }, function() { entryPoint = new Point(item.x2, item.y2); }, move );

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
					item.x2 = mouseX
					transformObject.scaleX( item.x2 - entryPoint.x, constraint);
					transformFlag.scaleX( item.x2 - entryPoint.x, constraint);
					break;
				
				case 'LEFT_UP' :
				case 'LEFT_DOWN' :
				case 'RIGHT_UP' :
				case 'RIGHT_DOWN' :
					item.x2 = mouseX
					item.y2 = mouseY
					transformObject.scaleXY( item.x2 - entryPoint.x, item.y2-entryPoint.y, constraint);
					transformFlag.scaleXY( item.x2 - entryPoint.x, item.y2 - entryPoint.y, constraint);
					break;
			}
		}
		
		private function skew( item:*, constraint:String='' ):void
		{
			switch(constraint)
			{
				case 'UP' :
					transformObject.skewX( -(mouseX - entryPoint.x), constraint );
					break;
					
				case 'DOWN' :
					break;
					
				case 'LEFT' :
					break;
				
				case 'RIGHT' :
					break;
			}
			
		}
		
		private function rotate( item:*, angle ):void
		{
			
		}
		
		private function moveRegPoint( item:*, x:Number=NaN, y:Number=NaN ):void
		{
			item.x2 = (x)? x : mouseX; 
			item.y2 = (y)? y : mouseY; 
			changeRegistration(mouseX, mouseY);
			CENTER.x = this.getRegistration().x;
			CENTER.y = this.getRegistration().y;
		}
		
		private function replace( bounds:Rectangle, constraint:String ):void
		{
			var tl:* = linkedObjectList.getObjectByName( 'tlPoint').data;
			var t:* = linkedObjectList.getObjectByName( 'tPoint').data;
			var tr:* = linkedObjectList.getObjectByName( 'trPoint').data;
			var r:* = linkedObjectList.getObjectByName( 'rPoint').data;
			var br:* = linkedObjectList.getObjectByName( 'brPoint').data;
			var b:* = linkedObjectList.getObjectByName( 'bPoint').data;
			var bl:* = linkedObjectList.getObjectByName( 'blPoint').data;
			var l:* = linkedObjectList.getObjectByName( 'lPoint').data;
			var center:* = linkedObjectList.getObjectByName( 'centerPoint').data;
			X = this.localToGlobal( new Point(transformObject.bounds.x, transformObject.bounds.y) ).x; 
			Y = this.localToGlobal( new Point(transformObject.bounds.x, transformObject.bounds.y) ).y;
			center.y2 = this.globalToLocal(new Point(X, Y)).y + this.getRegistration().y * (bounds.height/HEIGHT);
			center.x2 = this.globalToLocal(new Point(X, Y)).x + this.getRegistration().x * (bounds.width/WIDTH);
			CENTER.y = this.getRegistration().y * (bounds.height / HEIGHT);
			CENTER.x = this.getRegistration().x * (bounds.width / WIDTH);
			
			switch( constraint )
			{
				case 'UP' :
					tl.y2 = bounds.y;
					l.y2 = bounds.y + bounds.height * .5;
					tr.y2 = bounds.y;
					r.y2 = bounds.y + bounds.height * .5;
					break;
					
				case 'DOWN' :
					bl.y2 = bounds.y+bounds.height;
					l.y2 = bounds.y+bounds.height*.5;
					br.y2 = bounds.y+bounds.height;
					r.y2 = bounds.y + bounds.height * .5;
					break;
					
				case 'LEFT' :
					tl.x2 = bounds.x;
					t.x2 = bounds.x+bounds.width*.5;
					bl.x2 = bounds.x;
					b.x2 = bounds.x + bounds.width * .5;
					break;
					
				case 'RIGHT' :
					tr.x2 = bounds.x+bounds.width;
					t.x2 = bounds.x+bounds.width*.5;
					br.x2 = bounds.x+bounds.width;
					b.x2 = bounds.x + bounds.width * .5;
					break;
				
				case 'LEFT_UP' :
					t.x2=bounds.x+bounds.width*.5;
					t.y2=bounds.y;
					tr.y2=bounds.y;
					r.y2 = bounds.y + bounds.height * .5;
					l.x2=bounds.x;
					l.y2 = bounds.y + bounds.height * .5;
					bl.x2= bounds.x;
					b.x2=bounds.x+bounds.width*.5;
					break;
					
				case 'LEFT_DOWN' :
					l.x2=bounds.x;
					l.y2 = bounds.y+bounds.height*.5;
					tl.x2 = bounds.x;
					t.x2 = bounds.x+bounds.width*.5;
					b.x2 = bounds.x+bounds.width*.5;
					b.y2 = bounds.y+bounds.height;
					br.y2 = bounds.y+bounds.height;
					r.y2 = bounds.y + bounds.height*.5;
					break;
					
				case 'RIGHT_UP' :
					t.x2 = bounds.x+bounds.width*.5;
					t.y2 = bounds.y;
					tl.y2 = bounds.y;
					l.y2 = bounds.height*.5 + bounds.y;
					r.y2 = bounds.height * .5 + bounds.y;
					r.x2 = bounds.x+bounds.width;
					br.x2 = bounds.x+bounds.width;
					b.x2 = bounds.x+bounds.width*.5;
					break;
					
				case 'RIGHT_DOWN' :
					r.y2 = bounds.y+bounds.height*.5;
					r.x2 = bounds.x+bounds.width;
					tr.x2 = bounds.x+bounds.width;
					t.x2=bounds.x+bounds.width*.5;
					b.x2=bounds.x+bounds.width*.5;
					b.y2=bounds.y+bounds.height;
					bl.y2=bounds.y+bounds.height;
					l.y2 = bounds.y+bounds.height*.5;
					break;
			}
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
					enableEditMode();
					break;
					
				case MouseEvent.ROLL_OUT :
					editFlag.alpha = 0;
					//disableEditMode();
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
					X = object.x = this.localToGlobal( new Point(editFlag.x,editFlag.y) ).x;
					Y = object.y = this.localToGlobal( new Point(editFlag.x,editFlag.y) ).y;
					evt.updateAfterEvent()
					break;		
			}
		}
	}
	
}