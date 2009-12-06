/**
 * Page Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.pattern.multiton.Multiton;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.ui.RightClickMenu;
	import railk.as3.ui.SEO;
	import railk.as3.TopLevel;
	
	public class PageManager extends AbstractFacade implements IFacade
	{
		public var index:IPage;
		public var last:IPage;
		public var statics:IStatic;
		public var current:String='';
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var multiPage:Boolean;
		public var structure:String;
		public var adaptToScreen:Boolean;
		
		private var multiPageOn:Boolean;
		private var multiPageId:String;
		private var multiPageAnchor:String;
		
		public static function getInstance():PageManager {
			return Multiton.getInstance('S',PageManager);
		}
		
		public function PageManager(id:String) {
			super(id);
			MID = Multiton.assertSingle(id,PageManager); 
		}
		
		public function init( author:String, title:String, hasMenu:Boolean, multiPage:Boolean, structure:String, adaptToScreen:Boolean ):void {
			SEO.init();
			LinkManager.init( title, true, true);
			this.hasMenu = hasMenu;
			this.multiPage = multiPage;
			this.structure = structure;
			this.adaptToScreen = adaptToScreen;
			menu = new RightClickMenu();
			menu.add(author, author, null,null, true);
			registerModel(AbstractModel);
			registerController(AbstractController);
			registerContainer( new PageStruct(structure,adaptToScreen) );
			if (multiPage) addEventListener( Notification.NOTE, showNext, false, 0, true );
		}
		
		public function addStatic(id:String, classe:String, layout:Layout, onTop:Boolean, src:String):void {
			var s:Static = (classe == '')?new Static(MID, id, layout, onTop, src ):new (getDefinitionByName(classe))(MID, id, layout, onTop, src );
			if (statics == null ) statics = s;
			else {
				statics.next = s;
				s.prev = statics;
				statics = s;
			}
			s.show();
		}
		
		public function addPage(id:String, parent:String, title:String, classe:String, loading:String, layout:Layout, align:String, src:String, transition:String):void {
			if (parent == '') {
				if( !index) registerView( index = last = (classe=='')?new Page(MID,id,null,title,loading,layout,align,src,transition):new (getDefinitionByName(classe))(MID,id,null,title,loading,layout,align,src,transition) );
				else {
					var page:IPage;
					registerView( page = (classe == '')?new Page(MID, id, null, title, loading, layout, align, src, transition):new (getDefinitionByName(classe))(MID, id, null, title, loading, layout, align, src, transition));
					last.next = page; page.prev = last; last = page;
				}
			} else {
				registerView( ((classe=='')?new Page(MID,id, getPage(parent),title,loading,layout,align,src,transition):new (getDefinitionByName(classe))(MID,id, getPage(parent),title,loading,layout,align,src,transition)) );
				getPage(parent).addChild(getPage(id));
			}
			
			//link
			var link:String='', prt:IPage=getPage(parent);
			while (prt) { link=(prt.id!='index')?prt.id+'/'+link:'/'+link; prt=prt.parent; }
			link+=(id!='index')?'/'+id+'/':'/';
			var action:Function = function(type:String, requester:*, data:*):void {
				switch(type) {
					case 'do': case 'undo' :
						if ( !multiPageOn && multiPage ) showAll(id,data);
						else (multiPage)?goToPage(id,data):setPage(id,data);
						break;
					default : break;
				}
			}
			menu.add(id, title, LinkManager.setValue, [link], ((id == 'index')?true:false) );
			LinkManager.add(link, null, action, '', null, true);
		}
		
		/**
		 * MULTIPAGE NAV
		 */
		public function showAll(id:String, anchor:String = ''):void {
			index.show();
			multiPageOn = true;
			multiPageId = id;
			multiPageAnchor = anchor;
		}
		
		private function showNext(evt:Notification):void {
			(container as PageStruct).activate((evt.page as IView).component);
			if ( (evt.page as IPage).next != null ) (evt.page as IPage).next.show();
			else goToPage(multiPageId, multiPageAnchor);
		}
		
		public function goToPage( id:String, anchor:String = '' ):void {
			if(current != id ) {
				if (current) getPage(current).stop();
				var page:IPage = getPage(id);
				page.anchor = anchor;
				(container as PageStruct).goTo(id, page.transition.easeInOut, page.play );
				current = id;
			}	
		}
		
		/**
		 * SINGLE PAGE NAV
		 */
		public function getPage( id:String ):IPage { return getView(id) as IPage; }
		
		public function setPage( id:String, anchor:String = '' ):void {
			if (current != id) {
				if (current) unsetPage(current);
				var page:IPage = getPage(id);
				page.anchor = anchor;
				page.show();
				if (page.transition) page.transition.easeIn((page as IView).component);
				current = id;
			}
		}
		
		public function unsetPage( id:String ):void {
			var page:IPage = getPage(id);
			if (page.transition) page.transition.easeOut((page as IView).component, function():void { page.hide(); } );
			else page.hide();
		}
		
		/**
		 * ENABLE RIGHT CLICK MENU
		 */
		public function setContextMenu():void {
			TopLevel.main.contextMenu = menu.menu;
			SEO.setNav(menu.menus);
		}		
	}
}