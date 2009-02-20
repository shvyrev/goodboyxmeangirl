/**
* 
* RightClickMenu builder
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui
{
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.events.ContextMenuEvent;
	
	
	public class RightClickMenu extends EventDispatcher
	{
		//______________________________________________________________________________ VARIABLES RAPATRIEES
		private var _name                                           :String;
		
		//_________________________________________________________________________________________ VARIABLES
		private var menu                                            :ContextMenu;
		private var item                                            :ContextMenuItem;
		private var actions                                         :Object={};
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function RightClickMenu( target:*, hideDefault:Boolean=true )
		{
			menu = new ContextMenu();
			if(hideDefault) menu.hideBuiltInItems();
			target.contextMenu = menu;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		  ADD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function add( name:String, action:Function, separator=false ):void
		{
			actions[name] = action;
			item = new ContextMenuItem( name,separator );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent, false, 0, true );
			menu.customItems.push( item );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function remove( name:String ):void
		{
			actions[name] = null;
			loop:for ( var i:int = 0; i < menu.customItems.length; i++ )
			{
				if ( menu.customItems[i].caption == name )
				{
					menu.customItems[i].removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent );
					menu.customItems.splice(i, 1);
					break loop;
				}
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  	 SHOW
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function show( name:String ):void
		{
			var chosenItem:ContextMenuItem = getItemByName( name );
			if ( chosenItem ) chosenItem.visible = true;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   	 HIDE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function hide( name:String ):void
		{
			var chosenItem:ContextMenuItem = getItemByName( name );
			if ( chosenItem ) chosenItem.visible = false;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 GET ITEM BY NAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getItemByName( name:String ):ContextMenuItem
		{
			var result:ContextMenuItem;
			loop:for ( var i:int = 0; i < menu.customItems.length; i++ )
			{
				if ( menu.customItems[i].caption == name )
				{
					result = menu.customItems[i];
					break loop;
				}
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						      DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void
		{
			actions = null;
			for ( var i:int = 0; i < menu.customItems.length; i++ )
			{
				menu.customItems[i].removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent );
			}
			menu.customItems = null;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						    TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public override function toString():String
		{
			var result:String = '[ RightClickMenu Items\n';
			var state:String;
			for ( var i:int = 0; i < menu.customItems.length; i++ )
			{
				if ( menu.customItems[i].visible ) state = 'visible';
				else state = 'hidden';
				result += '[ '+menu.customItems[i].caption+' is '+state+' ]\n'
			}
			result += ' RightClickMenu Items ]'
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:ContextMenuEvent ):void 
		{
			switch( evt.type )
			{
				case ContextMenuEvent.MENU_ITEM_SELECT :
					actions[evt.target.caption].apply();
					break;
			}
		}
	}
}