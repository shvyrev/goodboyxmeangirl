/**
* 
* ResizeManager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.resize {

	// __________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _________________________________________________________________________________________________ CLASS
	
	public dynamic class ResizeManagerEvent extends Event{
			
		// _______________________________________________________________________________ VARIABLES STATIQUES
		static public const ON_REMOVE_ONE                    :String = "onRemoveOne";
		static public const ON_REMOVE_ALL                    :String = "onRemoveAll";
		static public const ON_MOVE_FINISH                   :String = "onMoveFinish";
		static public const ON_ACTION_ERROR                  :String = "onActionError";
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function ResizeManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}