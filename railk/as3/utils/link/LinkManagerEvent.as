/**
* 
* LinkManager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.link {

	// __________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _________________________________________________________________________________________________ CLASS
	
	public dynamic class LinkManagerEvent extends Event{
			
		// _______________________________________________________________________________ VARIABLES STATIQUES
		static public const ONCHANGESTATE                    :String = "onChangeState";
		static public const ONERRORSTATE                     :String = "onErrorState";
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function LinkManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}