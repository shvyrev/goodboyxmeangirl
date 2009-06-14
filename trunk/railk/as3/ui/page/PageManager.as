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
	import railk.as3.utils.Logger;
	
	public class PageManager extends AbstractFacade implements IFacade
	{
		public var index:Page;
		public var current:Page;
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
			background = new Background(id, model, controller, layout, src );
			background.show();
		}
		
		public function addPage(id:String, parent:String, title:String, layout:Layout, src:String):void {
			if (parent==''){
				index = new Page(id,model,controller,null,title,layout,src);
				pages[pages.length] = index;
			} else {
				pages[pages.length] = new Page(id,model,controller,getPage(parent), title, layout, src);
				getPage(parent).addChild(pages[pages.length-1]);
			}
			var link:String='', prt:Page=getPage(parent);
			while (prt) { link=(prt.id!='index')?prt.id+'/'+link:'/'+link; prt=prt.parent; }
			link+=(id!='index')?id+'/':'/';
			var action:Function=function(data:*=null):void { setPage(id,data); }
			registerView(getPage(id));
			menu.add(title,function():void { LinkManager.setValue(link) }, ((id=='index')?true:false) );
			LinkManager.add(link,null,action,null,true);
		}
		
		public function getPage( id:String ):Page {
			for (var i:int=0; i<pages.length; ++i) if (pages[i].id == id ) return pages[i];
			return null;
		}
		
		public function setPage( id:String, data:*= null ):void {
			Logger.print( 'setPage' + id );
			if (!current || current.id!=id) {
				if(current) unsetPage(current.id);
				var page:Page = getPage(id);
				current = page;
				page.data = data;
				page.show();
			}
		}
		
		public function unsetPage( id:String ):void {
			var page:Page = getPage(id);
			page.hide();
		}
		
		public function setContextMenu():void {
			TopLevel.main.contextMenu = menu.menu;
		}
	}
}