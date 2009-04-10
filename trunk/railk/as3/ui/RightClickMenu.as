/**
* 
* RightClickMenu builder
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui
{
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.events.ContextMenuEvent;
	
	
	public class RightClickMenu extends EventDispatcher
	{
		public var menu     :ContextMenu;
		private var item    :ContextMenuItem;
		private var actions :Object={};
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function RightClickMenu( hideDefault:Boolean=true ) {
			menu = new ContextMenu();
			if(hideDefault) menu.hideBuiltInItems();
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 MANAGE ITEMS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function add( name:String, action:Function, separator=false ):void {
			actions[name] = action;
			item = new ContextMenuItem( name,separator );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent, false, 0, true );
			menu.customItems.push( item );
		}
		
		public function remove( name:String ):void {
			actions[name] = null;
			loop:for ( var i:int = 0; i < menu.customItems.length; i++ ) {
				if ( menu.customItems[i].caption == name ) {
					menu.customItems[i].removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent );
					menu.customItems.splice(i, 1);
					break loop;
				}
			}
		}
		
		public function show( name:String ):void {
			var chosenItem:ContextMenuItem = getItemByName( name );
			if ( chosenItem ) chosenItem.visible = true;
		}
		
		public function hide( name:String ):void {
			var chosenItem:ContextMenuItem = getItemByName( name );
			if ( chosenItem ) chosenItem.visible = false;
		}
		
		public function getItemByName( name:String ):ContextMenuItem {
			var result:ContextMenuItem;
			loop:for ( var i:int = 0; i < menu.customItems.length; i++ ) {
				if ( menu.customItems[i].caption == name ) {
					result = menu.customItems[i];
					break loop;
				}
			}
			return result;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						      DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function dispose():void {
			actions = null;
			for ( var i:int = 0; i < menu.customItems.length; i++ ) menu.customItems[i].removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent );
			menu.customItems = null;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function manageEvent( evt:ContextMenuEvent ):void {
			switch( evt.type ) {
				case ContextMenuEvent.MENU_ITEM_SELECT : actions[evt.target.caption].apply(); break;
			}
		}
	}
}