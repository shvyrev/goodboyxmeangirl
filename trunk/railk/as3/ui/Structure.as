/**
 * structure of the website
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.page.PageManager;
	
	public class Structure
	{
		/**
		 * 
		 * @param	xml			xml structure of the web site
		 * @param	loadings	loadings Class
		 * @param	views		views Class that extends page and implements IPage for personnal page implementation
		 * @param	commands	commands Class
		 * @param	proxys		proxys Class
		 */
		public function Structure( xml:XML, loadings:Array=null, views:Array=null, commands:Array=null, proxys:Array=null ) {
			getSiteInfo(xml);
			getStatics(xml);
			getPages(xml);
			PageManager.getInstance().setContextMenu();
			if(commands) for (var i:int = 0; i < commands.length; i++) PageManager.getInstance().registerCommand(commands[i].classe, commands[i].name ); 
			if(proxys) for (i = 0; i < proxys.length; i++) PageManager.getInstance().registerProxy(proxys[i].classe, proxys[i].name ); 
		}
		
		public function view( page:String ):void { PageManager.getInstance().setPage(page); }
		
		private function getSiteInfo( xml:XML ):void {
			PageManager.getInstance().init(A('author',xml),A('title',xml),B(A('menu',xml)),B(A('multiPage',xml)),A('structure',xml),B(A('adaptToScreen',xml)));
		}
		
		private function getStatics( xml:XML ):void {
			if ( xml..static.toString() == '' ) return;
			for each ( var s:XML in xml..static) if (s.@id.toString() != '') PageManager.getInstance().addStatic(s.@id,A('class',s,A('package',xml)+'.view::'), getPageLayout( A('package', xml), s.@id, new XML(s.child('body')) ), B(A('onTop',s)), s.@src);
		}
		
		private function getPages( xml:XML ):void {
			for each ( var p:XML in xml..page) {
				var title:String = A('title', p), src:String = A('src', p);
				var parent:String = (p.parent().localName() == 'page')?p.parent().@id:'';
				PageManager.getInstance().addPage(A('id', p),parent,title,A('class',p,A('package',xml)+'.view::'),A('loading',p,A('package',xml)+'.loading::'),getPageLayout( A('package',xml), title, new XML(p.child('body')) ),A('align',p),src,A('package',xml)+'.transition.'+A('transition',p));
			}
		}
		
		private function getPageLayout( pack:String, page:String, xml:XML ):Layout { return new Layout(pack,page,xml); }
		
		private function A( name:String, xml:XML, pack:String='' ):String {
			for (var i:int=0; i < xml.@*.length(); ++i) if(name == xml.@*[i].name()) return pack+xml.@*[i];
			return '';
		}
		
		private function B( value:String ):Boolean { return (value == 'true')?true:false; }
		
		public function get container():* { return PageManager.getInstance().container; } 
	}	
}