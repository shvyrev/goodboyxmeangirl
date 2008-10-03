package application.components.component {
	
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.*;
	
	public class View extends AbstractView implements IView {
		
		public function View( model:IModel, controller:IController=null ):void {
			super(model, controller);
		}
		
		public function show():void {
			
		}
		
		public function hide():void {
			
		}
		
		private function manageEvent(evt:*):void {
			switch(evt.type)
			{
				
			}
		}	
	}
}