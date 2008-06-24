/**
* 
* MultiLoaderEvent
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.loader {

	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _______________________________________________________________________________________ CLASS
	
	public dynamic class MultiLoaderEvent extends Event{
			
		// ___________________________________________________________________________________ VARIABLES STATIQUES
		static public const ONMULTILOADERBEGIN              :String = "onMultiLoaderBegin";
		static public const ONMULTILOADERPROGRESS           :String = "onMultiLoaderProgress";
		static public const ONMULTILOADERCOMPLETE           :String = "onMultiLoaderComplete";
		static public const ONMULTILOADERSTOPPED            :String = "onMultiLoaderStopped";
		static public const ONMULTILOADERLOADNEXT           :String = "onMultiLoaderLoadNext";
		
		static public const ONITEMBEGIN                     :String = "onItemBegin";
		static public const ONITEMPROGRESS                  :String = "onItemProgress";
		static public const ONITEMCOMPLETE                  :String = "onItemComplete";
		static public const ONITEMIOERROR                   :String = "onItemIOerror";
		static public const ONITEMHTTPSTATUS                :String = "onItemHttpStatus";
		static public const ONITEMNETSTATUS                 :String = "onItemNetStatus";
		
		static public const ONSTREAMREADY                   :String = "onStreamReady";
		static public const ONSTREAMBUFFERING               :String = "onStreamBuffering";
		static public const ONSTREAMPLAYED                  :String = "onStreamPlayed";
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function MultiLoaderEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on récupère les variables passées en paramètres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}