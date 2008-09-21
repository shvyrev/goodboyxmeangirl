/**
* 
* Abstract Model
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.model 
{
	import flash.events.Event;		
	import flash.events.EventDispatcher;
		
	public class AbstractModel extends EventDispatcher
	{
		public var data:*;
		public var info:String;
		
		public function AbstractModel()
		{
			data = null;
			info = '';
		}
		
		public function updateView():void
		{
			dispatchEvent( new ModelEvent( ModelEvent.ON_UPDATE, {info:info, data:data} ) );
		}
		
		public function clearData():void {
			data = null;
		}
		
	}
}