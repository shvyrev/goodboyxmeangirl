/**
* 
* Imodel
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.interfaces
{
	import flash.events.IEventDispatcher;
	
	public interface IModel extends IEventDispatcher
	{
		function updateView(info:String, type:String, data:Object = null ):void;
		function getData( name:String ):*;
		function clearData():void;
	}
}