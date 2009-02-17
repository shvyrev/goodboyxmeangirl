/**
* 
* MVC Abstract Controller
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.data.objectList.ObjectList;
	
	public class AbstractController implements IController
	{
		protected var model:IModel;
		protected var commands:ObjectList = new ObjectList();
		
		public static function getInstance():AbstractController
		{
			return Singleton.getInstance(AbstractController);
		}
		
		public function AbstractController() 
		{ 
			Singleton.assertSingle(AbstractController);
		}
		
		public function initializeController( model:IModel ):void 
		{
			this.model = model;
		}
		
		public function registerCommand( proxy:IProxy, type:String, commandClass:Class, actions:Array ):void
		{
			commands.add([type, new CommandClass(proxy)];
			for (var i:int = 0; i < actions; i++) 
			{
				(commands.tail.data as ICommand).addAction( actions[i].type, actions[i].action, actions[i].actionParams );
			}
		}
		
		public function executeCommand( type:String, action:String ):void
		{
			(commands.getObjectByName( type ).data as ICommand).execute( action );
		}
		
		public function removeCommand( type:String ):void
		{
			commands.remove( type );
		}
		
		public function hasCommand( type:String ):Boolean
		{
			( commands.getObjectByName(type) )?true:false;
		}
	}
}