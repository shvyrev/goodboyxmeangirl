/**
* 
* Accordion event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.accordion {

	import flash.events.Event;
	public dynamic class AccordionEvent extends Event{
			
		static public const ON_WIDTH_CHANGE                :String = "onWidthChange";
		static public const ON_HEIGHT_CHANGE               :String = "onHeightChange";
		
		public function AccordionEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}