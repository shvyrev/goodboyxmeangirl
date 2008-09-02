package railk.as3.tween.process.utils
{
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	public class TimeTicker extends EventDispatcher implements ITicker {
		
		protected var timer:Timer;
		
		public function TimeTicker():void {
			timer = new Timer(20);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,tick,false,0,true);
		}
		
		public function get position():Number { return getTimer()/1000; }
		
		public function get interval():Number { return timer.delay/1000; }
		
		public function set interval(value:Number):void { timer.delay = value*1000; }
		
		protected function tick(evt:TimerEvent):void {
			dispatchEvent(new Event("tick"));
			evt.updateAfterEvent();
		}
	}
}