/**
* 
* Abstract Controller
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.data.objectList.ObjectList;
	
	public class AbstractController implements IController
	{
		protected var model:IModel;
		protected var commands:ObjectList;
		
		public function AbstractController()
		{
			commands = new ObjectList();
		}
		
		public function initializeController( model:IModel ):void 
		{
			this.model = model;
		}
		
		public function registerCommand( name:String, commandClass:Class ):void
		{
			
		}
		
		public function executeCommand( name:String ):void
		{
			
		}
		
		public function removeCommand( name:String ):void
		{
			
		}
		
		public function hasCommand( name:String ):Boolean
		{
			
		}
	}
}