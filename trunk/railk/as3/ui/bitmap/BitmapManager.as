/**
 * Font Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.bitmap
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import railk.as3.event.CustomEvent;
	import railk.as3.display.UIBitmap;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.loader.UILoader;
	
	public final class BitmapManager extends EventDispatcher
	{
		public static function getInstance():BitmapManager {
			return Singleton.getInstance(BitmapManager);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function BitmapManager() { Singleton.assertSingle(BitmapManager); }
		
		private var loader:UILoader;
		private var bmps:Dictionary = new Dictionary(true);
		private var bmds:BitmapPool;
		
		/**
		 * INIT
		 * @param	size
		 * @param	growthRate
		 * @param	limit
		 * @return
		 */
		public function init(size:int, growthRate:int, limit:int):BitmapManager { 
			loader = new UILoader().dispose(false);
			bmds = new BitmapPool(size, growthRate, limit);
			return this; 
		}
		
		/**
		 * LOAD AND ADD BITMAP
		 * @param	url
		 */
		public function addUrlList(urls:Array):BitmapManager { for (var i:int = 0; i < urls.length; i++) addUrl(urls[i]); return this; }
		public function addUrl(url:String):BitmapManager { loader.add(url); return this; }
		public function load(slot:int=7):BitmapManager {
			if (!loader.active) loader.progress(_progress,UILoader.PERCENT,UILoader.PERCENTS).file(add,UILoader.FILE,UILoader.FILE_URL).complete(_complete).start(slot);
			return this;
		}
		
		private function add(data:Bitmap,url:String):void {
			var name:String = url.split('/').pop().split('.')[0];
			var bmp:UIBitmap = bmds.pick(data.width, data.height);
			bmp.bitmapData.draw(data);
			bmps[name] = bmp;
			loader.content[url].bitmapData.dispose();
			loader.content[url] = null;
			delete loader.content[url];
			_file(bmp,name);
		}
		
		/**
		 * INTERNAL CALLBACKS AND EVENTS
		 */
		private function _progress(percent:Number, filesPercent:Dictionary):void {
			var e:BitmapManagerEvent = new BitmapManagerEvent(BitmapManagerEvent.PROGRESS);
			e.percent = percent;
			e.percents = filesPercent;
			dispatchEvent(e);
		}
		private function _file(bitmap:UIBitmap,name:String):void { 
			var e:BitmapManagerEvent = new BitmapManagerEvent(BitmapManagerEvent.FILE);
			e.bitmap = bitmap;
			e.name = name;
			dispatchEvent(e);
		}
		
		private function _complete():void { 
			var e:BitmapManagerEvent = new BitmapManagerEvent(BitmapManagerEvent.COMPLETE);
			dispatchEvent(e);
		}
		
		public function addEvent(type:String, listener:Function ):BitmapManager {
			super.addEventListener(type, listener, false, 0, true);
			return this;
		}
		
		public function removeEvent(type:String, listener:Function):BitmapManager {
			super.removeEventListener(type, listener, false);
			return this;
		}
		
		/**
		 * DELETE BITMAP
		 * @param	name
		 */
		public function del(name:String):BitmapManager {
			bmds.release(bmps[name]);
			bmps[name] = null;
			delete bmps[name];
			return this;
		}
		
		/**
		 * DELETE ALL BITMAP
		 */
		public function purge():void {
			for ( var name:String in bmps) {
				bmds.release(bmps[name]);
				delete bmps[name];
			}
			bmds.purge();
		}
		
		/**
		 * HAS BITMAP
		 * @param	name
		 * @return
		 */
		public function has( name:String ):Boolean {
			if (bmps[name] != undefined) return true;
			return false;
		}
		
		/**
		 * GET BITMAP BY NAME
		 * @param	name
		 * @return
		 */
		public function getByName(name:String):UIBitmap {
			if (has(name)) return bmps[name];
			throw new Error("le bitmap n'existe pas, veuiller le télécharger");
		}
	}
}

import flash.display.BitmapData;
import railk.as3.display.UIBitmap
internal final class BitmapPool
{
	public var growthRate:int;
	public var size:int=0;
	public var limit:int;
	
	private var free:int=0;
	private var os:Array = [];
	private var last:UIBitmap;
	private var picked:UIBitmap;
	
	
	public function BitmapPool( size:int, growthRate:int, limit:int) {
		this.limit = limit;
		this.growthRate = growthRate;
		this.populate(size);
	}
	
	private function populate(i:int):void {
		if (size >= limit) throw Error('bitmapManager limit exceeded');
		while( --i > -1 ) {
			last = new UIBitmap();
			os[free++] = last;
			size++;
		}
	}
	
	public function pick(width:int, height:int):UIBitmap {
		if (free < 1 ) populate(growthRate);
		picked = last;
		last = os[--free-1];
		picked.bitmapData = new BitmapData(width, height, true, 0xFF000000);
		return picked;
	}
	
	public function release( o:UIBitmap ):void {
		o.bitmapData.dispose();
		os[free++] = o;
		last = o;
	}
	
	public function purge():void {
		var i:int=os.length;
		while ( --i > -1 ) os[i].bitmapData.dispose();
		os[i] = null;
		os = [];
		size = 0;
	}		
}