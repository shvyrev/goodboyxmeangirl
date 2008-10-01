/**
* 
* Accordion event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.accordion {

	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// ________________________________________________________________________________________________ CLASS
	
	public dynamic class AccordionEvent extends Event{
			
		// ______________________________________________________________________________ VARIABLES STATIQUES
		static public const ON_WIDTH_CHANGE                :String = "onWidthChange";
		static public const ON_HEIGHT_CHANGE               :String = "onHeightChange";
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AccordionEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}