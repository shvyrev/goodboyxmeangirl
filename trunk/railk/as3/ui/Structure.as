/**
 * structure of the website
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.layout.LayoutManager;
	import railk.as3.ui.page.PageManager;
	
	public class Structure
	{
		public function Structure( xml:XML ) {
			getSiteInfo(xml);
			getPages(xml);
		}
		
		private function getSiteInfo( xml:XML ):void {
			PageManager.getInstance().init(getA('title',xml), Boolean(getA('menu',xml)), getA('model',xml), getA('controller',xml), getA('src',xml));
		}
		
		private function getPages( xml:XML ):void {
			for each ( var p:XML in xml..page) {
				var title:String = getA('title', p), src:String = getA('src', p);
				var parent:String = (p.parent().localName()=='page')?p.parent().@id:'';
				PageManager.getInstance().addPage(parent,title,getPageLayout( title, new XML(p.child('structure')) ),src );
			}
		}
		
		private function getPageLayout( page:String, xml:XML ):Layout {
			var struct:Array=[];
			for each ( var b:XML in xml..bloc) struct.push(b) 
			return LayoutManager.addLayout(page,struct);
		}
		
		private function getA( name:String, xml:XML ):String {
			for (var i:int=0; i < xml.@*.length(); ++i) if(name == xml.@*[i].name()) return xml.@*[i];
			return '';
		}		
	}	
}