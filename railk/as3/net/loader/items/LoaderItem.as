/**
 * Loader Item
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.loader.items
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	public class LoaderItem extends SimpleItem
	{
		private var loader:Loader;
		public function LoaderItem( url:URLRequest, name:String, args:Object, priority:int, preventCache:Boolean, bufferSize:int, mode:String ):void {			
			super(url,name,args,priority,preventCache,bufferSize,mode);
		}
		
		override public function start():void {
			var context:LoaderContext;
			loader=new Loader();
			if ( mode == 'sameDomain' ) context = new LoaderContext(true, ApplicationDomain.currentDomain);
			else if ( mode == 'externalDomain' ) context = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			initListeners(loader.contentLoaderInfo);
			loader.load( url, context );
		}
		
		override public function stop():void { loader.close() }
		
		override protected function complete(evt:Event):void {
			content = loader.content;
			dispose();
			super.complete(evt);
		}
		
		override public function dispose():void {
			super.dispose();
			delListeners(loader);
			loader.unload();
			loader = null;
		}
	}
}