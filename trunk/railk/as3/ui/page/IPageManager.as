/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.styleSheet.ICSS;
	public interface IPageManager
	{	
		
		function init( author:String, hasMenu:Boolean, multiPage:Boolean, structure:String, adaptToScreen:Boolean, nameSpace:String ):void;
		function addStatic(id:String, classe:String, layout:ILayout, align:String, onTop:Boolean, visible:Boolean):void;
		function addPage(id:String, parent:String, title:String, classe:String, loading:String, layout:ILayout, align:String, transition:String):void;
		function showAll(id:String, anchor:String = ''):void;
		function goToPage( id:String, anchor:String = '' ):void;
		function getPage( id:String ):IPage;
		function setPage( id:String, anchor:String = '' ):void;
		function unsetPage( id:String ):void
		function enablePage(page:IPage):void;
		function set styleSheet(value:ICSS):void;
		function get styleSheet():ICSS;
	}
}