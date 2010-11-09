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
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;

	public class UILoader extends EventDispatcher
	{
		public static const CONTENT:String = 'content';
		public static const FILE:String = 'current';
		public static const PERCENT:String = 'percent';
		
		public var percent:Number;
		public var content:Dictionary = new Dictionary(true);
		
		private var urls:Dictionary = new Dictionary(true);
		private var loaders:Dictionary = new Dictionary(true);
		private var listeners:Dictionary = new Dictionary(true);
		private var types:Dictionary = new Dictionary(true);
		private var percents:Dictionary = new Dictionary(true);
		private var _progress:Function;
		private var _complete:Function;
		private var _file:Function;
		private var pArgs:Array=[];
		private var cArgs:Array = [];
		private var fArgs:Array = [];
		private var active:int;
		private var count:int;
		private var current:Object;
		
		/**
		 * CONSTRUCTEUR
		 * @param	url
		 * @param	noCache
		 */
		public function UILoader(url:String, noCache:Boolean=true) { add(url,noCache); }
		
		/**
		 * ADD FILE TO LOAD
		 */
		public function add(url:String, noCache:Boolean = true):UILoader {
			urls[url] = new URLRequest(init( url )+(noCache?'?nocache='+int(Math.random()*1000)*getTimer()+''+getTimer():''));
			return this;
		}
		
		private function init(url:String):String {
			var types:Object = { 'flash.display.Loader,contentLoaderInfo,content':'jpg,gif,png,swf', 'flash.net.URLLoader,,data':'xml,zip,json,css,txt' }, type:Array;
			for ( var t:String in types) if (types[t].search(url.split('.')[url.split('.').length - 1]) != -1) { this.types[url] = type = t.split(','); break; }
			loaders[url] = new (getDefinitionByName(type[0]))();
			listeners[url] = (type[1])?loaders[url][type[1]]:loaders[url];
			percents[url] = 0;
			active = count++;
			return url;
		}
		
		/**
		 * PROGRESS
		 * 
		 * @param	action
		 * @param	...args  CAN BE UILOADER.PERCENT
		 * @return
		 */
		public function progress(action:Function, ...args):UILoader {
			_progress = action;
			pArgs = (args.length>0)?args:pArgs;
			for (var url:String in listeners) listeners[url].addEventListener(ProgressEvent.PROGRESS, manageEvent );
			return this;
		}
		
		/**
		 * FILE COMPLETE
		 * 
		 * @param	action
		 * @param	...args  CAN BE UILOADER.FILE
		 * @return
		 */
		public function file(action:Function, ...args):UILoader {
			_file = action;
			fArgs = (args.length > 0)?args:fArgs;
			for (var url:String in listeners) listeners[url].addEventListener(Event.COMPLETE, manageEvent );
			return this;
		}
		
		/**
		 * COMPLETE
		 * 
		 * @param	action
		 * @param	...args CAN BE UILOADER.CONTENT
		 * @return
		 */
		public function complete(action:Function, ...args):UILoader {
			_complete = action;
			cArgs = (args.length>0)?args:cArgs;
			for (var url:String in listeners) listeners[url].addEventListener(Event.COMPLETE, manageEvent );
			return this;
		}
		
		private function manageEvent(e:*):void {
			var listener:*= e.currentTarget, url:String, i:int;
			switch(e.type) {
				case Event.COMPLETE :
					content[getUrl(listener)] = current = (listener is URLLoader)?listener.data:listener.content;
					if (_file != null) _file.apply(null, checkArgs(fArgs, FILE));
					if (!active) { 
						for (url in loaders) if (types[url][1]) loaders[url].unload();
						if(_complete!=null) _complete.apply(null, checkArgs(cArgs,CONTENT)); 
						dispose(); 
					}
					active--;
					break;
				case ProgressEvent.PROGRESS :
					percent=0;
					percents[getUrl(listener)] = int(e.bytesLoaded/e.bytesTotal*100);
					for (url in percents) percent += percents[url]/count;
					_progress.apply(null, checkArgs(pArgs,PERCENT));
					break;
				default : break;
			}
		}
		
		/**
		 * START/STOP
		 */
		public function stop():void { if (loaders) { for (var url:String in loaders){ loaders[url].close(); } dispose(); } }
		public function start(max:int=0):UILoader {
			for (var url:String in types) {
				if(types[url][1]) loaders[url].load(urls[url],new LoaderContext(true, ApplicationDomain.currentDomain));
				else loaders[url].load(urls[url]);
			}
			return this;
		}
		
		/**
		 * DISPOSE
		 */
		private function dispose():void {
			for (var url:String in listeners) {
				listeners[url].removeEventListener(Event.COMPLETE, manageEvent );
				if (_progress != null) listeners[url].removeEventListener(ProgressEvent.PROGRESS, manageEvent );
			}
			content = urls = loaders = listeners = types = null;
			_complete = _progress = null;
		}
		
		/**
		 * UTILITIES
		 */
		private function getUrl(listener:*):String { for (var url:String in listeners){ if (listeners[url] == listener) return url; } return ''; }
		private function checkArgs(args:Array, type:String):Array {
			var a:Array = args.slice();
			for (var i:int = 0; i < a.length; i++) if (a[i] == type) a[i] = this[type];
			return a; 
		}
	}
}