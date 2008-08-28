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
	
	public dynamic class FileSaverEvent extends Event{
			
		// ___________________________________________________________________________________ VARIABLES STATIQUES
		static public const ONCHECKBEGIN                     :String = "onCheckBegin";
		static public const ONCHECKCOMLETE                   :String = "onCheckComplete";
		static public const ONCHECKIOERROR                   :String = "onCheckIoError";

		static public const ONSAVEBEGIN                      :String = "onSaveBegin";
		static public const ONSAVECOMLETE                    :String = "onSaveComplete";
		static public const ONSAVEIOERROR                    :String = "onSaveIoError";
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function FileSaverEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}