/**
 * UI VIEW
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.view
{	
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.ui.div.IDiv;
	import railk.as3.utils.hasDefinition;
	
	public class UIView extends View implements IView
	{
		private var _style:String;
		private var _nameSpace:String;
		public function UIView( MID:String, name:String='',component:*=null, data:*=null ) {
			super(MID, name, component, data);
		}
		
		/**
		 * GET CLASS
		 */
		public function classe(name:String):Class {
			name = name.charAt()+name.substring(1);
			return hasDefinition(name)?getDefinitionByName(name):null; 
		}
		
		/**
		 * RESIZE
		 */
		public function resize():void {}
		
		/**
		 * GETTER/SETTER
		 */
		public function get nameSpace():String { return _nameSpace; } 
		public function set nameSpace(value:String):void { _nameSpace = value; } 
		public function get style():String { return _style; }
		public function set style(value:String):void { _style = value; }
		public function get container():IDiv { return _component as IDiv; }
		public function set container(value:IDiv):void { _component = value; }
		public function get stage():Stage { return _component.stage as Stage }
	}
}