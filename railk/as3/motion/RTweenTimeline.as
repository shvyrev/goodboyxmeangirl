/**
 * 
 * RTween Timeline
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * Think on the timeline acces to certain point (GOTO)
 * 
 */

package railk.as3.motion
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import railk.as3.motion.tween.TimelineTween;
	import railk.as3.motion.core.Engine;
	
	public class RTweenTimeline
	{	
		private var first:*=null;
		private var last:*=null;
		private var timeline:Object={};
		private var labels:Object={};
		private var tweens:int=0;
		
		public var growthRate:int = 10;
		public var size:int=0;
		public var free:int=0;
		
		private var engine:Engine = Engine.getInstance();
		private var ticker:Shape = new Shape();
		private var startTime:Number;
		private var time:Number;
		private var currentPos:Number=-1;
		private var paused:Boolean=false;
		
		public function RTweenTimeline( size:int=10, growthRate:int=10 ) {
			this.growthRate = growthRate;
			populate(size);
		}
		
		/**
		 * enables modules
		 */
		static public function enable( ...modules ):Boolean { return true; } 
		
		
		/**
		 * Timeline management
		 */
		public function add( pos:Number, target:Object, duration:Number, props:Object, options:Object=null ):void {
			if (options) options['onDispose'] = release;
			else options = { onDispose:release };
			if ( timeline[pos] != undefined) timeline[pos].push([target, duration, props, options]);
			else timeline[pos] = [[target, duration, props, options]];
			tweens++;
		}
		
		public function remove( posLabel:* ):void {
			delete( timeline[((posLabel is String)?labels[posLabel]:posLabel)] );
			tweens--;
		}
		
		public function getTweenAt( pos:Number ):Object {
			return timeline[pos];
		}
		
		public function addLabel( pos:Number, name:String ):void {
			labels[name] = pos;
		}
		
		public function removeLabel( name:String ):void {
			delete labels[name];
		}

		public function goToAndPlay( posLabel:* ):void {
			var pos:Number = (posLabel is String)?labels[posLabel]:posLabel;
		}
		
		public function goToAndStop( posLabel:* ):void {
			var pos:Number = (posLabel is String)?labels[posLabel]:posLabel;
		}
		
		public function start():void {
			if(!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener( Event.ENTER_FRAME, tick, false, 0, true);
			if (paused){
				startTime = getTimer()-time;
				paused = false;
				var walker:* = engine.first;
				while ( walker ) {
					walker.start();
					walker = walker.next;
				}
			}
			else startTime = getTimer();
		}
		
		public function pause():void {
			stop();
			paused = true;
			var walker:* = engine.first;
			while ( walker ) {
				walker.pause();
				walker = walker.next;
			}
		}
		
		public function stop():void {
			ticker.removeEventListener( Event.ENTER_FRAME, tick );
		}
		
		public function reset():void {
			startTime = getTimer();
			time = 0;
		}
		
		private function tick(evt:Event):void {
			var i:int=0, p:Array, t:String, pos:Number;
			time = (getTimer()-startTime)*.001;
			for ( t in timeline ) {
				pos = Number(t);
				if ( time > pos && pos > currentPos) {
					p = timeline[t];
					for(i;i<p.length;i++){
						(pick() as TimelineTween).init( p[i][0],p[i][1],p[i][2],p[i][3] );
						if (--tweens == 0) stop();
					}
					currentPos = pos;
				}
			}	
		}
		
		
		
		/**
		 * pool management
		 */
		private function addTweenNode( tween:* ):void {
			last.next = tween
			last.tail = false;
			tween.prev = last;
			last = tween;
		}
		
		private function removeTweenNode( tween:* ):* {
			if ( size > 1 ) {
				if ( tween == first ){
					first = first.next;
					first.prev = null;
				} else if ( tween == last ) {
					last = last.prev;
					last.next = null;
				} else {
					tween.prev.next = tween.next;
					tween.next.prev = tween.prev;
				}
			} else first = last = null;
			
			tween.prev = tween.next = null;
			tween.head = false;
			tween.tail = true;
			return tween;
		}
		
		private function populate(n:int):void {
			var i:int=0;
			for (i; i < n; i++) {
				if ( !first ) {
					first = last = new TimelineTween();
					first.head = true;
				} 
				else addTweenNode( new TimelineTween() );
				size++;
				free++
			}
		}
		
		private function pick():* {
			if (free == 0) populate(growthRate);
			free--;
			return removeTweenNode(last);
		}
		
		private function release(tween:*):void {
			addTweenNode( tween );
			free++;
		}
		
		private function purge():void {
			var next:*, current:* = first;
			first = null;
			while ( current ) {
				next = current.next;
				current.next = current.prev = null;
				current = next;
			}
			last = null;
			size = 0;
		}
		
		
		/**
		 * dispose
		 */
		public function dispose():void {
			pause();
			purge();
		}
	}
}