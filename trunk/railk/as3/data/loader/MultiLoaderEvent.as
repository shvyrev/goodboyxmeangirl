/**
* 
* MultiLoaderEvent
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.loader {

	import flash.events.Event;
	public dynamic class MultiLoaderEvent extends Event{
			
		static public const ONMULTILOADERBEGIN              :String = "onMultiLoaderBegin";
		static public const ONMULTILOADERPROGRESS           :String = "onMultiLoaderProgress";
		static public const ONMULTILOADERCOMPLETE           :String = "onMultiLoaderComplete";
		static public const ONMULTILOADERSTOPPED            :String = "onMultiLoaderStopped";
		static public const ONMULTILOADERLOADNEXT           :String = "onMultiLoaderLoadNext";
		
		static public const ONITEMBEGIN                     :String = "onItemBegin";
		static public const ONITEMPROGRESS                  :String = "onItemProgress";
		static public const ONITEMCOMPLETE                  :String = "onItemComplete";
		static public const ONITEMHTTPSTATUS                :String = "onItemHttpStatus";
		static public const ONITEMNETSTATUS                 :String = "onItemNetStatus";
		
		static public const ONSTREAMREADY                   :String = "onStreamReady";
		static public const ONSTREAMBUFFERING               :String = "onStreamBuffering";
		static public const ONSTREAMPLAYED                  :String = "onStreamPlayed";
		
		static public const ONERRORLOADINGITEM           :String = "onErrorLoadingItem"
		
		
		public function MultiLoaderEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}