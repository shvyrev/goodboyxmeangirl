/**
* 
* Iproxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.interfaces
{
	import railk.as3.pattern.mvc.proxy.Data;
	public interface IProxy
	{
		function getData( name:String ):*;
		function removeData( name:String ):void;
		function clearData():void;
		function dispose():void;
		function get name():String;
	}
}