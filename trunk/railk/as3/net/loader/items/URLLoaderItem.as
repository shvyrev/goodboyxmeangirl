/**
 * Binary item
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.loader.items
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class URLLoaderItem extends SimpleItem
	{
		private var types:Object={'.drw':'binary','.flow':'binary','.zip':'binary','.txt':'text','.js':'text','.php':'text','.css':'text','.xml':'text,xml'};
		private var dataFormat:String;
		private var contentType:String;
		private var loader:URLLoader;
		public function URLLoaderItem( url:URLRequest, name:String, args:Object,priority:int, preventCache:Boolean, bufferSize:int, mode:String ):void {			
			super(url,name,args,priority,preventCache,bufferSize,mode);
			var type:Array=types[url.url.match(/\.[a-zA-Z0-9]{3,3}/)[url.url.match(/\.[a-zA-Z0-9]{3,3}/).length - 1]].split(',');
			dataFormat = type[0];
			contentType = type[type.length-1];
		}
		
		override public function start():void {
			loader =new URLLoader();
			loader.dataFormat = dataFormat;
			initListeners(loader);
			loader.load(url);
		}
		
		override public function stop():void { 
			loader.close();
			end();
		}
		
		override protected function end():void {
			delListeners( loader );
			loader = null;
		}
		
		override protected function complete(evt:Event):void {
			content = (contentType=='binary')?(loader.data as ByteArray):((contentType=='xml')?(new XML(loader.data)):loader.data);
			end();
			super.complete(evt);
		}
	}
}