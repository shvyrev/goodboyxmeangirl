/**
* 
* Abstract Controller
* 
* @author Richard Rodney
*/

package railk.as3.pattern.controller
{
	import railk.as3.pattern.model.AbstractModel;
	import railk.as3.pattern.view.IView;	
	
	public class AbstractController implements IController
	{
		private var model:AbstractModel;
		private var view:IView;
	
		/**
		 * Create the controller for the mvc system.
		 * 
		 * @param	model		the model to associate with this view/controller pair.
		 * @param	view		the view for this controller.
		 */
		public function AbstractController( model:AbstractModel, view:IView )
		{
			this.model = model;
			this.view = view;
		}
		
		/**
		 * The reference to this controller's model.
		 * 
		 * @param model		the model object.
		 */
		public function set model( model:AbstractModel ):void
		{
			this.model = model;
		}
		
		/**
		 * Gets this controller's model.
		 * 
		 * @return Model.
		 */
		public function get model():AbstractModel
		{
			return model;
		}
		
		/**
		 * Sets this controller to associate with the view passed.
		 * 
		 * @param view		IView class object.
		 */
		public function set view( view:IView ):void
		{
			this.view = view;
		}
		
		/**
		 * Gets this controller's view instance.
		 * 
		 * @return IView.
		 */
		public function get view():IView
		{
			return view;
		}
	}
}