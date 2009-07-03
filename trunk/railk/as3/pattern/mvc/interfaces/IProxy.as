/**
* 
* Iproxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.interfaces
{
	public interface IProxy
	{
		function getData( name:String ):*;
		function removeData( name:String ):*;
		function clearData():void;
		function dispose():void;
		function get name():String;
	}
}