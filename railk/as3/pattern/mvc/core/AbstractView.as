/**
* 
* Abstract View
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.utils.RegistrationPoint;
	
	
	public class AbstractView extends RegistrationPoint implements IView
	{
		private var _model:IModel;
		private var _controller:IController;
		
		/**
		 * Create the view for the mvc system.
		 * 
		 * @param model				the model to associate with this view.
		 * @param controller		[Optional] the already created controller to associate with this view.
		 */
		public function AbstractView( model:IModel, controller:IController = null )
		{
			_model = model;
			if( controller != null ) _controller = controller;
		}
	
		public function defaultController():IController
		{
			return null;
		}
		
		public function show():void
		{
			this.visible = true;
		}

		public function hide():void
		{
			this.visible = false;
		}
		
		public function resize():void {
			
		}
	
		public function set model( model:IModel ):void
		{
			_model = model;
		}
		
		public function get model():IModel
		{
			return _model;
		}
		
		public function set controller( controller:IController ):void
		{
			_controller = controller;
		}
		
		public function get controller():IController
		{
			return _controller;
		}
	}	
}