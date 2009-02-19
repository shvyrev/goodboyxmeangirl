/**
* 
* Model Event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.event
{
	import flash.events.Event;
	dynamic class ModelEvent extends Event {
		
		public function ModelEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}	