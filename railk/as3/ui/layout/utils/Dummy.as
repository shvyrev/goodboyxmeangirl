package railk.as3.ui.layout.utils
{
	import railk.as3.display.DSprite;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.*;
	public class Dummy extends AbstractView implements IView 
	{
		public function Dummy( model:IModel, controller:IController ) {
			super(model, controller);
			component = new DSprite();
		}	
	}
}