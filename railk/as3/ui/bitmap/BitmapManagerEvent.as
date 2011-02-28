/**
* BitmapManagerEvent
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.bitmap 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import railk.as3.display.UIBitmap;
	
	public class BitmapManagerEvent extends Event
	{
		public static const PROGRESS:String = 'bmpm_progress';
		public static const FILE:String = 'bmpm_file';
		public static const COMPLETE:String = 'bmpm_complete';
		
		public var percents:Dictionary
		public var percent:int;
		public var name:String;
		public var bitmap:UIBitmap;
		
		public function BitmapManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new BitmapManagerEvent(type, bubbles, cancelable);
		}
	}
}