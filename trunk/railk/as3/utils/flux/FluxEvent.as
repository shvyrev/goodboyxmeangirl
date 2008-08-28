/**
* 
* Rss event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.flux {

	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// ________________________________________________________________________________________________ CLASS
	
	public dynamic class FluxEvent extends Event{
			
		// ______________________________________________________________________________ VARIABLES STATIQUES
		static public const ONFLUXPUBLISHERROR                 :String = "onFluxPublishError";
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function FluxEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}