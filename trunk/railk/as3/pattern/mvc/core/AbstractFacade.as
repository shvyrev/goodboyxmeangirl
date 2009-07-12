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
		protected var container:*;
		protected var model:IModel;
		protected var controller:IController;
		protected var views:Array = [];
		
		public static function getInstance():AbstractFacade {
			return Singleton.getInstance(AbstractFacade);
		}
		
		public function AbstractFacade() {
			Singleton.assertSingle(AbstractFacade);
		}
		
		public function registerContainer(container:*):void {
			this.container = container;
		}
		
		public function addChild(child:*):* { return container.addChild(child); }
		public function removeChild(child:*):* { return container.removeChild(child); }
		
		public function registerModel( modelClass:Class ):void {
			model = modelClass.getInstance.apply();
		}
		
		public function registerController( controllerClass:Class ):void {
			controller = controllerClass.getInstance.apply();
		}
		
		public function registerView( view:*, name:String = '', component:*= null ):void {
			if (view is Class) views[views.length] = new view(name, component);
			else views[views.length] = view;
		}
		
		public function removeView( name:String ):void {
			loop:for (var i:int = 0; i < views.length ; ++i) if ( views[i].name == name ) { views.splice(i, 1); break loop; }
		}
		
		public function getView( name:String ):IView {
			for (var i:int = 0; i < views.length ; ++i) if ( views[i].name == name ) return views[i];
			return null;
		}
		
		public function registerCommand(commandClass:Class, name:String=''):void { 
			controller.registerCommand(commandClass, name);
		}
		
		public function executeCommand(name:String, action:String, ...args ):void { 
			controller.executeCommand(name, action, args); 
		}
		
		public function removeCommand(name:String):void { 
			controller.removeCommand(name); 
		}
		
		public function registerProxy(proxyClass:Class,name:String=''):void { 
			model.registerProxy(proxyClass, name);
		}
		
		public function getProxy(name:String):IProxy { 
			return model.getProxy(name); 
		}
		
		public function removeProxy(name:String):void { 
			model.removeProxy(name); 
		}
		
		public function sendNotification(note:String, info:String, data:*=null):void {
			dispatchEvent( new Notification( note, info, data ) );
		}
	}
}