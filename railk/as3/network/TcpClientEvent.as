/**
* 
* Tcp Client event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.network {

	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// ________________________________________________________________________________________________ CLASS
	
	public dynamic class TcpClientEvent extends Event{
			
		// ______________________________________________________________________________ VARIABLES STATIQUES
		static public const ONCONNECTED                     :String = "onConnected";
		static public const ONDATARECEIVED                  :String = "onDataReceived";

		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function TcpClientEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}