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
	import railk.as3.ui.SEO;
	import railk.as3.ui.UILoader;
	
	public class PageManager extends AbstractFacade implements IFacade
	{
		public var index:Page;
		public var current:String='';
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var background:Background;
		public var loader:UILoader;
		
		public static function getInstance():PageManager {
			return Singleton.getInstance(PageManager);
		}
		
		public function PageManager() { 
			Singleton.assertSingle(PageManager); 
		}
		
		public function init( author:String, title:String, hasMenu:Boolean, model:String, controller:String, src:String):void {
			LinkManager.init( title, true, true);
			this.hasMenu = hasMenu;
			menu = new RightClickMenu();
			menu.add(author,null,true);
			loader = new UILoader(src, function():void {
				registerModel(getDefinitionByName(model) as Class);
				registerController(getDefinitionByName(controller) as Class);
			});
		}
		
		public function setBackground(id:String, layout:Layout, src:String):void {
			background = new Background(id, layout, src );
			background.show();
		}
		
		public function addPage(id:String, parent:String, title:String, loadingView:*, layout:Layout, src:String):void {
			if (parent==''){
				index = new Page(id,null,title,loadingView,layout,src);
				registerView( index );
			} else {
				registerView( new Page(id, getPage(parent), title, loadingView, layout, src) );
				getPage(parent).addChild(getPage(id));
			}
			
			//link
			var link:String='', prt:Page=getPage(parent);
			while (prt) { link=(prt.id!='index')?prt.id+'/'+link:'/'+link; prt=prt.parent; }
			link+=(id!='index')?id+'/':'/';
			var action:Function=function(data:*=null):void { setPage(id,data); }
			menu.add(title,function():void { LinkManager.setValue(link) }, ((id=='index')?true:false) );
			LinkManager.add(link,null,action,null,true);
		}
		
		public function getPage( id:String ):Page { return getView(id) as Page; }
		
		public function setPage( id:String, data:*= null ):void {
			if (current != id) {
				if(current) unsetPage(current);
				var page:Page = getPage(id);
				page.data = data;
				page.show();
				current = id;
			}
		}
		
		public function unsetPage( id:String ):void {
			var page:Page = getPage(id);
			page.hide();
		}
		
		public function setContextMenu():void {
			container.contextMenu = menu.menu;
		}
	}
}