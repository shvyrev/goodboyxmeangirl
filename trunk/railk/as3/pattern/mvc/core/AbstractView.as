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
	public class AbstractView implements IView
	{
		static public const NAME:String = 'view';
		private var _component:Object;
		
		protected var model:IModel;
		protected var controller:IController;
		
		public function AbstractView( model:IModel, controller:IController, component:Object=null ) {
			this.model = model;
			this.controller = controller;
			_component = component;
		}
		
		public function getName():String { return NAME; }
		
		public function get component():Object { return _component; }
		public function set component(value:Object):void { _component=value; }
		
		public function show():void {
		}
		
		public function hide():void {
		}
		
		public function dispose():void {
		}
	}	
}