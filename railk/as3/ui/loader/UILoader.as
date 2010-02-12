/**
 * UIloader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.loader
{	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;

	public class UILoader extends EventDispatcher
	{
		public var content:Object;
		public var url:URLRequest;
		private var type:Array;
		private var loader:Object;
		private var listener:Object;
		private var _progress:Function;
		private var _complete:Function;
		private var pArgs:Array=[];
		private var cArgs:Array=[];
		
		public function UILoader(url:String, noCache:Boolean=true) {
			this.url = new URLRequest(url+(noCache?'?nocache='+int(Math.random()*1000)*getTimer()+''+getTimer():''));
			init(url);
		}
		
		private function init(url:String):void {
			var types:Object = { 'flash.display.Loader,contentLoaderInfo,content':'jpg,gif,png,swf', 'flash.net.URLLoader,,data':'xml,zip,json' };
			for ( var t:String in types) if (types[t].search(url.split('.')[url.split('.').length - 1]) != -1) { type = t.split(','); break; }
			loader = new (getDefinitionByName(type[0]))();
			listener = (type[1])?loader[type[1]]:loader;
			if(type[1]) loader.load(this.url,new LoaderContext(true, ApplicationDomain.currentDomain));
			else loader.load(this.url);
		}
		
		public function progress(action:Function, ...args):UILoader {
			_progress = action;
			pArgs = (args.length>0)?args:pArgs;
			listener.addEventListener(ProgressEvent.PROGRESS, manageEvent );
			return this;
		}
		
		public function complete(action:Function, ...args):UILoader {
			_complete = action;
			cArgs = (args.length>0)?args:cArgs;
			listener.addEventListener(Event.COMPLETE, manageEvent );
			return this;
		}
		
		private function manageEvent(evt:*):void {
			switch(evt.type) {
				case Event.COMPLETE :
					content = (type[1])?listener.content:listener.data;
					if(!type[1] || content.toString().search('Bitmap') != -1) cArgs[cArgs.length] = content;
					_complete.apply(null,cArgs);
					if(type[1]) loader.unload();
					dispose();
					break;
				case ProgressEvent.PROGRESS :
					pArgs[(pArgs.length>0)?pArgs.length-1:pArgs.length] = int(evt.bytesLoaded / evt.bytesTotal * 100);
					_progress.apply(null, pArgs); 
					break;
				default : break;
			}
		}
		
		public function stop():void { if (loader) { loader.close(); dispose(); } }	
		private function dispose():void {
			listener.removeEventListener(Event.COMPLETE, manageEvent );
			if (_progress != null) listener.removeEventListener(ProgressEvent.PROGRESS, manageEvent );
			content = loader = listener = null;
			_complete = _progress = null;
		}
	}
}