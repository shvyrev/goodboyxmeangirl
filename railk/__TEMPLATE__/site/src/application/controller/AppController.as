package application.controller {
	
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.*;
	
	public class AppController extends AbstractController implements IController {
		
		public function AppController(model:IModel, view:IView):void {
			super(model, view);
		}
	}
}