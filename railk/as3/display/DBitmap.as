/**
 * DBitmap
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class DBitmap extends Bitmap
	{
		public function DBitmap(bmd:BitmapData=null, pixelSnapping:String='auto',smoothing:Boolean=false) {
			super(bmd, pixelSnapping, smoothing);
		}
		
		/**
		 * OVERRIDE
		 */
		override public function set x(value:Number):void { super.x = value; dispatchChange(); }
		override public function set y(value:Number):void { super.y = value; dispatchChange(); }
		override public function set width(value:Number):void { super.width = value; dispatchChange(); }
		override public function set height(value:Number):void { super.height = value; dispatchChange(); }
		
		/**
		 * EVENT DISPATCH
		 */
		private function dispatchChange():void {
			if(hasEventListener(Event.CHANGE)) dispatchEvent( new Event(Event.CHANGE) );
		}
	}
}