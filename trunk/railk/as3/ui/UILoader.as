/**
 * UIloader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	import flash.events.IOErrorEvent

	public class UILoader extends EventDispatcher
	{
		public var content:*;
		private var loader:Loader;
		private var progress:Function;
		private var complete:Function;
		public function UILoader(src:String, complete:Function, progress:Function=null, noCache:Boolean=true) {
			this.progress = progress;
			this.complete = complete;
			var context:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, manageEvent );
			if (progress!=null) loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, manageEvent );
			loader.load( new URLRequest(src+(noCache?'?nocache='+int(Math.random()*1000)*getTimer()+''+getTimer():'')),context );
		}
		
		private function manageEvent(evt:*):void {
			switch(evt.type) {
				case Event.COMPLETE :
					content = loader.contentLoaderInfo.content;
					complete.apply();
					loader.unload();
					dispose();
					break;
				case ProgressEvent.PROGRESS : progress.apply(null, [int(evt.bytesLoaded / evt.bytesTotal * 100)]); break;
				default : break;
			}
		}
		
		public function stop():void {
			if (loader) { loader.close(); dispose(); }
		}
		
		private function dispose():void {
			loader.removeEventListener(Event.COMPLETE, manageEvent );
			if (progress != null) loader.removeEventListener(ProgressEvent.PROGRESS, manageEvent );
			content = loader = null;
			complete = progress = null;
		}
	}
}