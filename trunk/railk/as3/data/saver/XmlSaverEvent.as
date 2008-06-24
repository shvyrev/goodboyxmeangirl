/**
* 
* XmlSaver event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.saver {

	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _______________________________________________________________________________________ CLASS
	
	public dynamic class XmlSaverEvent extends Event{
			
		// ___________________________________________________________________________________ VARIABLES STATIQUES
		static public const ONCHECKBEGIN                     :String = "onCheckBegin";
		static public const ONCHECKCOMLETE                   :String = "onCheckComplete";
		static public const ONCHECKIOERROR                   :String = "onCheckIoError";
		
		static public const ONLOADBEGIN                      :String = "onLoadBegin";
		static public const ONLOADPROGRESS                   :String = "onLoadProgress";
		static public const ONLOADCOMPLETE                   :String = "onLoadComplete";
		
		static public const ONUPDATE                         :String = "onUpdate";
		static public const ONCREATE                         :String = "onCreate";

		static public const ONSAVEBEGIN                      :String = "onSaveBegin";
		static public const ONSAVECOMLETE                    :String = "onSaveComplete";
		static public const ONSAVEIOERROR                    :String = "onSaveIoError";
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function XmlSaverEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}