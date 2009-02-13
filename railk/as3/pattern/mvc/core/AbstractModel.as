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
	import railk.as3.data.objectList.ObjectList;
		
	public class AbstractModel extends EventDispatcher implements IModel
	{
		protected var data:ObjectList;
		
		public function AbstractModel()
		{
			data = new ObjectList();
		}
		
		public function updateView(info:String, type:String, data:Object=null):void
		{
			var args:Object= {};
			args.info = info;
			if (data ) for ( var d:String in data) { args[d] = data[d]; }
			dispatchEvent( new ModelEvent( type, args ) );
		}
		
		public function getData( name:String ):*
		{
			return data.getObjectByName( name ).data;
		}
		
		public function clearData():void {
			data.clear();
		}
		
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