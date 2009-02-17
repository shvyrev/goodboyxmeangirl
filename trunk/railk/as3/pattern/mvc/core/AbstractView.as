/**
* 
* MVC Abstract View
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.display.RegistrationPoint;
	
	
	public class AbstractView extends RegistrationPoint implements IView
	{
		static public const NAME:String = 'view';
		
		protected var model:IModel;
		protected var controller:IController;
		
		public function AbstractView( model:IModel, controller:IController )
		{
			this.model = model;
			this.controller = controller;
		}
		
		public function getName():String
		{
			return NAME;
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			
		}
		
		public function dispose():void
		{
		}
	}	
}