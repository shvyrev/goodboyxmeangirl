﻿/**
* 
* Amfphp Client event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.amfphp 
{
	import flash.events.Event;	
	public dynamic class AmfphpClientEvent extends Event{
			
		static public const ON_CONNEXION_ERROR              :String = "onConnexionError";
		static public const ON_RESULT                       :String = "onResult";
		static public const ON_ERROR                        :String = "onError";
		
		
		public function AmfphpClientEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}