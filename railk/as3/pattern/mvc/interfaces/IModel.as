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
		function load( type:String, ...args ):*
		function getData( name:String ):*
		function updateView(type:String):void;
		function clearData():void;
	}
}