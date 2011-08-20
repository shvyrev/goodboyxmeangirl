/**
 * structure of the website
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.ui.page.PageManager;
	import railk.as3.ui.page.Plugins;
	import railk.as3.ui.loader.*;
	import railk.as3.ui.styleSheet.CSS;
	import railk.as3.TopLevel;
	
	public class Structure
	{
		private var pageManager:PageManager = PageManager.getInstance();
		public static function getInstance():Structure{
			return Singleton.getInstance(Structure);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Structure() { Singleton.assertSingle(Structure); }
		
		/**
		 * INIT
		 * @param	xml			xml structure of the web site
		 * @param	loadings	loadings Class
		 * @param	views		views Class that extends page and implements IPage for personnal page implementation
		 * @param	commands	commands Class
		 * @param	proxys		proxys Class
		 */
		public function init( container:*, xml:XML, plugins:String='', loadings:Array = null, transitions:Array=null, views:Array = null, commands:Array = null, proxys:Array = null ):void {
			pageManager.init(A('author', xml), B(A('menu', xml)), B(A('multiPage', xml)), A('structure', xml), B(A('adaptToScreen', xml)), A('package',xml));
			container.addChild( pageManager.container );
			if (commands) for (var i:int = 0; i < commands.length; i++) pageManager.registerCommand(commands[i].classe, commands[i].name ); 
			if (proxys) for (i = 0; i < proxys.length; i++) pageManager.registerProxy(proxys[i].classe, proxys[i].name );
			var css:String = A('stylesheet', xml);
			if (css) loadUI(((TopLevel.local)?'../':'')+css).file(setup, container, xml, plugins, UILoader.FILE).start();
			else setup(container, xml, plugins);
		}
		
		private function setup(container:*, xml:XML, plugins:String = '', css:String = ''):void {
			if (css) pageManager.styleSheet = new CSS(css, A('author', xml));
			Plugins.getInstance().init(plugins);
			LinkManager.getInstance().init( A('title', xml), true, true).addGroup('main_menu', true);
			getBlocks(xml);
			getPages(xml);
			container.contextMenu = pageManager.menu.menu;
		}
		
		private function getBlocks( xml:XML ):void {
			if ( xml..block.toString() == '' ) return;
			for each ( var s:XML in xml..block) if (s.@id.toString() != '') pageManager.addBlock(s.@id,A('id',s,A('package',xml)+'.view::'), getPageLayout( A('package', xml)+'.view.'+s.@id, s.@id, new XML(s.child('body')) ),A('align',s), B(A('onTop',s)), B(A('visible',s)));
		}
		
		private function getPages( xml:XML ):void {
			for each ( var p:XML in xml..page) {
				var title:String = A('title', p);
				var parent:String = (p.parent().localName() == 'page')?p.parent().@id:'';
				pageManager.addPage(A('id', p),parent,title,A('id',p,A('package',xml)+'.view::'),A('loading',p,A('package',xml)+'.loading::'),getPageLayout( A('package',xml)+'.view.'+A('id', p), title, new XML(p.child('body')) ),A('align',p),A('package',xml)+'.transition.'+A('transition',p));
			}
		}
		
		private function getPageLayout( pack:String, page:String, xml:XML ):Layout { return new Layout(pack,page,xml); }
		
		private function A( name:String, xml:XML, pack:String='' ):String {
			for (var i:int=0; i < xml.@*.length(); ++i) if(name == xml.@*[i].name()) return (pack)?pack+C(xml.@*[i]):xml.@*[i];
			return '';
		}
		
		private function B( value:String ):Boolean { return (value == 'true')?true:false; }
		private function C( value:String ):String { return value.charAt().toUpperCase()+value.substring(1);  }
		public function view( page:String ):void { LinkManager.getInstance().setValue(page); }
	}	
}