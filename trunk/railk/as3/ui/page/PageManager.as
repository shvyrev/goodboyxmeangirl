/**
 * 
 * Page Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.display.Loader;
	import railk.as3.pattern.mvc.core.AbstractFacade;
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.ui.RightClickMenu;
	import railk.as3.TopLevel;
	
	public class PageManager extends AbstractFacade implements IFacade
	{
		public var index:Page;
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var pages:Array=[];
		
		public static function getInstance():PageManager {
			return Singleton.getInstance(PageManager);
		}
		
		public function PageManager() { 
			Singleton.assertSingle(PageManager); 
		}
		
		public function init( title:String, hasmenu:Boolean, model:String, controller:String, src:String):void {
			LinkManager.init( title, true, true);
			this.menu = new RightClickMenu();
			this.hasMenu = hasMenu;
			this.loadEngine(src,model,controller);
		}
		
		public function addPage(parent:String, title:String, layout:Layout, assets:Array = null):void {
			if (parent==''){
				index = new Page(model,controller,null,title,layout,assets);
				pages[pages.length] = index;
			} else {
				pages[pages.length] = new Page(model,controller,getPage(parent), title, layout, assets);
				pages[pages.length-1].parent.addChild(pages[pages.length-1]);
			}
			var link:String='/', prt:Page;
			while (prt) { link='/'+prt.title+link; prt = prt.parent; }
			link+=title+'/';
			var action=function(type:String, requester:*, data:*) {
				if (type == 'do') {
					pages[pages.length-1].show();
					TopLevel.stage.addChild(pages[pages.length-1].component);
				} else if (type == 'undo') {
					pages[pages.length-1].hide();
					TopLevel.stage.removeChild(pages[pages.length-1].component);
				}
			}
			LinkManager.add(link,null,action,null,true);
		}
		
		public function getPage( name:String ):Page {
			for (var i:int=0; i<pages.length; ++i) if (pages[i].title == name ) return pages[i];
			return null;
		}
		
		public function loadEngine(src:String, model:String, controller:String) {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event)
			{
				this.registerModel(getDefinitionByName(model) as Class);
				this.registerController(getDefinitionByName(controller) as Class);
			}
			, false, 0, true );
			loader.load( new URLRequest(src) );
		}
	}
}