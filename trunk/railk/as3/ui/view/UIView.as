/**
 * UI VIEW
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.view
{	
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.pattern.mvc.core.View;
	public class UIView extends View implements IView
	{
		private var _style:String;
		public function UIView( MID:String, name:String='',component:*=null, data:*=null ) {
			super(MID, name, component, data);
		}
		
		public function get style():String { return _style; }
		public function set style(value:String):void { _style = value; }
	}
}