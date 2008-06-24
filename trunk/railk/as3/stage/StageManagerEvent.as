/**
* 
* StageManager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage {

	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _______________________________________________________________________________________ CLASS
	
	public dynamic class StageManagerEvent extends Event{
			
		// ___________________________________________________________________________________ VARIABLES STATIQUES
		static public const ONSTAGERESIZE                    :String = "onStageResize";
		static public const ONMOUSEACTIVE                    :String = "onMouseActive";
		static public const ONMOUSEIDLE                      :String = "onMouseIdle";
		static public const ONMOUSELEAVE                     :String = "onMouseLeave";
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function StageManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on r馗up鑽e les variables pass馥s en param鑼res
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}