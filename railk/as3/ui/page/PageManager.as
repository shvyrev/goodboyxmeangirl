/**
 * 
 * Page Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.AbstractFacade;
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.ui.RightClickMenu;
	import railk.as3.ui.UILoader;
	import railk.as3.TopLevel;
	
	public class PageManager extends AbstractFacade implements IFacade
	{
		public var index:Page;
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var pages:Array=[];
		public var background:Background;
		public var loader:UILoader;
		
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
			loader = new UILoader(src, function() {
				registerModel(getDefinitionByName(model) as Class);
				registerController(getDefinitionByName(controller) as Class);
			});
		}
		
		public function setBackground(id:String, view:String, src:String):void {
			background = new Background(id, view, src, TopLevel.stage );
		}
		
		public function addPage(parent:String, title:String, layout:Layout, src:String):void {
			if (parent==''){
				index = new Page(model,controller,null,title,layout,src);
				pages[pages.length] = index;
			} else {
				pages[pages.length] = new Page(model,controller,getPage(parent), title, layout, src);
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
			registerView(pages[pages.length - 1]);
			LinkManager.add(link,null,action,null,true);
		}
		
		public function getPage( name:String ):Page {
			for (var i:int=0; i<pages.length; ++i) if (pages[i].title == name ) return pages[i];
			return null;
		}
		
		public function setPage( name:String ):void {
			var page:Page = getPage(name);
			page.show();
			TopLevel.stage.addChild(page.component);
		}
	}
}