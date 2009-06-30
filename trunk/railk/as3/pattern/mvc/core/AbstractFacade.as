﻿/**
* 
* MVC Abstract Facade
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.command.*;
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
		
		public function registerModel( modelClass:Class ):void {
			model = modelClass.getInstance.apply();
		}
		
		public function registerController( controllerClass:Class ):void {
			controller = controllerClass.getInstance.apply();
			if (model) controller.initialize(model);
			else throw new Error('model must be registered first');
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
	}
}