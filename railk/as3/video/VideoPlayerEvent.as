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
	public class VideoPlayerEvent extends Event
	{
		static public const VIDEO_PROGRESS:String = "onProgress";
		static public const VIDEO_START_BUFFERING:String = "onStartBuffer";
		static public const VIDEO_STOP_BUFFERING:String = "onStopBuffer";
		
		public var percent:Number;
		public function VideoPlayerEvent(type:String, percent:Number, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.percent = percent;
		}
	}	
}