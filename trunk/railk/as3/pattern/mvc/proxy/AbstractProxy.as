/**
* 
* Abstract Proxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.proxy
{
	import flash.events.EventDispatcher;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.event.ModelEvent;
	
	public class AbstractProxy extends EventDispatcher implements IProxy 
	{
		static public const NAME:String = 'proxy';
		
		protected var firstData:Data;
		protected var lastData:Data;
		
		public function AbstractProxy() {}
		
		public function updateView(info:String, type:String, data:Object=null):void {
			var args:Object= {};
			args.info = info;
			if (data ) for ( var d:String in data) { args[d] = data[d]; }
			dispatchEvent( new ModelEvent( type, args ) );
		}
		
		public function getData( name:String ):Data {
			var walker:Data = firstData;
			while (walker) {
				if (walker.name == name)  return walker;
				walker = walker.next;
			}
			return walker;
		}
		
		public function removeData( name:String ):void {
			var d:Data = getData(name);
			if (d.next) d.next.prev = d.prev;
			if (d.prev) d.prev.next = d.next;
			else if (firstData == t) firstData = d.next;
		}
		
		public function clearData():void {
			var walker:Data = firstData;
			while (walker) {
				walker.data = null;
				walker = walker.next;
			}
			return walker;
		}
	}
}