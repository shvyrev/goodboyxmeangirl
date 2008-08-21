/**
* 
* RightClickMenu builder
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function RightClickMenu( target:* ):void
		{
			menu = new ContextMenu();
			menu.hideBuiltInItems();
			target.contextMenu = menu;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 		  ADD
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function add( name:String, action:Function ):void
		{
			actions[name] = action;
			item = new ContextMenuItem( name );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, manageEvent, false, 0, true );
			menu.customItems.push( item );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 	   REMOVE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 	  	 SHOW
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function show( name:String ):void
		{
			var chosenItem:ContextMenuItem = getItemByName( name );
			if ( item )
			{
				item.visible = true;
			}
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 	   	 HIDE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function hide( name:String ):void
		{
			var chosenItem:ContextMenuItem = getItemByName( name );
			if ( item )
			{
				item.visible = false;
			}
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																					 GET ITEM BY NAME
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function getItemByName( name:String ):*
		{
			var result:*;
			loop:for ( var i:int = 0; i < menu.customItems.length; i++ )
			{
				if ( menu.customItems[i].caption == name )
				{
					result = menu.customItems[i];
					break loop;
				}
			}
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						    TO STRING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function manageEvent( evt:ContextMenuEvent ):void 
		{
			switch( evt.type )
			{
				case ContextMenuEvent.MENU_ITEM_SELECT :
					actions[evt.target.caption].call();
					break;
			}
		}
		
	}
	
}