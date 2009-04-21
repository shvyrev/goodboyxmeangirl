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

	public class UILoader
	{
		public function UILoader(src:String, complete:Function) {
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event){
				complete.apply();
				loader.unload();
				loader = null;
			}, false, 0, true );
			loader.load( new URLRequest(src),context );
		}		
	}
}