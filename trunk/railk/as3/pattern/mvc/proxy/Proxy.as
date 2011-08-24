/**
* 
* Abstract Proxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.proxy
{
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notifier;
	
	public class Proxy extends Notifier implements IProxy,INotifier 
	{
		protected var _name:String = 'undefined';
		protected var firstData:Data;
		protected var lastData:Data;
		
		public function Proxy(MID:String, name:String = '') {
			this.MID = MID;
			if(name) _name = name;
		}
		
		public function getData( name:String, options:*=null ):void {
			var walker:Data = firstData, found:Boolean;
			while (walker) {
				if (walker.name == name) { sendData(name, walker.info, walker.data); found = true; break; }
				walker = walker.next;
			}
			if(!found) request(name,options);
		}
		
		public function sendData(name:String,info:String,data:*):void { sendNotification(name, info, data); }
		
		/**
		 * TO OVERRIDE TO REQUEST DATA
		 * 
		 * @param	name
		 */
		protected function request( name:String,options:* ):void {
		}
		
		protected function addData(name:String, data:*, info:String=""):void {
			var d:Data = new Data(name, data, info);
			if (!firstData) firstData = lastData = d;
			else {
				lastData.next = d;
				d.prev = lastData;
				lastData = d;
			}
		}
		
		public function removeData( name:String ):void {
			var walker:Data = firstData, d:Data;
			while (walker) {
				if (walker.name == name){ d= walker;  break; }
				walker = walker.next;
			}
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