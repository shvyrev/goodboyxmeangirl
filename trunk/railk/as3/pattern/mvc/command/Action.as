/**
 * 
 * commands pattern action
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.pattern.mvc.command
{
	public class Action 
	{
		public var next:Action;
		public var prev:Action;
		
		public var name:String;
		public var action:Function;
		public var actionParams:Array=[];
		
		public function Action(name:String,action:Function,actionParams:Array) {
			this.name= name;
			this.action = action;
			this.actionParams = actionParams;
		}
		
		public function apply():void { action.apply(null, actionParams); }
	}
	
}