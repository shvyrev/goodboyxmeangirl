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
	import railk.as3.motion.RTweeny;
	import railk.as3.pattern.singleton.Singleton;
	
	public class LiteEngine
	{	
		public var defaultEase:Function = easeOut;
		public var length:int=0;
		public var tweens:Dictionary = new Dictionary(true);
		public var ticker:Shape = new Shape();
		
		public static function getInstance():LiteEngine { return Singleton.getInstance(LiteEngine); }
		
		public function Engine() { 
			Singleton.assertSingle(LiteEngine); 
		}
		
		public function add( tween:RTweeny ):int {
			tweens[tween]= tween;
			this.start( tween );
			return ++length;
		}
		
		public function remove( tween:RTweeny ):int {
			delete tweens[tween];
			length--;
			return 0;
		}
		
		private function start( tween:RTweeny ):void {
			tween.startTime = getTimer()*.001;
			if (!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true ); 
		}
		
		public function reset(tween:RTweeny):void { tween.startTime = getTimer()*.001; }
		
		private function stop():void { ticker.removeEventListener(Event.ENTER_FRAME, tick ); }
		
		private function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return c*t/d+b; }
		
		protected function tick(evt:Event):void {
			if ( length > 0 ) for (var v:Object in tweens) (tweens[v]as RTweeny).update( getTimer()*.001 );
			else  this.stop();
		}
	}
}