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
			getBackground(xml);
			getPages(xml);
		}
		
		public function view( page:String ):void { PageManager.getInstance().setPage(page); }
		
		private function getSiteInfo( xml:XML ):void {
			PageManager.getInstance().init(getA('title',xml), Boolean(getA('menu',xml)), getA('model',xml), getA('controller',xml), getA('src',xml));
		}
		
		private function getBackground( xml:XML ):void {
			var bg:XMLList = xml..background;
			if(bg.@id.toString() != '') PageManager.getInstance().setBackground(bg.@id,bg.@view,bg.@src);
		}
		
		private function getPages( xml:XML ):void {
			for each ( var p:XML in xml..page) {
				var title:String = getA('title', p), src:String = getA('src', p);
				var parent:String = (p.parent().localName()=='page')?p.parent().@id:'';
				PageManager.getInstance().addPage(parent,title,getPageLayout( title, new XML(p.child('structure')) ),src );
			}
		}
		
		private function getPageLayout( page:String, xml:XML ):Layout { return LayoutManager.addLayout(page,getBlocChild(xml)); }
		
		private function getBlocChild( child:XML ):Array{
			var result:Array=[];
			for( var i:int=0; i<child.children().length();++i) result[i]= ( child.children()[i].children().length() > 0 )?[child.children()[i],getBlocChild(child.children()[i])]:child.children()[i];
			result.unshift(new XML('<bloc id="dummy'+result[0][0].@id+'" view="railk.as3.ui.layout.utils::Dummy" x="0" y="0" linkId="'+result[0][0].@id+'"/>'));
			return result;
		}
		
		private function getA( name:String, xml:XML ):String {
			for (var i:int=0; i < xml.@*.length(); ++i) if(name == xml.@*[i].name()) return xml.@*[i];
			return '';
		}		
	}	
}