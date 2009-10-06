/**
 * Chrome
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.air.chrome
{	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.desktop.DockIcon;
	import flash.desktop.SystemTrayIcon;
	import flash.events.Event;
	
	public class Tray
	{
		public var application:NativeApplication;
		
		public function Tray( icons:Object ):void {
			application = NativeApplication.nativeApplication;
		}
		
		private function createContextMenu():NativeMenu {
			var menu:NativeMenu = new NativeMenu();
			var item:NativeMenuItem = new NativeMenuItem( name );
			item.name = name;
			menu.addItem( item );
			menu.addEventListener( Event.SELECT, onMenuSelect );
			return menu;
		}

		private function onMenuSelect(event:Event):void {
			if (event.target.name == name) {
				window.visible = true;
				window.restore();
				window.orderToFront();
			}
		}
		
		private function onNativeMenuSelect(event:Event):void {
			if (event.target.label == name) {
				window.visible = true;
				window.restore();
				window.orderToFront();
			}
		}
		
		public function createNativeMenu():void {
			var menu:NativeMenu = NativeApplication.nativeApplication.menu;
			for (var i:Number = 0; i<menu.numItems; i++)if(menu.items[i].label == "Window") var windowMenu:NativeMenuItem = menu.items[i];
			windowMenu.submenu = createWindowMenu();
		}
		
		public function createWindowMenu():NativeMenu {
			var windowMenu:NativeMenu = new NativeMenu();
			var menuItem:NativeMenuItem = new NativeMenuItem(name);
			menuItem.name = name;
			windowMenu.addItem(menuItem);
			menuItem.addEventListener( Event.SELECT, onNativeMenuSelect);
			return windowMenu;
		}
		
		private function setupSystemIcons():void {
			if (NativeApplication.supportsSystemTrayIcon) {
				var icon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				icon.tooltip = name;
				icon.bitmaps = [ icons['16'].bitmapData, icons['128'].bitmapData ];
				icon.menu = createWindowMenu();
				icon.addEventListener( "click", function(evt:Event):void {
					window.visible = true;
					window.restore();
					window.orderToFront();
					}
				);

				var exitCommand:NativeMenuItem = icon.menu.addItem(new NativeMenuItem("Exit"));
				exitCommand.addEventListener(Event.SELECT, function(evt:Event):void { application.exit();});
			}
			
			if (NativeApplication.supportsDockIcon) {
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				dockIcon.menu = createContextMenu();
				createNativeMenu();
			}
		}
	}
}