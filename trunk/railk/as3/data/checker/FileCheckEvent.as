/**
* 
* filecheck event
* 
* @author Richard rodney
*/


package railk.as3.data.checker {

	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	
	public dynamic class FileCheckEvent extends Event{
			
		// _______________________________________________________________________________VARIABLES STATIQUES
		static public const ONFILECHECKRESPONSE                  :String = "onFileCheckResponse";
		static public const ONFILECHECKERROR                     :String = "onFileCheckError";
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function  FileCheckEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}