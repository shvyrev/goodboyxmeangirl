/**
 * Chrome
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.air.chrome
{	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Screen;
	
	public class Chrome
	{
		public var name:String;
		public var application:NativeApplication;
		public var screen:Screen;
        public var window:NativeWindow;
		
		public function Chrome(name:String, alignType:String, systemChrome:Boolean=false):void {
			this.name = name;			
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.systemChrome = systemChrome?NativeWindowSystemChrome.STANDARD:NativeWindowSystemChrome.NONE;
			options.transparent = true;
			application = NativeApplication.nativeApplication;
			screen = Screen.mainScreen;
			window = new NativeWindow( options );
			window.activate();
			align(alignType);
		}
	
		private function align(type:String):void {
			switch(type) {
				case 'L':
					window.x = 0;
					window.y = Math.round((screen.visibleBounds.height - window.height)*.5);
					break;
				case 'R':
					window.x = screen.visibleBounds.width - window.width;
					window.y = Math.round((screen.visibleBounds.height - window.height)*.5);
					break;
				case 'T':
					window.x = Math.round((screen.visibleBounds.width - window.width)*.5);
					window.y = 0;
					break;
				case 'B':
					window.x = Math.round((screen.visibleBounds.width - window.width)*.5);
					window.y = screen.visibleBounds.height-window.height;
					break;
				case 'TL':
					window.x = 0;
					window.y = 0;
					break;
				case 'TR':
					window.x = 0;
					window.y = screen.visibleBounds.height-window.height;
					break;
				case 'BL':
					window.x = 0;
					window.y = screen.visibleBounds.height-window.height;
					break;
				case 'BR':
					window.x = screen.visibleBounds.width - window.width;
					window.y = screen.visibleBounds.height-window.height;
					break;
				case 'CENTER' :
					window.x = Math.round((screen.visibleBounds.width - window.width)*.5);
					window.y = Math.round((screen.visibleBounds.height - window.height)*.5);
					break
			}
		}
	}
}