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
		protected var _name:String = 'undefined';
		protected var firstData:Data;
		protected var lastData:Data;
		
		public function AbstractProxy(name:String = '') {
			if(name) _name = name;
		}
		
		public function getData( name:String ):* {
			var walker:Data = firstData;
			while (walker) {
				if (walker.name == name)  return walker.data;
				walker = walker.next;
			}
			request(name);
			return null;
		}
		
		/**
		 * TO OVERRIDE TO REQUEST DATA
		 * 
		 * @param	name
		 */
		protected function request( name:String ):void {
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
			else if (firstData == d) firstData = d.next;
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
		
		public function dispose():void {}
		
		public function get name():String { return _name; }
	}
}