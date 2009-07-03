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
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notifier;
	
	public class AbstractProxy extends Notifier implements IProxy,INotifier 
	{
		static public const NAME:String = 'proxy';
		protected var firstData:Data;
		protected var lastData:Data;
		
		public function AbstractProxy() {}
		
		public function getData( name:String ):Data {
			var walker:Data = firstData;
			while (walker) {
				if (walker.name == name)  return walker;
				walker = walker.next;
			}
			return null;
		}
		
		protected function addData(name:String, data:*):void {
			var d:Data = new Data(name, data);
			if (!firstData) firstData = lastData = d;
			else {
				lastData.next = d;
				d.prev = lastData;
				lastData = d;
			}
		}
		
		public function removeData( name:String ):void {
			var d:Data = getData(name);
			if (d.next) d.next.prev = d.prev;
			if (d.prev) d.prev.next = d.next;
			else if (firstData == t) firstData = d.next;
		}
		
		public function clearData():void {
			var walker:Data = firstData;
			firstData = null;
			while (walker) {
				walker.data = null;
				walker = walker.next;
			}
			lastData = null;
		}
	}
}