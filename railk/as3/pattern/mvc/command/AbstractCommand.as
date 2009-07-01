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
		public var name:String;
		
		public function AbstractCommand( name:String,proxy:IProxy ) {
			this.name = name;
			this.proxy = proxy;
		}
		
		public function addAction( name:String, action:Function ):void {
			var action:Action = new Action(name, action );
			if (!firstAction) firstAction = lastAction = action;
			else {
				lastAction.next = action;
				action.prev = lastAction;
				lastAction = action;
			}
		}
		
		public function getAction(name:String):Action {
			var walker:Action = firstAction;
			while ( walker ) {
				if ( walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public function execute( name:String, params:Array=null ):void{ getAction(name).apply(null,params); }
	}
}