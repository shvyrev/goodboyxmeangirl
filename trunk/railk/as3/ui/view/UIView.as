/**
 * UI VIEW
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.view
{	
	import flash.display.Stage;
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.ui.div.IDiv;
	
	public class UIView extends View implements IView
	{
		private var _style:String;
		public function UIView( MID:String, name:String='',component:*=null, data:*=null ) {
			super(MID, name, component, data);
		}
		
		/**
		 * RESIZE
		 */
		public function resize():void {}
		
		/**
		 * GETTER/SETTER
		 */
		public function get style():String { return _style; }
		public function set style(value:String):void { _style = value; }
		public function get container():IDiv { return _component as IDiv; }
		public function set container(value:IDiv):void { _component = value; }
		public function get stage():Stage { return _component.stage as Stage }
	}
}