/**
* 
* Abstract Controller
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.*;
	
	public class AbstractController implements IController
	{
		private var _model:IModel;
		private var _view:IView;
	
		/**
		 * Create the controller for the mvc system.
		 * 
		 * @param	model		the model to associate with this view/controller pair.
		 * @param	view		the view for this controller.
		 */
		public function AbstractController( model:IModel, view:IView )
		{
			_model = model;
			_view = view;
		}
		
		public function getAction(action:String):Function {
			return this[action];
		}
		
		/**
		 * The reference to this controller's model.
		 * 
		 * @param model		the model object.
		 */
		public function set model( model:IModel ):void
		{
			_model = model;
		}
		
		/**
		 * Gets this controller's model.
		 * 
		 * @return Model.
		 */
		public function get model():IModel
		{
			return _model;
		}
		
		/**
		 * Sets this controller to associate with the view passed.
		 * 
		 * @param view		IView class object.
		 */
		public function set view( view:IView ):void
		{
			_view = view;
		}
		
		/**
		 * Gets this controller's view instance.
		 * 
		 * @return IView.
		 */
		public function get view():IView
		{
			return _view;
		}
	}
}