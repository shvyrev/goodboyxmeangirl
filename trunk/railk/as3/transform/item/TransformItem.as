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
	import flash.geom.Transform;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.DSprite;
	import railk.as3.display.GraphicShape;
	import railk.as3.transform.TransformManagerEvent;
	import railk.as3.transform.utils.*;
	import railk.as3.transform.matrix.*;
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
		private var object:*;
		private var editFlag:Sprite;
		private var contour:Sprite;
		private var tools:DSprite;
		private var childList:ObjectList;
		private var statesList:ObjectList;
		private var shapes:ObjectList;
		private var toolList:ObjectList;
		private var walker:ObjectNode;
		private var transformTools:TransformMatrix;
		private var transformObject:TransformMatrix;
		private var transformFlag:TransformMatrix;
		private var transformAction:TransformItemAction;
		private var entryPoint:Point;
		private var _hasChildren:Boolean = false;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function TransformItem( stage:Stage, name:String, object:*, childList:ObjectList=null )
		{	
			statesList = new ObjectList();
			shapes = new ObjectList();
			toolList = new ObjectList();
			tools = new DSprite();
			
			transformItem = this;
			this.name = name;
			this.object = object;
			this.childList = childList;
			if ( childList != null ) _hasChildren = true;
			
			transformAction = new TransformItemAction(stage);
			transformObject = new TransformMatrix( object );
			transformTools = new TransformMatrix( tools );
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
									});
									
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
			transformFlag = new TransformMatrix( editFlag );
			transformAction.enable( 'editflag', editFlag, 'mouse', null, null, null, null, null, null, 
									function() {
										//manageChildren();
										//////////////////////////////////////////////////////////////
										dispatchEvent( new TransformManagerEvent( TransformManagerEvent.ON_ITEM_OPEN, { item:transformItem } ) );
										//////////////////////////////////////////////////////////////
									});
		}
		
		
		private function createShapes():void
		{
			shapes.add( ['ROTATE', GraphicUtils.rotate(CENTER.x, CENTER.y, WIDTH*.25,WIDTH*.25-30), 'bigtool'] );
			shapes.add( ['SKEW_UP', GraphicUtils.skewBorder(TL.x, TL.y, WIDTH, 15,'TOP' ), 'bigtool'] );
			shapes.add( ['SKEW_LEFT', GraphicUtils.skewBorder(TL.x, TL.y, 15, HEIGHT,'LEFT'), 'bigtool'] );
			shapes.add( ['SKEW_DOWN', GraphicUtils.skewBorder(TL.x, HEIGHT,WIDTH,15,'BOTTOM' ), 'bigtool'] );
			shapes.add( ['SKEW_RIGHT', GraphicUtils.skewBorder(WIDTH,TL.y,15,HEIGHT,'RIGHT' ), 'bigtool'] );
			shapes.add( ['LEFT_UP', GraphicUtils.corner(0x000000,TL.x, TL.y,0)] );
			shapes.add( ['LEFT_DOWN', GraphicUtils.corner(0x000000,BL.x, BL.y,-90)] );
			shapes.add( ['RIGHT_UP', GraphicUtils.corner(0x000000,TR.x, TR.y,90)] );
			shapes.add( ['RIGHT_DOWN', GraphicUtils.corner(0x000000,BR.x, BR.y,180)] );
			shapes.add( ['CENTER', GraphicUtils.regPoint(CENTER.x, CENTER.y)] );
			shapes.add( ['UP', GraphicUtils.border(T.x, T.y,90)] );
			shapes.add( ['LEFT', GraphicUtils.border(L.x, L.y,0)] );
			shapes.add( ['RIGHT', GraphicUtils.border(R.x, R.y,180)] );
			shapes.add( ['DOWN', GraphicUtils.border(B.x, B.y, -90)] );
			
			walker = shapes.head;
			while ( walker ) {
				walker.data.name = walker.name;
				if ( walker.group == 'bigtool') 
				{
					toolList.add([walker.name,walker.data])
					enableToolsActions( walker.name, walker.data );
					tools.addChild( walker.data );
				}
				else
				{
					var hover:GraphicShape = GraphicUtils.hover();
					hover.name = walker.name;
					hover.x2 = walker.data.x2;
					hover.y2 = walker.data.y2;
					var lk:LinkedObject = new LinkedObject(walker.data, hover );
					toolList.add([walker.name,lk])
					enableToolsActions( walker.name, lk );
					tools.addChild( walker.data );
					tools.addChild( hover );
				}	
				walker.data.visible = true;
				walker = walker.next;
			}
			addChild(tools);	
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
			var move:Function, down:Function;
			switch( name )
			{
				case 'CENTER' :
					move = function() { moveRegPoint(item); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;
				
				case 'ROTATE' :
					move = function() { rotate(item); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
					break;
					
				case 'SKEW_UP' :
				case 'SKEW_LEFT' :
				case 'SKEW_DOWN' :
				case 'SKEW_RIGHT' :
					move = function() { skew(item, name);  replace(); };
					down = function() { entryPoint = new Point(mouseX, mouseY); };
					break;
					
				default :
					move = function() { scale(item, name); replace(); };
					down = function() { entryPoint = new Point(item.x2, item.y2); };
					break;	
			}
			transformAction.enable( name, item, 'mouse', null, null , function() { HEIGHT = transformObject.height; WIDTH = transformObject.width; transformObject.apply(); transformFlag.apply(); }, down, move);

		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			 SCALE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function scale( item:*, constraint:String='' ):void
		{
			item.x2 = mouseX
			item.y2 = mouseY
			switch( constraint )
			{
				case 'UP' :
				case 'DOWN' :
					transformObject.scaleY( 0,item.y2 - entryPoint.y, constraint);
					transformFlag.scaleY( 0, item.y2 - entryPoint.y, constraint);
					break;
					
				case 'LEFT' :
				case 'RIGHT' :
					transformObject.scaleX( item.x2 - entryPoint.x,0, constraint);
					transformFlag.scaleX( item.x2 - entryPoint.x,0, constraint);
					break;
				
				case 'LEFT_UP' :
				case 'LEFT_DOWN' :
				case 'RIGHT_UP' :
				case 'RIGHT_DOWN' :
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
			switch(constraint)
			{
				case 'SKEW_UP' :
					transformObject.skewX( -(mouseX - entryPoint.x),0, constraint);
					transformFlag.skewX( -(mouseX - entryPoint.x),0, constraint);
					break;
					
				case 'SKEW_DOWN' :
					transformObject.skewX( (mouseX - entryPoint.x),0, constraint);
					transformFlag.skewX( (mouseX - entryPoint.x),0, constraint);
					break;
					
				case 'SKEW_LEFT' :
					transformObject.skewY( 0,-(mouseY - entryPoint.y), constraint);
					transformFlag.skewY( 0,-(mouseY - entryPoint.y), constraint);
					break;
				
				case 'SKEW_RIGHT' :
					transformObject.skewY( 0,(mouseY - entryPoint.y), constraint);
					transformFlag.skewY( 0,(mouseY - entryPoint.y), constraint);
					break;
			}
			
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			ROTATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function rotate( item:*):void
		{
			var dist:Number = Math.sqrt( (mouseX - entryPoint.x) * (mouseX - entryPoint.x) + (mouseY - entryPoint.y) * (mouseY - entryPoint.y));
			//this.rotation2 = dist;
			transformObject.rotate(this.getRegistration().x, this.getRegistration().y, dist);
			transformFlag.rotate(this.getRegistration().x, this.getRegistration().y, dist);
			//transformTools.rotate(this.getRegistration().x, this.getRegistration().y, dist);
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 	MOVE REG POINT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function moveRegPoint( item:*, x:Number=NaN, y:Number=NaN ):void
		{
			var rotate:* = toolList.getObjectByName( 'ROTATE').data;
			rotate.x = item.x2 = (x)? x : mouseX; 
			rotate.y = item.y2 = (y)? y : mouseY;
			changeRegistration(mouseX, mouseY);
			CENTER.x = this.getRegistration().x;
			CENTER.y = this.getRegistration().y;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   			 REPLACE TOOLS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function replace():void
		{
			var tl:* = toolList.getObjectByName( 'LEFT_UP').data;
			var t:* = toolList.getObjectByName( 'UP').data;
			var tr:* = toolList.getObjectByName( 'RIGHT_UP').data;
			var r:* = toolList.getObjectByName( 'RIGHT').data;
			var br:* = toolList.getObjectByName( 'RIGHT_DOWN').data;
			var b:* = toolList.getObjectByName( 'DOWN').data;
			var bl:* = toolList.getObjectByName( 'LEFT_DOWN').data;
			var l:* = toolList.getObjectByName( 'LEFT').data;
			var skT:* = toolList.getObjectByName( 'SKEW_UP').data;
			var skL:* = toolList.getObjectByName( 'SKEW_LEFT').data;
			var skR:* = toolList.getObjectByName( 'SKEW_RIGHT').data;
			var skB:* = toolList.getObjectByName( 'SKEW_DOWN').data;
			var center:* = toolList.getObjectByName( 'CENTER').data;
			var rotate:* = toolList.getObjectByName( 'ROTATE').data;
			
			//regPoint/rorate
			rotate.x = center.x2 = this.globalToLocal(transformObject.matrix.transformPoint(CENTER)).x
			rotate.y = center.y2 = this.globalToLocal(transformObject.matrix.transformPoint(CENTER)).y;
			this.changeRegistration(center.x2, center.y2);
			
			//scale tool
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
			
			//skew tools
			drawSkewBorders( skT, new Point(tl.x2, tl.y2 + 15), new Point(tr.x2, tr.y2 + 15), new Point(tr.x2, tr.y2), new Point(tl.x2, tl.y2) );
			drawSkewBorders( skL, new Point(tl.x2-15,tl.y2),new Point(bl.x2-15,bl.y2),new Point(bl.x2,bl.y2),new Point(tl.x2,tl.y2) );
			drawSkewBorders( skB, new Point(tl.x2, tl.y2 + 15), new Point(tr.x2, tr.y2 + 15), new Point(tr.x2, tr.y2), new Point(tl.x2, tl.y2));
			drawSkewBorders( skR, new Point(tr.x2-15,tr.y2),new Point(br.x2-15,br.y2),new Point(br.x2,br.y2),new Point(tr.x2,tr.y2));
			
			skL.x2 = skT.x2 = this.globalToLocal(transformObject.matrix.transformPoint(TL)).x;
			skB.x2 = this.globalToLocal(transformObject.matrix.transformPoint(BL)).x;
			skR.x2 = this.globalToLocal(transformObject.matrix.transformPoint(TR)).x;
			skR.y2 = this.globalToLocal(transformObject.matrix.transformPoint(TR)).y;
			skL.y2 = skT.y2 = this.globalToLocal(transformObject.matrix.transformPoint(TL)).y;
			skB.y2 = this.globalToLocal(transformObject.matrix.transformPoint(BL)).y;	
			
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   MANAGE CHILDREN
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageChildren():void
		{
			walker = childList.head;
			while (walker)
			{
				(walker.data as TransformItem).enableChildren();
				walker = walker.next;
			}
		}
		
		private function enableChildren():void
		{
			trace( 'open');
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							 UTILITIES
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		private function drawSkewBorders(who:GraphicShape, A:Point, B:Point, C:Point, D:Point ):void
		{
			var dx:Number = B.x - A.x;
			var dy:Number = A.y - D.y;
			var dw:Number = D.x - A.x;
			var dh:Number = B.y - A.y;
			
			who.graphics.clear();
			who.graphics.beginFill(0xFF0000);
			who.graphics.moveTo(0, 0)
			who.graphics.lineTo(dx, dh)
			who.graphics.lineTo(dx+dw, dh+dy)
			who.graphics.lineTo(0+dw, dy)
			who.graphics.lineTo(0, 0)
			who.graphics.endFill();
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
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get hasChildren():Boolean { return _hasChildren; }
		
	}
}