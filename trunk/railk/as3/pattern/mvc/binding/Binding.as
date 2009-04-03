/**
 * Binding for MVC pattern
 * 
 * @author Richard Rodney
 * @version 0.1
 */


package railk.as3.pattern.mvc.binding 
{
	import railk.as3.pattern.mvc.event.ModelEvent;
	import railk.as3.pattern.mvc.interfaces.*;

    public class Binding 
	{
		static public var bindings:Array=[]
		
	   	private var _proxy:IProxy;
		private var _eventType:String;
		private var _data:String;
		private var _view:IView;
		private var _action:Function;
		private var _isBound:Boolean = false;
		
		
		static public function create( proxy:IProxy, eventType:String, data:String, view:IView, action:Function  ):Binding {
			return new Binding( proxy, eventType, data, view, action );
		}
		
		static public function remove( view:IView ):void {
			loop:for (var i:int = 0; i < bindings; i++) {
				if ( view.getName() == bindings[i].view.getName()) {
					bindings.splice(i, 1);
					break loop;
				}
			}
		}
		
		static public function getBinding( view:IView ):Binding {
			loop:for (var i:int = 0; i < bindings; i++) {
				if ( view.getName() == bindings[i].view.getName()) return bindings[i];
			}
			return null;
		}
	
		
		public function Binding( proxy:IProxy, eventType:String, data:String, view:IView, action:Function  ) {
			_action = action;
			_proxy = proxy;
			_eventType = eventType;
			_data = data;
			_view = view;
			_isBound = true;
			
			/////////////////////////////////////////////////////////////////////
			_proxy.addEventListener( _eventType, manageEvent, false, 0, true );	
			bindings.push(this);
			/////////////////////////////////////////////////////////////////////
		}
		
		
		private function executeBinding() : void {			
			if (_view == null && _action == null) ) stopBinding();
			else if (_action != null) {				
				try { 
					_action.call( _target, _proxy.getData(data) ); 
				} catch (e1:ArgumentError) {
					trace('[Binding Error > Callback Argument Error ]');
				}
			}
		}
		
		public function stopBinding():void {
			_proxy.removeEventListener( _eventType, manageEvent, false );
			_isBound = false;
		}
		
		
		private function manageEvent( evt:ModelEvent ):void {
			if (evt.type == _eventType) executeBinding();
		}
		
		
		public function get view():IView { return _view; }
		public function get proxy():IProxy { return _proxy; }
		public function get eventType():String { return _eventType; }
		public function get bound():Boolean { return _isBound; }
		static public function get totalBindings():int { return bindings.length; }
    }
}
