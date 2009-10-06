/**
 * DATABASE
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.air.data 
{
	import flash.events.Event;
	public class SQLEvents extends Event
	{
		static public const ON_CONNECTION_ERROR:String = "onConnectionError";
		static public const ON_NO_RESULT:String = "onNoResult";
		static public const ON_RESULT:String = "onResult";
		public var result:*
		
		public function SQLEvents(type:String, result:*=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.result = result;
		}
	}
}