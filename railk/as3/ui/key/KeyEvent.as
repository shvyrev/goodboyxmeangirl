package railk.as3.ui.key {
	
	import flash.events.Event;
	
	public dynamic class KeyEvent extends Event{
			
		static public const ON_KEY_PRESS	                   	 :String = "onKeyPress";
		static public const ON_KEY_RELEASE                   	 :String = "onKeyRelease";
		
		public function KeyEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
	}
}