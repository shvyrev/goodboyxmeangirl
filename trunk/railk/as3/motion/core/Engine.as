/**
 * 
 * RTween Fast Engine
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.core	
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import railk.as3.motion.RTweeny;
	import railk.as3.pattern.singleton.Singleton;
	
	public class Engine
	{	
		public var defaultEase:Function = easeOut;
		public var length:int=0;
		public var tweens:Array=[];
		private var ticker:Shape = new Shape();
		
		public static function getInstance():Engine { return Singleton.getInstance(Engine); }
		
		public function Engine() { 
			Singleton.assertSingle(Engine); 
		}
		
		public function add( tween:RTweeny ):int {
			tweens[length++] = tween;
			this.start( tween );
			return length;
		}
		
		public function remove( tween:RTweeny ):int {
			loop:for (var i:int=0;i<length;i++) {
				var t:RTweeny = tweens[i];
				if (t == tween) {
					tweens.splice(i, 1);
					break loop;
				}
			}
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
			if ( length > 0 ) {
				for (var i:int=0;i<length;i++) {
					var t:RTweeny = tweens[i];
					t.update( getTimer()*.001 );
				}	
			}
			else  this.stop();
		}
	}
}