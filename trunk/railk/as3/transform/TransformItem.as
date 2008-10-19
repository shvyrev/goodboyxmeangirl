/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
*/

package railk.as3.transform {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField
	
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.transform.utils.GraphicUtils;
	
	public class TransformItem extends RegistrationPoint
	{
		private var TL:Point;
		private var BL:Point;
		private var L:Point;
		private var TR:Point;
		private var BR:Point;
		private var R:Point;
		private var B:Point;
		private var T:Point;
		private var CENTER:Point;
		
		private var type:String;
		private var object:*;
		
		private var hasChildren:Boolean = false;
		private var bounds:Rectangle;
		
		
		public function TransformItem( name:String, object:* )
		{
			this.name = name;
			this.object = object;
			this.type = getType();
			this.bounds = getBound();
			if ( this.object.numChildren > 0 ) hasChildren = true;
			enableRegPoints();
		}
		
		public function changeRegistration(x:Number, y:Number):void
		{
			super.setRegistration( x, y );
		}
		
		private function enableRegPoints():void
		{
			CENTER = new Point(bounds.left + bounds.right) * .5, (bounds.top + bounds.bottom) * .5);
			TL = bounds.topLeft;
			BL = new Point(bounds.left, bounds.bottom );
			L = new Point(bounds.left, (bounds.top + bounds.bottom)*.5)
			TR = new Point(bounds.right, bounds.top);
			BR = bounds.bottomRight;
			R = new Point(bounds.right, (bounds.top + bounds.bottom) * .5 );
			B = new Point(bounds.left + bounds.right) * .5, bounds.bottom);
			T = new Point(bounds.left + bounds.right) * .5, bounds.top);
		}
		
		public function enableEditMode():void
		{
			var contour:Shape = new Shape();
			contour.graphics.lineStyle( 1, 0x00CCFF, 1 );
			contour.graphics.moveTo(TL.x-1, TL.y-1);
			contour.graphics.lineTo(TR.x+1, TR.y+1);
			contour.graphics.lineTo(TR.x+1, TR.y+1);
			contour.graphics.lineTo(TR.x + 1, TR.y + 1);
			contour.graphics.lineTo(TR.x + 1, TR.y + 1);
			this.addChild( contour )
		}
		
		public function disableEditMode():void
		{
			
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
				case '' :
					break;
			}
		}
	}
	
}