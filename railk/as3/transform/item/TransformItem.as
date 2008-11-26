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
	import flash.display.Stage;
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
		
		private var transformItem:TransformItem;
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
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function TransformItem( stage:Stage, name:String, object:* )
		{	
			statesList = new ObjectList();
			shapes = new ObjectList();
			linkedObjectList = new ObjectList();
			
			transformItem = this;
			
			this.name = name;
			this.object = object;
			this.type = getType();
			if ( this.object.numChildren > 0 ) this.hasChildren = true;
			
			transformAction = new TransformItemAction(stage);
			transformObject = new MatrixUtils( object );
			entryPoint = new Point();
			
			getToolsPoints();
			createEditFlag();
			createShapes();
			this.changeRegistration( CENTER.x, CENTER.y);
			transformAction.enable( name,
									transformItem,
									'roll',
									function() { editFlag.alpha = .5; enableEditMode(); },
									function() { editFlag.alpha = 0; /*disableEditMode();*/ },
									function() 
									{  
										transformItem.stopDrag();
										transformObject.update();
										statesList.add([statesList.length, new TransformItemState(object)] );
										//////////////////////////////////////////////////////////////
										dispatchEvent( new TransformManagerEvent( TransformManagerEvent.ON_ITEM_MOVING, { item:transformItem } ) );
										//////////////////////////////////////////////////////////////
									},
									function() 
									{ 
										transformItem.startDrag();
										//////////////////////////////////////////////////////////////
										dispatchEvent( new TransformManagerEvent( TransformManagerEvent.ON_ITEM_STOP_MOVING, { item:transformItem } ) );
										//////////////////////////////////////////////////////////////
									},
									function()
									{
										X = object.x = transformItem.localToGlobal( new Point(editFlag.x,editFlag.y) ).x;
										Y = object.y = transformItem.localToGlobal( new Point(editFlag.x,editFlag.y) ).y;
									},
									function()
									{
										//////////////////////////////////////////////////////////////
										dispatchEvent( new TransformManagerEvent( TransformManagerEvent.ON_ITEM_SELECTED, { item:transformItem } ) );
										//////////////////////////////////////////////////////////////
									},
									function()
									{
										//////////////////////////////////////////////////////////////
										dispatchEvent( new TransformManagerEvent( TransformManagerEvent.ON_ITEM_OPEN, { item:transformItem } ) );
										//////////////////////////////////////////////////////////////
									} );
									
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
			shapes.add( ['rotate', GraphicUtils.rotate(CENTER.x, CENTER.y, WIDTH*.25,WIDTH*.25-30)] );
			
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
				if ( walker.name != 'rotate') enableToolsActions( walker.name, lk );
				walker.data.visible = true;
				walker = walker.next;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			ENABLE THE TRANSFORM TOOLS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   TRANSFORM TOOLS ACTIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function enableToolsActions( name:String, item:* ):void
		{
			var move:Function, down:Function, skewState:String;
			switch( name )
			{
				case 'tlPoint' :
					move = function() { scale(item, 'LEFT_UP'); replace( transformObject.bounds, 'LEFT_UP' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'blPoint' :
					move = function() { scale(item, 'LEFT_DOWN'); replace( transformObject.bounds, 'LEFT_DOWN' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'trPoint' :
					move = function() { scale(item, 'RIGHT_UP'); replace( transformObject.bounds, 'RIGHT_UP' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'brPoint' :
					move = function() { scale(item, 'RIGHT_DOWN'); replace( transformObject.bounds, 'RIGHT_DOWN' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'centerPoint' :
					move = function() { moveRegPoint(item); trace('move'); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'tPoint' :
					move = function() { scale(item, 'UP'); replace( transformObject.bounds, 'UP' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'lPoint' :
					move =  function() { scale(item, 'LEFT'); replace( transformObject.bounds, 'LEFT' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'rPoint' :
					move = function() { scale(item, 'RIGHT'); replace( transformObject.bounds, 'RIGHT' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'bPoint' :
					move = function() { scale(item, 'DOWN'); replace( transformObject.bounds, 'DOWN' ); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				case 'tBorder' :
					move = function() { skew(item, 'UP');  replace( transformObject.bounds, 'SKEW_UP' ); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
					skewState = 'UP';
					break;
				case 'lBorder' :
					move = function() { skew(item, 'LEFT');  replace( transformObject.bounds, 'SKEW_LEFT' ); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
					skewState = 'LEFT';
					break;
				case 'rBorder' :
					move = function() { skew(item, 'RIGHT');  replace( transformObject.bounds, 'SKEW_RIGHT' ); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
					skewState = 'RIGHT';
					break;
				case 'bBorder' :
					move = function() { skew(item, 'DOWN');  replace( transformObject.bounds, 'SKEW_DOWN' ); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
					skewState = 'DOWN';
					break;
				case 'rotate' :
					move = function() { rotate(item); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
			}
			transformAction.enable( name, item, 'mouse', null, null , function() { HEIGHT = transformObject.bounds.height; WIDTH = transformObject.bounds.width; transformObject.apply(); transformFlag.apply(); }, down, move);

		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			 SCALE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
					item.x2 = mouseX
					item.y2 = mouseY
					transformObject.scaleXY( item.x2 - entryPoint.x, item.y2-entryPoint.y, constraint);
					transformFlag.scaleXY( item.x2 - entryPoint.x, item.y2 - entryPoint.y, constraint);
					break;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			  SKEW
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function skew( item:*, constraint:String='' ):void
		{
			var subConstraint:String = '';
			var assieteX:Number = transformObject.assieteX;
			var assieteY:Number = transformObject.assieteY;
			switch(constraint)
			{
				case 'UP' :
					if (assieteX > 0) subConstraint = 'LEFT';
					else subConstraint = 'RIGHT';
					transformObject.skewX( -(mouseX - entryPoint.x), constraint, subConstraint );
					transformFlag.skewX( -(mouseX - entryPoint.x), constraint, subConstraint );
					break;
					
				case 'DOWN' :
					if (assieteX < 0) subConstraint = 'LEFT';
					else if (assieteX > 0) subConstraint = 'RIGHT';
					transformObject.skewX( (mouseX - entryPoint.x), constraint, subConstraint );
					transformFlag.skewX( (mouseX - entryPoint.x), constraint, subConstraint );
					break;
					
				case 'LEFT' :
					if (assieteY > 0) subConstraint = 'UP';
					else subConstraint = 'DOWN';
					transformObject.skewY( -(mouseY - entryPoint.y), constraint, subConstraint );
					transformFlag.skewY( -(mouseY - entryPoint.y), constraint, subConstraint );
					break;
				
				case 'RIGHT' :
					if (assieteY < 0) subConstraint = 'UP';
					else subConstraint = 'DOWN';
					transformObject.skewY( (mouseY - entryPoint.y), constraint, subConstraint );
					transformFlag.skewY( (mouseY - entryPoint.y), constraint, subConstraint );
					break;
			}
			
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			ROTATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function rotate( item:*):void
		{
			transformObject.rotate( CENTER.x, CENTER.y, (360 * (mouseY - entryPoint.y)) / 360 );
			transformFlag.rotate( CENTER.x, CENTER.y, (360 * (mouseY - entryPoint.y)) / 360 );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 	MOVE REG POINT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function moveRegPoint( item:*, x:Number=NaN, y:Number=NaN ):void
		{
			var rotate:* = linkedObjectList.getObjectByName( 'rotate').data;
			rotate.x = item.x2 = (x)? x : mouseX; 
			rotate.y = item.y2 = (y)? y : mouseY;
			changeRegistration(mouseX, mouseY);
			CENTER.x = this.getRegistration().x;
			CENTER.y = this.getRegistration().y;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   			 REPLACE TOOLS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function replace( bounds:Rectangle, constraint:String ):void
		{
			var assieteX:Number = transformObject.assieteX;
			var assieteY:Number = transformObject.assieteY;
			var tl:* = linkedObjectList.getObjectByName( 'tlPoint').data;
			var t:* = linkedObjectList.getObjectByName( 'tPoint').data;
			var tr:* = linkedObjectList.getObjectByName( 'trPoint').data;
			var r:* = linkedObjectList.getObjectByName( 'rPoint').data;
			var br:* = linkedObjectList.getObjectByName( 'brPoint').data;
			var b:* = linkedObjectList.getObjectByName( 'bPoint').data;
			var bl:* = linkedObjectList.getObjectByName( 'blPoint').data;
			var l:* = linkedObjectList.getObjectByName( 'lPoint').data;
			var skT:* = linkedObjectList.getObjectByName( 'tBorder').data;
			var skL:* = linkedObjectList.getObjectByName( 'lBorder').data;
			var skR:* = linkedObjectList.getObjectByName( 'rBorder').data;
			var skB:* = linkedObjectList.getObjectByName( 'bBorder').data;
			var center:* = linkedObjectList.getObjectByName( 'centerPoint').data;
			var rotate:* = linkedObjectList.getObjectByName( 'rotate').data;
			
			rotate.x = center.x2 = this.globalToLocal(transformObject.matrix.transformPoint(CENTER)).x
			rotate.y = center.y2 = this.globalToLocal(transformObject.matrix.transformPoint(CENTER)).y;
			this.changeRegistration(center.x2, center.y2);
			
			tl.y2 = this.globalToLocal(transformObject.matrix.transformPoint(TL)).y;
			tl.x2 = this.globalToLocal(transformObject.matrix.transformPoint(TL)).x;
			t.y2 = this.globalToLocal(transformObject.matrix.transformPoint(T)).y;
			t.x2 = this.globalToLocal(transformObject.matrix.transformPoint(T)).x;
			tr.y2 = this.globalToLocal(transformObject.matrix.transformPoint(TR)).y;
			tr.x2 = this.globalToLocal(transformObject.matrix.transformPoint(TR)).x;
			r.y2 = this.globalToLocal(transformObject.matrix.transformPoint(R)).y;
			r.x2 = this.globalToLocal(transformObject.matrix.transformPoint(R)).x;
			br.y2 = this.globalToLocal(transformObject.matrix.transformPoint(BR)).y;
			br.x2 = this.globalToLocal(transformObject.matrix.transformPoint(BR)).x;
			bl.y2 = this.globalToLocal(transformObject.matrix.transformPoint(BL)).y;
			bl.x2 = this.globalToLocal(transformObject.matrix.transformPoint(BL)).x;
			b.y2 = this.globalToLocal(transformObject.matrix.transformPoint(B)).y;
			b.x2 = this.globalToLocal(transformObject.matrix.transformPoint(B)).x;
			l.y2 = this.globalToLocal(transformObject.matrix.transformPoint(L)).y;
			l.x2 = this.globalToLocal(transformObject.matrix.transformPoint(L)).x;
			
			skB.width = skT.width = bounds.width;
			skL.height = skR.height = bounds.height;
			
			skL.x2 = skT.x2 = this.globalToLocal(transformObject.matrix.transformPoint(TL)).x;//bounds.x;
			skB.x2 = this.globalToLocal(transformObject.matrix.transformPoint(BL)).x;
			skR.x2 = this.globalToLocal(transformObject.matrix.transformPoint(TR)).x;//bounds.x + bounds.width;
			skR.y2 = skL.y2 = skT.y2 = this.globalToLocal(transformObject.matrix.transformPoint(TL)).y;//bounds.y;
			skB.y2 = this.globalToLocal(transformObject.matrix.transformPoint(BL)).y;//bounds.y + bounds.height;
			
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							 UTILITIES
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function getType():String
		{
			if ( object is TextField ) return 'text';
			return 'object';
		}
		
		public function changeRegistration(x:Number, y:Number):void
		{
			this.setRegistration( x, y );
		}
		
		private function getToolsPoints():void
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
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void
		{
			walker = statesList.head;
			while( walker )
			{
				walker.data = null;
				walker.args = null;
				walker.action = null;
				walker = walker.next;
			}
			statesList.clear();
			
			walker = shapes.head;
			while( walker )
			{
				walker.data = null;
				walker.args = null;
				walker.action = null;
				walker = walker.next;
			}
			shapes.clear();
			
			editFlag = null;
			transformItem = null;
		}
		
	}
}