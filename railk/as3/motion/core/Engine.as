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
	import flash.utils.getTimer;
	import railk.as3.motion.tween.LiteTween;
	import railk.as3.pattern.singleton.Singleton;
	
	public class Engine
	{	
		public var defaultEase:Function = easeOut;
		public var length:int = 0;
		
		private var inTick:Boolean;
		private var ticker:Shape = new Shape();
		private var last:LiteTween = null;
		private var first:LiteTween = null;
		
		public static function getInstance():Engine { return Singleton.getInstance(Engine); }
		
		public function Engine() { 
			Singleton.assertSingle(Engine); 
		}
		
		public function add( tween:LiteTween ):int {
			if (!last){
				first = last = tween;
				tween.head = true;
			} else {
				last.next = tween;
				last.tail = false;
				tween.prev = last;
				last = tween;
			}
			this.start( tween );
			return ++length;
		}
		
		public function remove( tween:LiteTween ):int {
			if ( tween.head && tween.tail ) first = last = null;
			else if ( tween.head && !tween.tail ){
				tween.next.prev = null;
				tween.next.head = true;
				first = tween.next;
			} else if ( !tween.head && tween.tail ){
				tween.prev.next = null;
				tween.prev.tail = true;
				last = tween.prev;
			} else {
				tween.prev.next = tween.next;
				tween.next.prev = tween.prev;
			}
			length--;
			return 0;
		}
		
		private function start( tween:LiteTween ):void {
			tween.startTime = getTimer();
			if (!inTick) { 
				ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true ); 
				inTick=false;
			}
		}

		private function stop():void {
			ticker.removeEventListener(Event.ENTER_FRAME, tick );
			inTick=true;
		}
		
		private function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return c * ((t = t / d - 1) * t * t * t * t + 1) + b; }
		
		private function tick(evt:Event):void {
			if ( first != null ) {
				var walker:LiteTween = first;
				while ( walker ) {
					walker.update( (getTimer()-walker.startTime)*.001 );
					walker = walker.next;
				}
			} else  this.stop();
		}
	}
	
}