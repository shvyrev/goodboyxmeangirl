package application.components.component {
	
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.*;
	
	public class Model extends AbstractModel implements IModel {
		
		public function Model():void {
			
		}
		
		override public function start():void {
			
		}
		
		override public function load( type:String, ...args ):void {
			
		}
		
		override public function getData( name:String ):* {
			return this[name];
		}
		
		public function manageEvent(evt:*):void {
			switch(evt.type )
			{
				
			}
		}
	}
}