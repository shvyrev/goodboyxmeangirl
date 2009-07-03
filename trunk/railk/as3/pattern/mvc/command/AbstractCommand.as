/**
* 
* Abstract Command
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.command
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.observer.Notifier;
	
	public class AbstractCommand extends Notifier implements ICommand,INotifier
	{
		protected var _name:String = 'undefined';
		protected var firstAction:Action;
		protected var lastAction:Action;
		
		public function AbstractCommand(name:String='') {
			if(name) _name = name;
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
		
		protected function getAction(name:String):Action {
			var walker:Action = firstAction;
			while ( walker ) {
				if ( walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public function execute( name:String, params:Array = null ):void { (getAction(name) as Function).apply(null, params); }
		
		public function get name():String { return _name; }
	}
}