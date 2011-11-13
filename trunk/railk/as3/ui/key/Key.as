package railk.as3.ui.key {
   
	// _________________________________________________________________________________________ IMPORT FLASH
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
   
    public class Key extends EventDispatcher {
		
		// _______________________________________________________________________________________ CONSTANTES
		public static const CTRL:uint = 17;
		public static const SPACEBAR:uint = 32;
		public static const SHIFT:uint = 16;
		public static const TAB:uint = 9;
		public static const DEL:uint = 46;
		public static const C:uint = 67;
		public static const V:uint = 86;
		public static const A:uint = 65;
		public static const Z:uint = 90;
		public static const S:uint = 83;
       
		// _______________________________________________________________________________________ VARIABLES
		protected static var disp:EventDispatcher;
        private static var _initialized:Boolean = false;
        private static var keysDown:Object = new Object();
       
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   							 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public static function initialize(stage:Stage):void {
            if (!_initialized) {
                stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
                stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
                stage.addEventListener(Event.DEACTIVATE, clearKeys);
                _initialized = true;
            }
        }
       
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   						 KEY DOWN 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        public static function isDown(keyCode:uint):Boolean {
            if (!_initialized) {
                throw new Error("Key class has yet been initialized.");
            }
            return keysDown[keyCode];
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   				   KEY MANAGEMENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
        private static function keyPressed(evt:KeyboardEvent):void {
            keysDown[evt.keyCode] = true;
			dispatchEvent( new KeyEvent(KeyEvent.ON_KEY_PRESS, { keyCode:evt.keyCode, alt:evt.altKey, ctrl:evt.ctrlKey, shift:evt.shiftKey }) );
        }
       
        private static function keyReleased(evt:KeyboardEvent):void {
            if (evt.keyCode in keysDown) {
                delete keysDown[evt.keyCode];
            }
			dispatchEvent( new KeyEvent(KeyEvent.ON_KEY_RELEASE, { keyCode:evt.keyCode, alt:evt.altKey, ctrl:evt.ctrlKey, shift:evt.shiftKey }) );
        }
       
        private static function clearKeys(evt:Event):void {
            keysDown = new Object();
        }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   				 	GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		static public function get initialized():Boolean { return _initialized; }
    }
}