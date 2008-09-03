package railk.as3.tween.process.utils {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.utils.getTimer;
	public class HybridTicker extends EventDispatcher implements ITicker {
		
		protected var shape:Shape;
		public function HybridTicker():void {
			shape = new Shape()
			shape.addEventListener(Event.ENTER_FRAME,tick);
		}
		
		public function get position():Number { return getTimer()/1000; }
		
		public function get interval():Number { return 1; }
		
		protected function tick(evt:Event):void { dispatchEvent(new Event("tick"));}
	}
}