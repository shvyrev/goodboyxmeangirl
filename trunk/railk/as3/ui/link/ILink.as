/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.link
{	
	import flash.utils.Dictionary;
	public interface ILink
	{	
		function addTarget(name:String, target:Object, event:String = 'mouse', action:Function = null, colors:Object = null, inside:Boolean = false, data:*= null):ILink;
		function initListeners(target:Object, event:String):void;
		function delListeners(target:Object, event:String):void;
		function initAllListeners():void;
		function delAllListeners():void;
		function action(data:*= null, mouse:Boolean = false):void;
		function dispose():void;
		function get next():ILink;
		function set next(value:ILink):void;
		function get prev():ILink;
		function set prev(value:ILink):void;
		function get name():String;
		function get group():String;
		function get navigation():Boolean;
		function get swfAddress():Boolean;
		function get targets():Dictionary;
		function get active():Boolean;
		function toString():String;
	}
}