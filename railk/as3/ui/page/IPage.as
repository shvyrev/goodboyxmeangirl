/**
 * PageLoading
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.observer.Notification;
	public interface IPage
	{	
		function addChild( child:IPage ):void;
		function handleNotification(evt:Notification):void;
		function show():void;
		function hide():void;
		function zoom():void;
		function dezoom():void;
		function adapt():void;
		function play():void;
		function stop():void;
		function dispose():void;
		function get id():String;
		function get title():String;
		function get parent():IPage;
		function get transition():ITransition;
		function get isRoot():Boolean;
		function get isLeaf():Boolean;
		function get hasChildren():Boolean;
		function get depth():int;
		function get firstChild():IPage;
		function set firstChild(value:IPage):void;
		function get lastChild():IPage;
		function set lastChild(value:IPage):void;
		function get next():IPage;
		function set next(value:IPage):void;
		function get prev():IPage;
		function set prev(value:IPage):void;
		function get anchor():String;
		function set anchor(value:String):void;
		function toString():String;
	}
}