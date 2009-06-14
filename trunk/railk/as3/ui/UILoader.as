/**
 * UIloader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;

	public class UILoader
	{
		private var loader:Loader;
		private var complete:Function;
		public function UILoader(src:String, complete:Function) {
			this.complete = complete;
			var context:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, manageEvent );
			loader.load( new URLRequest(src+'?nocache'+int(Math.random()*1000)*getTimer()+''+getTimer()),context );
		}
		
		private function manageEvent(evt:Event):void {
			complete.apply();
			loader.unload();
			dispose();
		}
		
		public function stop():void {
			if (loader) { loader.close(); dispose(); }
		}
		
		private function dispose():void {
			loader.removeEventListener(Event.COMPLETE, manageEvent );
			loader = null;
			complete = null;
		}
	}
}