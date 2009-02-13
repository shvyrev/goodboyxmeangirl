/**
* 
* Process tween engine event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.tween.process 
{
	import flash.events.Event;
	
	public dynamic class ProcessEvent extends Event{
			
		static public const ON_BEGIN                       	:String = "begin";
		static public const ON_PROGRESS_POINT               :String = "progressPoint";
		static public const ON_COMPLETE                    	:String = "complete";
		static public const ON_PAUSED                       :String = "paused";
		
		
		public function ProcessEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}