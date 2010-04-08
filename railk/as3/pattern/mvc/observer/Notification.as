/**
* 
* Notification
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.observer
{
	import flash.events.Event;
	dynamic public class Notification extends Event 
	{	
		static public const NOTE:String = 'note';
		
		public var note:String;
		public var info:String;
		
		public function Notification(note:String, info:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super('note', bubbles, cancelable);
			this.note = note;
			this.info = info;
			for(var name:String in data) this[name] = data[name];
		}
	}
}	