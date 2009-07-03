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
		protected var commands:Array=[];
		protected var commandStack:Array=[];
		
		public static function getInstance():AbstractController {
			return Singleton.getInstance(AbstractController);
		}
		
		public function AbstractController() { 
			Singleton.assertSingle(AbstractController);
		}
		
		
		public function registerCommand( commandClass:Class, name:String='' ):void {
			commands[commands.length] = new commandClass(name);
		}
		
		public function executeCommand( name:String, action:String, params:Array=null ):void {
			getCommand(name).execute( action, params );
			commandStack[commandStack.length] = getCommand(name);
		}
		
		public function getCommand(name:String):ICommand {
			for (var i:int = 0; i < commands.length; i++) if( commands[i].name == name ) return commands[i];
			return null;
		}
		
		public function removeCommand( name:String ):void {
			loop:for (var i:int = 0; i < commands.length; i++) if ( commands[i].name == name ) { commands.splice(i, 1); break loop; }
		}
		
		public function hasCommand( name:String ):Boolean {
			return ( commands.getNodeByName(name) )?true:false;
		}
	}
}