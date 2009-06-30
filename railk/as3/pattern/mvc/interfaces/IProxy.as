/**
* 
* Iproxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.interfaces
{
	import flash.events.IEventDispatcher;
	
	public interface IProxy extends IEventDispatcher
	{
		function updateView(info:String, type:String, data:String='' ):void;
		function getData( name:String ):*;
		function removeData( name:String ):*;
		function clearData():void;
	}
}