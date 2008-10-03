package application.components.component {
	
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.*;
	
	public class Controller extends AbstractController implements IController {
		
		public function Controller(model:IModel, view:IView):void {
			super(model, view);
		}
	}
}