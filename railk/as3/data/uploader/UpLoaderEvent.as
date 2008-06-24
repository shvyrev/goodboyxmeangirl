/**
* 
* Uploader event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.uploader {

	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _______________________________________________________________________________________ CONSTRUCTEUR
	
	public dynamic class UpLoaderEvent extends Event{
			
		// ___________________________________________________________________________________ VARIABLES STATIQUES
		static public const ONCANCEL                        :String = "onCancel";
		static public const ONSELECT                        :String = "onSelect";
		static public const ONBEGIN                         :String = "onBegin";
		static public const ONPROGRESS                      :String = "onProgress";
		static public const ONCOMPLETE                      :String = "onComplete";
		static public const ONHTTPSTATUS                    :String = "onHttpStatus";
		static public const ONDATAUPLOADED                  :String = "onDataUploaded";
		static public const ONIOERROR                       :String = "onIoError";
		static public const ONSECURITYERROR                 :String = "onSecurityError";
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function UpLoaderEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}