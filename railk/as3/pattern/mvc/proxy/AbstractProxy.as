/**
* 
* Abstract Proxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.proxy
{
	import flash.events.EventDispatcher;
	import railk.as3.data.objectList.ObjectNode;
	import railk.as3.data.objectList.ObjectList
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.event.ModelEvent;
	
	public class AbstractProxy extends EventDispatcher implements IProxy
	{
		protected var datas:ObjectList;
		
		public function AbstractProxy()
		{
			datas = new ObjectList();
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
			return datas.getObjectByName( name ).data;
		}
		
		public function removeData( name:String ):*
		{
			datas.remove( name ).data;
		}
		
		public function clearData():void {
			datas.clear();
		}
	}
}