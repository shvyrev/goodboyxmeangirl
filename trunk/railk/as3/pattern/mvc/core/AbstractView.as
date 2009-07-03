/**
* 
* MVC Abstract View
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.observer.Notifier;
	import railk.as3.pattern.mvc.interfaces.*;	
	public class AbstractView extends Notifier implements IView,INotifier
	{
		static public const NAME:String = 'view';
		protected var _component:*;
		
		public function AbstractView( component:*=null ) {
			_component = component;
		}
		
		public function getName():String { return NAME; }
		
		public function get component():* { return _component; }
		public function set component(value:*):void { _component=value; }
		
		public function show():void {
		}
		
		public function hide():void {
		}
		
		public function dispose():void {
		}
	}	
}