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
		function start():void;
		function getData( type:String, ...args ):*
		function updateView(type:String):void;
		function clearData():void;
	}
}