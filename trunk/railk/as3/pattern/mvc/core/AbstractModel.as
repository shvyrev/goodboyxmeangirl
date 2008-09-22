/**
* 
* Abstract Model
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import flash.events.EventDispatcher;
	import railk.as3.pattern.mvc.interfaces.IModel;
		
	public class AbstractModel extends EventDispatcher implements IModel
	{
		public var data:*;
		public var info:String;
		
		public function AbstractModel()
		{
			data = null;
			info = '';
		}
		
		public function updateView(type:String):void
		{
			dispatchEvent( new ModelEvent( type, {info:info, data:data} ) );
		}
		
		public function clearData():void {
			data = null;
		}
		
		public function start():void{}
		public function getData( type:String, ...args ):*{}
		
	}
}

import flash.events.Event;
dynamic class ModelEvent extends Event {
	
	public function ModelEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) {
				this[name] = data[name];
			}	
	}
}