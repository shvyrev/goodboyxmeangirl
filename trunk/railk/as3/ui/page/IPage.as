/**
 * ...
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import railk.as3.ui.page.AbstractPage
	import railk.as3.data.list.DLinkedList;
	import railk.as3.ui.layout.Layout;
	
	public interface IPage
	{
		function setlayout( layout:Layout ):void;
		function addChild( child:AbstractPage ):void;
		function addChilds( childs:Array ):void;
		function render():void;
		function get name():String;
		function set name():String;
		function get parent():AbstractPage;
		function set parent():AbstractPage;
		function get childs():DLinkedList;
		function set childs():DLinkedList;
	}
	
}