/**
 * structure of the website
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.loading.ILoading;
	import railk.as3.ui.page.PageManager;
	
	public class Structure
	{
		public function Structure( xml:XML, loadingView:ILoading=null ) {
			getSiteInfo(xml);
			getBackground(xml);
			getPages(xml,loadingView);
			PageManager.getInstance().setContextMenu();
		}
		
		public function view( page:String ):void { PageManager.getInstance().setPage(page); }
		
		private function getSiteInfo( xml:XML ):void {
			var p:String = A('package',xml)+'::'
			PageManager.getInstance().init(A('author',xml),A('title',xml), Boolean(A('menu',xml)),p+A('model',xml), p+A('controller',xml), A('src',xml));
		}
		
		private function getBackground( xml:XML ):void {
			var b:XMLList = xml..background;
			if(b.@id.toString() != '') PageManager.getInstance().setBackground(b.@id,getPageLayout( A('package',xml), b.@id, new XML(b.child('body')) ),b.@src);
		}
		
		private function getPages( xml:XML, loadingView:ILoading ):void {
			for each ( var p:XML in xml..page) {
				var title:String = A('title', p), src:String = A('src', p);
				var parent:String = (p.parent().localName() == 'page')?p.parent().@id:'';
				PageManager.getInstance().addPage(A('id', p),parent,title,loadingView,getPageLayout( A('package',xml), title, new XML(p.child('body')) ),src );
			}
		}
		
		private function getPageLayout( pack:String, page:String, xml:XML ):Layout { return new Layout(pack,page,xml); }
		
		private function A( name:String, xml:XML ):String {
			for (var i:int=0; i < xml.@*.length(); ++i) if(name == xml.@*[i].name()) return xml.@*[i];
			return '';
		}		
	}	
}