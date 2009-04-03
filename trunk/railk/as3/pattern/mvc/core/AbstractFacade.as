/**
* 
* MVC Abstract Facade
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.commands.*;
	import railk.as3.pattern.singleton.Singleton;
	
	public class AbstractFacade implements IFacade
	{
		protected var model:IModel;
		protected var controller:IController;
		protected var views:Array = [];
		
		public static function getInstance():AbstractFacade {
			return Singleton.getInstance(AbstractFacade);
		}
		
		public function AbstractFacade() {
			Singleton.assertSingle(AbstractFacade);
		}
		
		public function init( modelClass:Class, controllerClass:Class, viewClasses:Array=null, commands:Array=null ):void {
			this.model = new model();
			this.controller = new Controller(this.model);
			var i:int = 0;
			if ( viewClasses )for ( i = 0; i < viewClasses.length ; i++) { registerView( viewClasses[i].NAME, viewClasses[i] ) }
			if ( commands ) for ( i = 0; i < commands.length ; i++) { registerCommand( commands[i].proxy, commands[i].type, commands[i].classe, commands[i].actions ) }
		}
		
		public function registerView( name:String, viewClass:Class ):void {
			var view:IView = new viewClass( model, controller );
			views.push( view );
		}
		
		public function removeView( name:String ):void {
			loop:for (var i:int = 0; i < views.length ; ++i) {
				if ( views[i].getName() == name ) {
					views.splice(i, 1);
					break loop;
				}
			}
		}
		
		public function getView( name:String ):IView {
			for (var i:int = 0; i < views.length ; ++i) {
				if ( views[i].getName() == name ) return views[i];
			}
			return false;
		}
		
		public function registerCommand( proxyClass:Class, type:String, commandClass:Class, actions:Array ):void {
			this.registerProxy( proxyClass );
			controller.registerCommand( proxyClass, type, commandClass, actions );
		}
		
		public function executeCommand(  type:String, action:String ):void {
			controller.executeCommand( type, action );
		}
		
		public function removeCommand( type:String ):void {
			controller.removeCommand( type );
		}
		
		public function hasCommand( type:String ):Boolean {
			controller.hasCommand( type );
		}
		
		public function registerProxy( proxyClass:Class ):void {
			model.registerProxy( proxyClass );
		}

		public function removeProxy( name:String ):void {
			model.removeProxy( name );
		}
		
		public function hasProxy( name:String ):Boolean {
			model.hasProxy( name );
		}
		
		public function start():void {
		}
	}
}