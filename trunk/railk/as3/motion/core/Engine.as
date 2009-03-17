/**
 * 
 * RTween Engine
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.core	
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import railk.as3.motion.tween.LiteTween;
	import railk.as3.pattern.singleton.Singleton;
	
	public class Engine
	{	
		public var defaultEase:Function = easeOut;
		public var length:int=0;
		private var tweens:Dictionary = new Dictionary(true);
		private var ticker:Shape = new Shape();
		
		public static function getInstance():Engine { return Singleton.getInstance(Engine); }
		
		public function Engine() { 
			Singleton.assertSingle(Engine); 
		}
		
		public function add( tween:LiteTween ):int {
			tweens[tween]= tween;
			this.start( tween );
			return ++length;
		}
		
		public function remove( tween:LiteTween ):int {
			delete tweens[tween];
			length--;
			return 0;
		}
		
		private function start( tween:LiteTween ):void {
			tween.startTime = getTimer();
			if (!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true ); 
		}
		
		public function reset(tween:LiteTween):void { tween.startTime = getTimer(); }; 
		
		private function stop():void { ticker.removeEventListener(Event.ENTER_FRAME, tick ); }
		
		private function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return c*t/d+b; }
		
		protected function tick(evt:Event):void {
			var o:Object;
			if ( length > 0 ) for(o in tweens ) tweens[o].update( (getTimer()-tweens[o].startTime)*.001 );
			else  this.stop();
		}
	}
}