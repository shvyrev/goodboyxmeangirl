/**
* 
* Abstract View
* 
* @author Richard Rodney
*/

package railk.as3.pattern.view
{
	import flash.display.Sprite;
	import railk.as3.pattern.model.AbstractModel;
	import railk.as3.pattern.controller.IController;	
	import railk.as3.pattern.view.IView;
	
	
	public class AbstractView extends Sprite implements IView
	{
		private var model:AbstractModel;
		private var controller:IController;
		
		/**
		 * Create the view for the mvc system.
		 * 
		 * @param model				the model to associate with this view.
		 * @param controller		[Optional] the already created controller to associate with this view.
		 */
		public function AbstractView( model:AbstractModel, controller:IController = null )
		{
			this.model = model;
			if( this.ontroller != null ) this.controller = controller;
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
		public function set model( model:AbstractModel ):void
		{
			this.model = model;
		}
		
		/**
		 * Gets this view's model.
		 * 
		 * @return Model.
		 */
		public function get model():AbstractModel
		{
			return model;
		}
		
		/**
		 * Sets the controller to associate with this view.
		 * 
		 * @param controller	IController class object.
		 */
		public function set controller( controller:IController ):void
		{
			this.controller = controller;
		}
		
		/**
		 * Gets the view's controller instance.
		 * 
		 * @return IController.
		 */
		public function get controller():IController
		{
			return controller;
		}
	}	
}