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
		
		protected function registerView( name:String, view:IView ):void
		{
			viewsList.add( [name, view] );
		}
		
		protected function removeView( name:String ):void
		{
			viewsList.remove( name );
		}
		
		protected function getView( name:String ):void
		{
			viewsList.getObjectByName( name );
		}
		
		protected function registerCommand( name:String, commandClass:Class ):void
		{
			controller.registerCommand( name, commandClass );
		}
		
		protected function removeCommand( name:String ):void
		{
			controller.removeCommand( name );
		}
		
		protected function hasCommand( name:String ):Boolean
		{
			controller.hasCommand( name );
		}
	}
}