/**
 * Page Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.multiton.Multiton;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.loader.*;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.ui.RightClickMenu;
	import railk.as3.ui.styleSheet.CSS;
	
	public class PageManager extends Facade implements IFacade
	{
		public var index:IPage;
		public var last:IPage;
		public var statics:IStatic;
		public var current:String = '';
		public var anchors:Dictionary = new Dictionary(true);
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var styleSheet:CSS
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
		
		public function init( author:String, hasMenu:Boolean, multiPage:Boolean, structure:String, adaptToScreen:Boolean ):void {
			this.hasMenu = hasMenu;
			this.multiPage = multiPage;
			this.structure = structure;
			this.adaptToScreen = adaptToScreen;
			menu = new RightClickMenu();
			menu.add(author, author, null, null, true);
			registerModel(Model);
			registerController(Controller);
			registerContainer( new PageStruct(structure,adaptToScreen) );
		}
		
		public function addStatic(id:String, classe:String, layout:Layout, align:String, onTop:Boolean, visible:Boolean, src:String):void {
			var s:Static = (classe == '')?new Static(MID, id, layout, align, onTop, src ):new (getDefinitionByName(classe))(MID, id, layout, align, onTop, src );
			if (statics == null ) statics = s;
			else {
				statics.next = s;
				s.prev = statics;
				statics = s;
			}
			if (visible) s.show();
			else {
				registerView(s);
				var action:Function = function(type:String, requester:*, data:*):void {
					switch(type) {
						case 'do': case 'undo' : 
							if (changePage(id, data)) {
								var p:IStatic = (getView(id) as IStatic);
								p.anchor = data;
								p.show();
							}
							break;
						default : break;
					}
				}
				LinkManager.add('/'+id+'/', null, action, '', null, true);
			}
		}
		
		public function addPage(id:String, parent:String, title:String, classe:String, loading:String, layout:Layout, align:String, src:String, transition:String):void {
			if (parent == '') {
				if( !index) registerView( index = last = (classe=='')?new Page(MID,id,null,title,loading,layout,align,src,transition):new (getDefinitionByName(classe))(MID,id,null,title,loading,layout,align,src,transition) );
				else {
					var page:IPage;
					registerView( page = (classe == '')?new Page(MID,id,null,title,loading,layout,align,src,transition):new (getDefinitionByName(classe))(MID,id,null,title,loading,layout,align,src,transition));
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
			multiPageOn = true;
			multiPageId = id;
			multiPageAnchor = anchor;
			index.show();
		}
		
		private function showNext(page:IPage):void {
			if (page.next != null) page.next.show();
			else goToPage(multiPageId, multiPageAnchor);
		}
		
		public function goToPage( id:String, anchor:String = '' ):void {
			var change:String  = changePage(id,anchor);
			if (!change) return; 
			if (current) getPage(current).stop();
			var page:IPage = getPage(id);
			page.anchor = anchor;
			if (change == 'id') (container as PageStruct).goTo(id, page.transition.easeInOut, page.play );
			else page.play();
			current = id;
			anchors[current] = anchor;
		}
		
		/**
		 * SINGLE PAGE NAV
		 */
		public function getPage( id:String ):IPage { return getView(id) as IPage; }
		
		public function setPage( id:String, anchor:String = '' ):void {
			var change:String  = changePage(id,anchor);
			if (!change) return;
			if (current) unsetPage(current);
			var page:IPage = getPage(id);
			page.anchor = anchor;
			page.show();
			if (page.transition && change == 'id') page.transition.easeIn((page as IView).component );
			current = id;
			anchors[current] = anchor;
		}
		
		public function unsetPage( id:String ):void {
			var page:IPage = getPage(id);
			page.stop();
			if (page.transition) page.transition.easeOut((page as IView).component, page.hide );
			else page.hide();
		}
		
		/**
		 * NAV UTILITIES
		 */
		private function changePage(id:String, anchor:String):String {
			if (current != id) return 'id';
			if (current == id && anchors[current] != anchor) return 'anchor';
			return '';
		}
		
		public function enablePage(page:IPage):void {
			if (multiPage) showNext(page);
			else page.play();
		}
		
		/**
		 * STYLESHEET
		 */
		public function setStyleSheet(name:String, css:String):void { styleSheet = new CSS(css, name); }
	}
}