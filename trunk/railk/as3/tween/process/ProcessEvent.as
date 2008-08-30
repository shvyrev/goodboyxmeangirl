/**
* 
* Process tween engine event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.tween.process {
	import flash.events.Event;
	public dynamic class ProcessEvent extends Event{
			
		// ______________________________________________________________________________ VARIABLES STATIQUES
		static public const ON_INIT                         :String = "onInit";
		static public const ON_PROGRESS                     :String = "onProgress";
		static public const ON_COMPLETE                     :String = "onComplete";
	
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function ProcessEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}