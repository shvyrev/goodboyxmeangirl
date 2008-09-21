/**
* AbstractModel event
* @author Richard Rodney
* @version 0.1
*/
	
package railk.as3.pattern.model
{
	import flash.events.Event;
	public dynamic class ModelEvent extends Event {
		
		static public const ON_UPDATE:String = "onUpdate";

		public function ModelEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
}
	
}