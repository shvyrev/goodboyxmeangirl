/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.link.ILinkManager;
	import railk.as3.ui.styleSheet.ICSS;
	import railk.as3.ui.view.UIView;
	public interface IPageManager
	{	
		function init( author:String, hasMenu:Boolean, multiPage:Boolean, structure:String, loading:String, adaptToScreen:Boolean, nameSpace:String ):void;
		function addBlock(id:String, classe:String, layout:ILayout, align:String, onTop:Boolean, visible:Boolean):void;
		function addPage(id:String, parent:String, title:String, classe:String, layout:ILayout, align:String, transition:String):void;
		function showAll(id:String, anchor:String = ''):void;
		function goToPage( id:String, anchor:String = '' ):void;
		function getPage( id:String ):IPage;
		function setPage( id:String, anchor:String = '' ):void;
		function unsetPage( id:String ):void
		function enablePage(page:IPage):void;
		function getUIView( name:String ):UIView;
		function set styleSheet(value:ICSS):void;
		function get styleSheet():ICSS;
		function get linkManager():ILinkManager;
		function get loadingView():IPageLoading;
	}
}