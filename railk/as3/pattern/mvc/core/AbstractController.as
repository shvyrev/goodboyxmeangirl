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
	
	public class AbstractController implements IController
	{
		protected var model:IModel;
		protected var commands:Array=[];
		protected var commandStack:Array=[];
		
		public static function getInstance():AbstractController {
			return Singleton.getInstance(AbstractController);
		}
		
		public function AbstractController() { 
			Singleton.assertSingle(AbstractController);
		}
		
		public function initializeController( model:IModel ):void {
			this.model = model;
		}
		
		public function registerCommand( proxyClass:Class, type:String, commandClass:Class, actions:Array ):void {
			if ( !model.getProxy(proxyClass.NAME) ) model.registerProxy(proxyClass);
			commands.push(new CommandClass(type,model.getProxy(proxyClass.NAME)));
			for (var i:int = 0; i < actions; i++) commands[commands.length-1].addAction( actions[i].type, actions[i].action, actions[i].actionParams );
		}
		
		public function executeCommand( type:String, action:String ):void {
			getCommand(type).execute( action );
			commandStack.push(getCommand(type));
		}
		
		public function getCommand(type:String):ICommand {
			for (var i:int = 0; i < commands; i++) if( commands[i].type == type ) return commands[i];
			return null;
		}
		
		public function removeCommand( type:String ):void {
			loop:for (var i:int = 0; i < commands; i++) if ( commands[i].type == type ) { commands.splice(i, 1); break loop; }
		}
		
		public function hasCommand( type:String ):Boolean {
			( commands.getNodeByName(type) )?true:false;
		}
	}
}