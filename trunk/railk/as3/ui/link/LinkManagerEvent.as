/**
* 
* LinkManager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.link 
{
	import flash.events.Event;
	public dynamic class LinkManagerEvent extends Event{
			
		static public const ONCHANGESTATE                    :String = "onChangeState";
		static public const ONERRORSTATE                     :String = "onErrorState";
		
		public function LinkManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}