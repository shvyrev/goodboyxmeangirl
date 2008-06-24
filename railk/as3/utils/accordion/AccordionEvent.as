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
		static public const ONITEM_OVER                 :String = "onItemOver";
		static public const ONITEM_OUT                  :String = "onItemOut";
		static public const ONITEM_ClICK                :String = "onItemClick";
		static public const ONSTARTDRAGITEM             :String = "onStartDragItem";
		static public const ONSTOPDRAGITEM              :String = "onStopDragItem";
		
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