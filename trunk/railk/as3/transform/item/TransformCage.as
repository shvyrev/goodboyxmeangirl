/**
 * transformCage for transform item
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.transform.item
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	import railk.as3.display.VSprite;
	import railk.as3.geom.CoordinateSystem;
	import railk.as3.geom.Point2D;
	import railk.as3.geom.Bounds;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.transform.utils.GraphicUtils;
	import railk.as3.transform.matrix.TransformMatrix;
	
	public class TransformCage extends VSprite
	{
		public var TL:Point;
		public var T:Point;
		public var TR:Point;
		public var R:Point;
		public var BR:Point;
		public var B:Point;
		public var BL:Point;
		public var L:Point;
		public var CENTER:Point;
		public var bounds:Bounds;
		
		public var stage:Stage;
		private var target:*;
		private var transformCage:TransformCage;
		private var handles:ObjectList;
		private var systems:ObjectList;
		private var transform:TransformMatrix;
		private var transformAction:TransformItemAction;
		private var entryPoint:Point;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function TransformCage( name:String, parent:*, target:* )
		{
			//--Vsprite init
			transformCage = this;
			super(parent);
			this.name = name;
			this.stage = parent.stage;
			this.target = target;
			
			//--bounds and points
			bounds = new Bounds(target.x, target.y, target.width, target.height);
			TL = bounds.top_left;
			TR = bounds.top_right;
			BL = bounds.bottom_left;
			BR = bounds.bottom_right;
			T = bounds.top;
			L = bounds.left;
			B = bounds.bottom;
			R = bounds.right;
			CENTER = bounds.center;
			
			//--handles systems and place
			systems = this.createSystems( new ObjectList() ); 
			handles = this.createHandles( new ObjectList() );
			
			//--transformAction
			transform = new TransformMatrix( target );
			transformAction = new TransformItemAction( parent.stage );
			
			//--Handdles
			this.add( GraphicUtils.rotate(CENTER.x, CENTER.y, width*.25,width*.25-30),'ROTATE' );
			this.add( GraphicUtils.skewBorder(TL.x, TL.y, bounds.width, 15,'TOP' ),'SKEW_UP' );
			this.add( GraphicUtils.skewBorder(TL.x, TL.y, 15, bounds.height,'LEFT'), 'SKEW_LEFT');
			this.add( GraphicUtils.skewBorder(BL.x, BL.y,bounds.width,15,'BOTTOM' ), 'SKEW_DOWN' );
			this.add( GraphicUtils.skewBorder(TR.x,TR.y,15,bounds.height,'RIGHT' ), 'SKEW_RIGHT' );
			this.add( GraphicUtils.corner(0x000000,TL.x, TL.y,0),'TL' );
			this.add( GraphicUtils.corner(0x000000,BL.x, BL.y,-90), 'BL' );
			this.add( GraphicUtils.corner(0x000000,TR.x, TR.y,90), 'TR' );
			this.add( GraphicUtils.corner(0x000000,BR.x, BR.y,180), 'BR' );
			this.add( GraphicUtils.regPoint(CENTER.x, CENTER.y), 'CENTER' );
			this.add( GraphicUtils.border(T.x, T.y,90), 'T' );
			this.add( GraphicUtils.border(L.x, L.y,0), 'L' );
			this.add( GraphicUtils.border(R.x, R.y,180), 'R' );
			this.add( GraphicUtils.border(B.x, B.y,-90), 'B' );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					ADDCHILD+LISTENER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function add( object:*, name:String ):void
		{
			object.name = this.name + '_' + name;
			this.addChild( object );
			enableHandleActions( object, name )
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					COORDINATE SYSTEMS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createSystems( list:ObjectList ):ObjectList
		{
			list.add( ['TL',new CoordinateSystem( BR, BL,TR )] );
			list.add( ['BR',new CoordinateSystem( TL,TR,BL )] );
			list.add( ['TR',new CoordinateSystem( BL,BR,TL )] );
			list.add( ['BL',new CoordinateSystem( TR,TL,BR )] );
			list.add( ['T',new CoordinateSystem( BL,B,TL )] );
			list.add( ['R',new CoordinateSystem( TL,TR,L )] );
			list.add( ['B',new CoordinateSystem( TL,T,BL )] );
			list.add( ['L',new CoordinateSystem( TR,TL,R )] );
			list.add( ['T_invert',new CoordinateSystem(	B,BL,CENTER )] );
			list.add( ['R_invert',new CoordinateSystem(	L,CENTER,TL )] );	
			list.add( ['B_invert',new CoordinateSystem(	T,TL,CENTER )] );
			list.add( ['L_invert',new CoordinateSystem( R,CENTER,TR	)] );
			return list;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   BOUNDS POINT WITH THEIR SYSTEMS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createHandles( list:ObjectList ):ObjectList
		{
			list.add( ['TL',new Point2D(TL.x,TL.y,'TL',systems.getObjectByName('TL').data )] );
			list.add( ['BR',new Point2D(BR.x,BR.y,'BR',systems.getObjectByName('BR').data )] );
			list.add( ['TR',new Point2D(TR.x,TR.y,'TR',systems.getObjectByName('TR').data )] );
			list.add( ['BL',new Point2D(BL.x,BL.y,'BL',systems.getObjectByName('BL').data )] );
			list.add( ['T',new Point2D(T.x,T.y,'T',systems.getObjectByName('T').data,systems.getObjectByName('T_invert').data )] );
			list.add( ['R',new Point2D(R.x,R.y,'R',systems.getObjectByName('R').data,systems.getObjectByName('R_invert').data )] );
			list.add( ['B',new Point2D(B.x,B.y,'B',systems.getObjectByName('B').data,systems.getObjectByName('B_invert').data )] );
			list.add( ['L',new Point2D(L.x,L.y,'L',systems.getObjectByName('L').data,systems.getObjectByName('L_invert').data )] );
			list.add( ['CENTER',new Point2D(CENTER.x, CENTER.y, 'CENTER')] );
			return list;
		}
		
		
		private function enableHandleActions( handle:*, type:String ):void
		{
			var move:Function, down:Function;
			switch( type )
			{
				case 'CENTER' :
					move = function() { moveRegPoint( handle ); };
					down = function() { entryPoint = new Point(handle.x2, handle.y2); };
					break;
				
				case 'ROTATE' :
					move = function() { rotate(); };
					down = function() { entryPoint = new Point(stage.mouseX, stage.mouseY); };
					break;
					
				case 'SKEW_UP' :
				case 'SKEW_LEFT' :
				case 'SKEW_DOWN' :
				case 'SKEW_RIGHT' :
					move = function() { skew( type ); };
					down = function() { entryPoint = new Point(stage.mouseX, stage.mouseY); };
					break;
					
				default :
					move = function() { scale(handle, type); };
					down = function() { entryPoint = new Point(handle.x2, handle.y2); };
					transformAction.enable( type, handle, 'mouse', null, null , function() { transformCage[type].x = handle.x2; transformCage[type].y = handle.y2; transform.apply(); updateSystem(); }, down, move);
					break;	
			}
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			 SCALE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function scale( handle:*, constraint:String='' ):void
		{
			var dist:Number;
			var p:Point2D = handles.getObjectByName( handle.name ).data;
			var inv:Point;
			var yM:Point;
			var xM:Point;
			switch( constraint )
			{
				case 'T' :
				case 'B' :
					p.x = stage.mouseX;
					p.y = stage.mouseY;
					
					yM = p.yProjection;
					inv = p.yInvertProjection;
					handle.x2 = inv.x;
					handle.y2 = inv.y;
					
					dist = getDistance(new Point(this[constraint].x, this[constraint].y), new Point(inv.x, inv.y), 'y');
					transform.scaleY( dist, yM.x, yM.y, constraint);
					break;
					
				case 'L' :
				case 'R' :
					p.x = stage.mouseX;
					p.y = stage.mouseY;
					
					yM = p.yProjection;
					xM = p.xProjection;
					inv = p.xInvertProjection;
					handle.x2 = inv.x;
					handle.y2 = inv.y;
					
					transform.scaleX( -getDistance(new Point(this[constraint].x,this[constraint].y),new Point(inv.x,inv.y),'x'),xM.x,xM.y, constraint);
					break;
				
				case 'TL' :
				case 'BL' :
				case 'TR' :
				case 'BR' :
					handle.x2  = p.x = stage.mouseX;
					handle.y2 = p.y = stage.mouseY;
					
					yM = p.yProjection;
					xM = p.xProjection;
					target.scaleY = getDistance(new Point(p.system.origin.x,p.system.origin.y),new Point(yM.x,yM.y),'y')/150;
					target.scaleX = getDistance(new Point(p.system.origin.x,p.system.origin.y),new Point(xM.x,xM.y),'x')/200;
					target.x = yM.x;
					target.y = yM.y;
					
					//transform.scaleXY( target.x2 - entryPoint.x, target.y2-entryPoint.y, constraint);
					break;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			  SKEW
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function skew( constraint:String='' ):void
		{
			switch(constraint)
			{
				case 'SKEW_UP' :
					transform.skewX( -(stage.mouseX - entryPoint.x),0, constraint);
					break;
					
				case 'SKEW_DOWN' :
					transform.skewX( (stage.mouseX - entryPoint.x),0, constraint);
					break;
					
				case 'SKEW_LEFT' :
					transform.skewY( 0,-(stage.mouseY - entryPoint.y), constraint);
					break;
				
				case 'SKEW_RIGHT' :
					transform.skewY( 0,(stage.mouseY - entryPoint.y), constraint);
					break;
			}
			
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 			ROTATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function rotate():void
		{
			//var dist:Number = Math.sqrt( (stage.mouseX - entryPoint.x) * (stage.mouseX - entryPoint.x) + (stage.mouseY - entryPoint.y) * (stage.mouseY - entryPoint.y));
			//transform.rotate(this.getRegistration().x, this.getRegistration().y, dist);
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   		 	MOVE REG POINT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function moveRegPoint( item:*, x:Number=NaN, y:Number=NaN ):void
		{
			/*var rotate:* = toolList.getObjectByName( 'ROTATE').data;
			rotate.x = item.x2 = (x)? x : mouseX; 
			rotate.y = item.y2 = (y)? y : mouseY;
			changeRegistration(mouseX, mouseY);
			CENTER.x = this.getRegistration().x;
			CENTER.y = this.getRegistration().y;*/
		}
		
		private function getDistance(A:Point,B:Point,type:String):Number
		{
			var dx:Number = B.x-A.x; 
			var dy:Number = B.y-A.y;
			var dist:Number = Math.sqrt( dx*dx + dy*dy );
			if (type =='y') dist = (dy > 0)?-dist:dist;
			else dist = (dx < 0)? -dist:dist;
			return dist;
		}
		
		private function updateSystem():void
		{
			systems = this.createSystems( new ObjectList() );
			handles = this.createHandles( new ObjectList() );
		}
	}
	
}