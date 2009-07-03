/**
* 
* MVC Abstract Facade
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import flash.events.EventDispatcher;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.command.*;
	import railk.as3.pattern.mvc.observer.*;
	import railk.as3.pattern.singleton.Singleton;
	
	public class AbstractFacade extends EventDispatcher implements IFacade
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
		
		public function registerModel( modelClass:Class ):void {
			model = modelClass.getInstance.apply();
		}
		
		public function registerController( controllerClass:Class ):void {
			controller = controllerClass.getInstance.apply();
		}
		
		public function registerView( view:IView ):void {
			views.push( view );
		}
		
		public function removeView( name:String ):void {
			loop:for (var i:int = 0; i < views.length ; ++i) if ( views[i].getName() == name ) { views.splice(i, 1); break loop; }
		}
		
		public function getView( name:String ):IView {
			for (var i:int = 0; i < views.length ; ++i) if ( views[i].getName() == name ) return views[i];
			return null;
		}
		
		public function registerCommand(name:String, commandClass:Class, actions:Array = null):void { 
			controller.registerCommand(name, commandClass, actions); 
		}
		
		public function executeCommand(name:String, action:String, params:Array = null ):void { 
			controller.executeCommand(name, action, params); 
		}
		
		public function removeCommand(name:String):void { 
			controller.removeCommand(name); 
		}
		
		public function registerProxy(proxyClass:Class):void { 
			model.registerProxy(proxyClass); 
		}
		
		public function getProxy(name:String):void { 
			model.getProxy(name); 
		}
		
		public function removeProxy(name:String):void { 
			model.removeProxy(name); 
		}
		
		public function sendNotification(type:String, info:String, data:*=null):void {
			dispatchEvent( new Notification( type, {info:info, data:data} ) );
		}
	}
}