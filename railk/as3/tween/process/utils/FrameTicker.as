package railk.as3.tween.process.utils
{
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	public class FrameTicker extends EventDispatcher implements ITicker {
		
		protected var shape:Shape;
		protected var _position:Number=0;
		
		public function FrameTicker():void {
			shape = new Shape();
			shape.addEventListener(Event.ENTER_FRAME,tick,false,0,true);
		}
		
		protected function tick(evt:Event):void {
			_position++;
			dispatchEvent(new Event("tick"));
		}
		
		public function get interval():Number { return 1; }
		
		public function get position():Number { return _position; }
	}
}