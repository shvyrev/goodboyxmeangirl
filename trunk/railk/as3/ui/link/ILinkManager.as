/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.link
{	
	public interface ILinkManager
	{	
		function init( titre:String, swfAdressEnable:Boolean = false, updateTitleEnable:Boolean = false ):ILinkManager;
		function addGroup(name:String, navigation:Boolean = false):ILinkManager;
		function delGroup(name:String):void;
		function add( name:String, target:Object = null, action:Function = null, title:String='', group:String = '', colors:Object = null, swfAdressEnable:Boolean = false, type:String = 'mouse', data:*= null):ILink;
		function remove( name:String ):void;
		function getLink( name:String, group:String = '' ):ILink;
		function getLinks(group:String = ''):Array;
		function forward():void;
		function back():void;
		function blanc(url:String):void;
		function navigationChange(name:String):void;
		function setValue(value:String):void;
		function get titre():String;
		function set titre( value:String ):void;	
	}
}