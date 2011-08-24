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
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.loader.*;
	import railk.as3.ui.link.*;
	import railk.as3.ui.RightClickMenu;
	import railk.as3.ui.styleSheet.ICSS;
	import railk.as3.ui.view.UIView;
	import railk.as3.utils.hasDefinition;
	
	public class PageManager extends Facade implements IFacade,IPageManager
	{
		public var index:IPage;
		public var last:IPage;
		public var blocks:IBlock;
		public var current:String = '';
		public var anchors:Dictionary = new Dictionary(true);
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var multiPage:Boolean;
		public var structure:String;
		public var adaptToScreen:Boolean;
		public var nameSpace:String;
		
		private var multiPageOn:Boolean;
		private var multiPageId:String;
		private var multiPageAnchor:String;
		
		private var _styleSheet:ICSS;
		private var _linkManager:ILinkManager = LinkManager.getInstance();
		private var _loadingView:IPageLoading;
		
		public static function getInstance():PageManager {
			return Multiton.getInstance('S',PageManager);
		}
		
		public function PageManager(id:String) {
			super(id);
			MID = Multiton.assertSingle(id,PageManager); 
		}
		
		public function init( author:String, hasMenu:Boolean, multiPage:Boolean, structure:String, loading:String, adaptToScreen:Boolean, nameSpace:String ):void {
			this.hasMenu = hasMenu;
			this.multiPage = multiPage;
			this.structure = structure;
			this.adaptToScreen = adaptToScreen;
			this.nameSpace = nameSpace;
			menu = new RightClickMenu();
			menu.add(author, author);
			registerModel(Model);
			registerController(Controller);
			registerContainer( new PageStruct(structure, adaptToScreen) );
			if (loading) _loadingView = new (getDefinitionByName(loading))() as IPageLoading;
		}
		
		public function addBlock(id:String, classe:String, layout:ILayout, align:String, onTop:Boolean, visible:Boolean):void {
			var b:Block = !hasDefinition(classe)?new Block(MID, id, layout, align, onTop, visible):new (getDefinitionByName(classe))(MID, id, layout, align, onTop, visible);
			if (!blocks) blocks = b;
			else {
				blocks.next = b;
				b.prev = blocks;
				blocks = b;
			}
			if (visible) b.show();
			else {
				registerView(b);
				var action:Function = function(type:String, requester:*, data:*):void {
					switch(type) {
						case 'do': 
							if (changePage(id, data)) {
								var p:IBlock = (getView(id) as IBlock);
								p.anchor = data;
								p.show();
							}
							break;
						default : break;
					}
				}
				_linkManager.add('/'+id+'/', null, action, '', '', null, true);
			}
		}
		
		public function addPage(id:String, parent:String, title:String, classe:String, layout:ILayout, align:String, transition:String):void {
			if (parent == '') {
				if( !index) registerView( index = last = !hasDefinition(classe)?new Page(MID,id,null,title,layout,align,transition):new (getDefinitionByName(classe))(MID,id,null,title,layout,align,transition) );
				else {
					var page:IPage;
					registerView( page = !hasDefinition(classe)?new Page(MID,id,null,title,layout,align,transition):new (getDefinitionByName(classe))(MID,id,null,title,layout,align,transition));
					last.next = page; page.prev = last; last = page;
				}
			} else {
				registerView( (!hasDefinition(classe)?new Page(MID,id, getPage(parent),title,layout,align,transition):new (getDefinitionByName(classe))(MID,id, getPage(parent),title,layout,align,transition)) );
				getPage(parent).addChild(getPage(id));
			}
			
			//link
			var link:String='', prt:IPage=getPage(parent);
			while (prt) { link=(prt.id!='index')?prt.id+'/'+link:'/'+link; prt=prt.parent; }
			link+=(id!='index')?'/'+id+'/':'/';
			var action:Function = function(type:String, requester:*, data:*):void {
				switch(type) {
					case 'do':
						if ( !multiPageOn && multiPage ) showAll(id,data);
						else (multiPage)?goToPage(id,data):setPage(id,data);
						break;
					default : break;
				}
			}
			menu.add(id, '-> '+title, _linkManager.setValue, [link], ((id == 'index')?true:false) );
			_linkManager.add(link, null, action, title, _MID, null, true);
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
			if (blocks) updateBlocks();
		}
		
		/**
		 * SINGLE PAGE NAV
		 */
		public function getPage( id:String ):IPage { return getView(id) as IPage; }
		
		public function setPage( id:String, anchor:String = '' ):void {
			var change:String  = changePage(id, anchor);
			if (!change) return;
			if (current) unsetPage(current);
			var page:IPage = getPage(id);
			page.anchor = anchor;
			page.show();
			if (page.transition && change == 'id') page.transition.easeIn((page as IView).component );
			current = id;
			anchors[current] = anchor;
			if (blocks) updateBlocks();
		}
		
		public function unsetPage( id:String ):void {
			var page:IPage = getPage(id);
			page.stop();
			if (page.transition) page.transition.easeOut((page as IView).component, page.hide );
			else page.hide();
		}
		
		/**
		 * UI VIEWS
		 */
		public function getUIView(name:String):UIView { return getView(name) as UIView; }
		
		/**
		 * NAV UTILITIES
		 */
		private function changePage(id:String, anchor:String = ''):String {
			if (current != id) return 'id';
			if (current == id && anchors[current] != anchor) return 'anchor';
			return '';
		}
		
		public function enablePage(page:IPage):void {
			if (multiPage) showNext(page);
			else page.play();
		}
		
		private function updateBlocks():void {
			var s:IBlock = blocks;
			while (s) { 
				if (s.visible) s.update();
				s = s.prev;
			}
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function set styleSheet(value:ICSS):void { _styleSheet = value; }
		public function get styleSheet():ICSS { return _styleSheet; }
		public function get linkManager():ILinkManager { return _linkManager; }
		public function get loadingView():IPageLoading { return _loadingView; }
	}
}