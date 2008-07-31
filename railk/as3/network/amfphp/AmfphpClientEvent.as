/**
* 
* Amfphp Client event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.network.amfphp {

	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// ________________________________________________________________________________________________ CLASS
	
	public dynamic class AmfphpClientEvent extends Event{
			
		// ______________________________________________________________________________ VARIABLES STATIQUES
		static public const ON_CONNEXION_ERROR              :String = "onConnexionError";
		static public const ON_RESULT                       :String = "onResult";
		static public const ON_ERROR                        :String = "onError";

		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AmfphpClientEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}