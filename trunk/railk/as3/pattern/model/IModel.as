/**
* 
* Imodel
* 
* @author Richard Rodney
*/

package railk.as3.pattern.model
{
	public interface IModel
	{
		function clearModel():void;
		function updateLocation( event:String ):void;
		function sendInternalEvent( event:String ):void;
		function get data():*;
		function set data( data:* ):void;
		function get currentEvent():String;
	}
}