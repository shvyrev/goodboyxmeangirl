/**
* 
* Abstract View
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.display.RegistrationPoint;
	
	
	public class AbstractView extends RegistrationPoint implements IView
	{
		protected var model:IModel;
		protected var controller:IController;
		
		public function AbstractView( model:IModel, controller:IController )
		{
			this.model = model;
			this.controller = controller;
		}
		
		public function dispose():void
		{
		}
	}	
}