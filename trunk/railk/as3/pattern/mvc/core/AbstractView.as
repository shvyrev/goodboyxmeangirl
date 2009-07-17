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
		protected var _data:*;
		
		public function AbstractView( MID:String, name:String='',component:*=null ) {
			this.MID = MID;
			if (name) _name = name;
			_component = component;
			facade.addEventListener(Notification.NOTE, handleNotification );
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
		
		public function get name():String { return _name; }
		public function get component():* { return _component; }
		public function set component(value:*):void { _component = value; }
		public function get data():* { return _data; }
		public function set data(value:*):void { _data = value; }
	}	
}