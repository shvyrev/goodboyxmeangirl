/**
* VideoPlayer Event
* 
* @author Richard Rodney.
* @version 0.2
* 
*/

package railk.as3.video 
{	
	import flash.events.Event;
	dynamic public class VideoPlayerEvent extends Event
	{
		static public const ON_PROGRESS:String = "onProgress";
		static public const ON_COMPLETE:String = "onComplete";
		
		public function VideoPlayerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			if(data!=null )for(var name:String in data) this[name] = data[name];
		}
	}	
}