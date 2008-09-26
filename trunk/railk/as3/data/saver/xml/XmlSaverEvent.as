/**
* 
* XmlSaver event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.saver.xml {

	import flash.events.Event;

	public dynamic class XmlSaverEvent extends Event{
			
		static public const ON_CHECK_COMLETE                  	:String = "onCheckComplete";
		static public const ON_LOAD_COMPLETE                   	:String = "onLoadComplete";
		static public const ON_SAVE_COMLETE                    	:String = "onSaveComplete";
		static public const ON_ERROR                    		:String = "onError";
		
		
		public function XmlSaverEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}