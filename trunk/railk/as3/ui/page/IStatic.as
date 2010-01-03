/**
 * PageLoading
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.observer.Notification;
	public interface IStatic
	{	
		function handleNotification(evt:Notification):void;
		function show():void;
		function hide():void;
		function get prev():IStatic;
		function set prev(value:IStatic):void;
		function get next():IStatic;
		function set next(value:IStatic):void;
		function get anchor():String;
		function set anchor(value:String):void;
	}
}