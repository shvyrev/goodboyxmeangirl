/**
* 
* Abstract Controller
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.commands.*;
	import railk.as3.data.objectList.ObjectList
	
	public class AbstractFacade implements IFacade
	{
		protected var model:IModel;
		protected var controller:IController;
		protected var viewsList:ObjectList;
		
		public function AbstractFacade()
		{
			views = new ObjectList();
		}
		
		protected function init( modelClass:Class, controllerClass:Class ):void
		{
			this.model = new model();
			this.controller = new Controller(this.model);
		}
		
		protected function registerView( name:String, viewClass:Class ):void
		{
			var view:IView = new viewClass( model, controller );
			viewsList.add( [name, view] );
		}
		
		protected function removeView( name:String ):void
		{
			viewsList.remove( name );
		}
		
		protected function getView( name:String ):IView
		{
			viewsList.getObjectByName( name ).data;
		}
		
		protected function registerCommand( view:String, type:String, commandClass:Class ):void
		{
			controller.registerCommand( view, type, commandClass );
		}
		
		protected function removeCommand( type:String ):void
		{
			controller.removeCommand( type );
		}
		
		protected function hasCommand( type:String ):Boolean
		{
			controller.hasCommand( type );
		}
	}
}