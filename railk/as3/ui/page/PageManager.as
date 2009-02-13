/**
 * 
 * Page Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import railk.as3.pattern.mvc.core.AbstractFacade;
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.layout.Layout;
	import railk.as3.data.objectList.ObjectList;
	import railk.as3.data.tree.TreeNode;
	import railk.as3.ui.link.LinkManager;
	
	public class PageManager extends AbstractFacade implements IFacade
	{
		private var index:TreeNode;
		
		public static function getInstance():PageManager 
		{
			return Singleton.getInstance(PageManager);
		}
		
		public function PageManager() 
		{ 
			Singleton.assertSingle(PageManager); 
		}
		
		public function init( siteTitle:String, config:Array ):void
		{
			index = new TreeNode('index');
			LinkManager.init(siteTitle, true, true);
		}
		
		private static function addPage():void
		{
			
		}
		
		public function addDynamicPage( page:AbstractPage, layout:Layout, parent:String=null, ):void
		{
			if ( !parent )
			{
				
			}
			else
			{
				
			}
		}
		
		private static function addToTree(name:String, parent:String, obj:*=null):void {
			if( !treeRoot.getTreeNodeByName(name) )(new TreeNode(name, obj, treeRoot.getTreeNodeByName( parent ) ) );
		}
	}
	
}