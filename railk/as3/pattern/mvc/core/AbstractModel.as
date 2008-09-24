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
		public var requester:String;
		
		public function AbstractModel()
		{
			data = null;
			info = '';
		}
		
		public function updateView(type:String):void
		{
			dispatchEvent( new ModelEvent( type, {requester:requester, info:info, data:data} ) );
		}
		
		public function clearData():void {
			data = null;
		}
		
		public function start():void{}
		public function execute( requester:String, type:String, ...args ):void{}
		public function getData( name:String ):*{}
		public function dispose():void{}
		
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