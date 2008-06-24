/**
* 
* GoogleAnalytics events
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.analytics.php {

	// __________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// __________________________________________________________________________________________ CONSTRUCTEUR
	
	public dynamic class GoogleAnalyticsEvent extends Event{
			
		// _______________________________________________________________________________ VARIABLES STATIQUES
		static public const ONBEGIN                         :String = "onBegin";
		static public const ONPROGRESS                      :String = "onProgress";
		static public const ONCOMPLETE                      :String = "onComplete";
		static public const ONIOERROR                       :String = "onIoError";
		
		
		// ���������������������������������������������������������������������������������������������������
		// 																						  CONSTRUCTEUR
		// ���������������������������������������������������������������������������������������������������
		public function GoogleAnalyticsEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on r�cup�re les variables pass�es en param�tres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}