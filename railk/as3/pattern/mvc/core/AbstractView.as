﻿/**
* 
* MVC Abstract View
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.observer.*
	import railk.as3.pattern.mvc.interfaces.*;	
	public class AbstractView extends Notifier implements IView,INotifier
	{
		protected var _name:String = 'undefined';
		protected var _component:*;
		
		public function AbstractView( name:String='',component:*=null ) {
			facade.addEventListener(Notification.NOTE, handleNotification );
			if (name) _name = name;
			_component = component;
		}
		
		public function handleNotification(evt:Notification):void {
		}
		
		public function show():void {
		}
		
		public function hide():void {
		}
		
		public function dispose():void {
			facade.removeEventListener(Notification.NOTE, handleNotification);
		}
		
		public function get component():* { return _component; }
		public function set component(value:*):void { _component = value; }
		public function get name():String { return _name; }
	}	
}