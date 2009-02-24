/**
* 
* MVC Imodel
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.interfaces
{
	import flash.events.IEventDispatcher;
	
	public interface IModel
	{
		function registerProxy( proxyClass:Class ):void;
		function removeProxy( name:String ):void;
		function hasProxy( name:String ):Boolean;
	}
}