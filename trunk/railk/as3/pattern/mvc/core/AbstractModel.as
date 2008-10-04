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
		private var _owner:String;
		
		public function AbstractModel()
		{
			data = null;
			info = '';
			owner = '';
		}
		
		public function updateView(info:String, type:String, extra:Object=null):void
		{
			var args:Object= {};
			var e:String;
			args.info = this.info = info;
			args.data = this.data;
			if ( extra ) for ( e in extra) { args[e] = extra[e]; }
			dispatchEvent( new ModelEvent( _owner+type, args ) );
		}
		
		public function clearData():void {
			data = null;
		}
		
		public function start():void{}
		public function execute( type:String, ...args ):void{}
		public function getData( name:String ):*{}
		public function dispose():void { }
		
		public function get owner():String {  return _owner }
		
		public function set owner(value:String):void 
		{
			_owner = value;
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