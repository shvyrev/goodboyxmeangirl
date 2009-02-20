/**
* 
* Abstract Command
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.command
{
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	import railk.as3.pattern.mvc.interfaces.*;
	
	public class AbstractCommand implements ICommand
	{
		protected var actions:DLinkedList;
		protected var proxy:IProxy;
		
		public function AbstractCommand( proxy:IProxy )
		{
			this.proxy = proxy;
			actions = new DLinkedList();
		}
		
		public function addAction( type:String, action:Function, actionParam:Array=null ):void
		{
			actions.add([type, null, '', action, {actionParam:actionParam}]);
		}
		
		public function execute( name:String ):void
		{
			var node:ObjectNode = actions.getNodeByName( name );
			node.action.apply(null, node.args.actionParam);
		}
		
	}
}