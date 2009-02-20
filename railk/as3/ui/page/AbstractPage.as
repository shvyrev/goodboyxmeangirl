/**
 * ...
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.ui.layout.Layout;
	import railk.as3.data.list.DLinkedList;
	
	public class AbstractPage extends AbstractView implements IPage, IView
	{
		private var _name:String;
		private var _parent:AbstractPage;
		private var _childs:DLinkedList;
		
		public function AbstractPage(parent:AbstractPage=null)
		{
			_parent = parent;
			_childs = new DLinkedList();
		}
		
		public function setlayout( layout:Layout ):void
		{
			
		}
		
		public function addChild( child:AbstractPage ):void
		{
			
		}
		
		public function addChilds( childs:Array):void
		{
			
		}
		
		public function render():void
		{
			
		}
		
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get parent():AbstractPage { return _parent; }
		
		public function set parent(value:AbstractPage):void 
		{
			_parent = value;
		}
		
		public function get childs():DLinkedList { return _childs; }
		
		public function set childs(value:DLinkedList):void 
		{
			_childs = value;
		}
		
		
	}
	
}