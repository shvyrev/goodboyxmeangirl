/**
* 
* Abstract Command
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.commands
{
	import railk.as3.data.objectList.ObjectNode;
	import railk.as3.data.objectList.ObjectList
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.commands.*;
	
	public class AbstractCommand implements ICommand
	{
		protected var actions:ObjectList;
		protected var view:IView;
		protected var model:IModel;
		
		public function AbstractCommand( view:IView, model:IModel )
		{
			this.view = view;
			this.model = model;
			actions = new ObjectList();
		}
		
		public function addAction( type:String, action:Function, actionParam:Array=null ):void
		{
			actions.add([type, null, '', action, {actionParam:actionParam}]);
		}
		
		public function execute( name:String ):void
		{
			var node:ObjectNode = actions.getObjectByName( name );
			node.action.apply(null, node.args.actionParam);
		}
		
	}
}