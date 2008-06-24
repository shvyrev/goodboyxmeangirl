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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function LinkManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on r馗up鑽e les variables pass馥s en param鑼res
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}