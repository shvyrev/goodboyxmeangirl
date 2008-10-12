﻿/**
* 
* Custom event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.event {

	import flash.events.Event;
	public dynamic class CustomEvent extends Event{
			
		public function CustomEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) {
				this[name] = data[name];
			}	
		}
		
	}
}