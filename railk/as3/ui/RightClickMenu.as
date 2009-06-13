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
		public var menu:ContextMenu;
		private var item:ContextMenuItem;
		private var actions:Object={};
		private var items:Array=[];
		
		/**
		 * CONSTRUCTEUR
		 */
		public function RightClickMenu( hideDefault:Boolean=true ) {
			menu = new ContextMenu();
			if(hideDefault) menu.hideBuiltInItems();
		}
		
		/**
		 * MANAGE ITEMS
		 */
		public function add( name:String, action:Function=null, separator:Boolean=false ):void {
			actions[name] = action;
			item = new ContextMenuItem( name,separator );
			if(action!=null) item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent, false, 0, true );
			menu.customItems.push( item );
			items.push(name);
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
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			actions = null;
			for ( var i:int = 0; i < menu.customItems.length; i++ ) menu.customItems[i].removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent );
			menu.customItems = null;
		}
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( evt:ContextMenuEvent ):void { actions[evt.target.caption].apply(); }
		
		/**
		 * DISPOSE
		 */
		override public function toString():String {
			return '[CONTEXT MENU > '+items+' ]'
		}
	}
}