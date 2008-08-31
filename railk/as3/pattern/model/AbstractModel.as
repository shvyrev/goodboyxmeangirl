/**
* 
* Abstract Model
* 
* @author Richard Rodney
*/

package railk.as3.pattern.model 
{
	
	import flash.events.Event;		
	import flash.events.EventDispatcher;
		
	public class AbstractModel extends EventDispatcher
	{
		/** Event name for all events. */
		public static const ALL_EVENTS:String = "onAllEvents";
		public static const CLEAR:String = "_destroy";
		
		/** The data. */
		private var modelData:* = null;
		
		/** The current event. */
		private var cEvent:String = "";
		
		/**
		 * Constructor.
		 * 
		 * @param data		data array of objects, or xml or whatever object.
		 */
		public function AbstractModel( data:* = null )
		{
			if( data != null ) modelData = data;
		}
		
		/**
		 * Clears the current model data.
		 */
		public function clearModel():void
		{
			modelData = null;
		}
		
		/**
		 * Updates the current application view by event and removes the previous.
		 * 
		 * @param event		event string id.
		 */
		public function updateLocation( event:String ):void
		{
			// If no events defined yet, then send out the first event.
			if( cEvent.length == 0 ) 
			{
				cEvent = event;
				dispatchEvent( new Event( event ) );
			}
			else
			{
				// Run the event to destroy the current event.
				dispatchEvent( new Event( ( cEvent + CLEAR ) ) );
				
				// Then send out the new event and make that the current event.
				dispatchEvent( new Event( event ) );
				cEvent = event;
			}
			
			// Send out an all events request.
			dispatchEvent( new Event( ALL_EVENTS ) );
		}
		
		/**
		 * Method used for just sending internal events for the application,
		 * doesn't update the current id like 'updateLocation' does.
		 * 
		 * @param event		string id.
		 */
		public function sendInternalEvent( event:String ):void
		{
			dispatchEvent( new Event( event ) );
		}
		
		public function get data():*
		{
			return modelData;
		}
		
		public function set data( data:* ):void
		{
			modelData = data;
		}
		
		public function get currentEvent():String
		{
			return cEvent;
		}
	}
}