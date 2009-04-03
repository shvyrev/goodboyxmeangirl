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
		protected var firstAction:Action;
		protected var lastAction:Action;
		protected var proxy:IProxy;
		public var type:String;
		
		public function AbstractCommand( type:String,proxy:IProxy ) {
			this.type = type;
			this.proxy = proxy;
		}
		
		public function addAction( type:String, action:Function, actionParams:Array=null ):void {
			var action:Action = new Action(type, action, actionParams);
			if (!firstAction) firstAction = lastAction = action;
			else {
				lastAction.next = action;
				action.prev = lastAction;
				lastAction = action;
			}
		}
		
		public function getAction(type:String):Action {
			var walker:Action = firstAction;
			while ( walker ) {
				if ( walker.type == type ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public function execute( name:String ):void{ getAction(type).apply(); }
	}
}