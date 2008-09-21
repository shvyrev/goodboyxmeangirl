/**
* 
* Abstract View
* 
* @author Richard Rodney
*/

package railk.as3.pattern.view
{
	import railk.as3.pattern.model.IModel;
	import railk.as3.pattern.controller.IController;	
	import railk.as3.pattern.view.IView;
	import railk.as3.utils.DynamicRegistration;
	
	
	public class AbstractView extends DynamicRegistration implements IView
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
			if( _controller != null ) _controller = controller;
		}
	
		/**
		 * Creates an abstract default controller. If a view handles user input, 
		 * this method MUST be overwritten. Otherwise the call will scope up 
		 * to the abstract view creating a null controller.
		 *
		 * @return IController;
		 */
		public function defaultController():IController
		{
			return null;
		}
	
		/**
		 * Sets this view's model.
		 * 
		 * @param model		the model object.
		 */
		public function set model( model:IModel ):void
		{
			_model = model;
		}
		
		/**
		 * Gets this view's model.
		 * 
		 * @return Model.
		 */
		public function get model():IModel
		{
			return _model;
		}
		
		/**
		 * Sets the controller to associate with this view.
		 * 
		 * @param controller	IController class object.
		 */
		public function set controller( controller:IController ):void
		{
			_controller = controller;
		}
		
		/**
		 * Gets the view's controller instance.
		 * 
		 * @return IController.
		 */
		public function get controller():IController
		{
			return _controller;
		}
	}	
}