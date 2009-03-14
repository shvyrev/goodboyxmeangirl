/**
 * 
 * RTween Timeline
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * 
 */

package railk.as3.motion
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import railk.as3.motion.tween.TimelineTween;
	import railk.as3.motion.core.Engine;
	import railk.as3.data.pool.Pool;
	
	public class RTweenTimeline
	{	
		private var timeline:Object={};
		private var labels:Object = { };
		private var pool:Pool;
		private var tweens:int=0;
		
		private var engine:Engine = Engine.getInstance();
		private var ticker:Shape = new Shape();
		private var startTime:Number;
		private var time:Number;
		private var currentPos:Number=-1;
		private var paused:Boolean=false;
		
		public function RTweenTimeline( size:int=10, growthRate:int=10 ) {
			pool = new Pool( TimelineTween, size, growthRate);
		}
		
		/**
		 * enables modules
		 */
		static public function enable( ...modules ):Boolean { return true; } 
		
		/**
		 * Timeline management
		 */
		public function add( pos:Number, target:Object, duration:Number, props:Object, options:Object=null ):void {
			if (options) options['onDispose'] = pool.release;
			else options = { onDispose:pool.release };
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
			goTo( ((posLabel is String)?labels[posLabel]:posLabel) );
		}
		
		public function goToAndStop( posLabel:* ):void {
			//pause();
			goTo( ((posLabel is String)?labels[posLabel]:posLabel) );
		}
		
		private function goTo( pos:Number ):void {
			var t:String, p:Array, i:int, tn:Number;
			for ( t in timeline ) {
				p = timeline[t];
				tn = Number(t);
				for (i = 0; i < p.length; i++) {
					if( pos < tn+p[i][1] ){
						trace(tn+p[i][1], tn+pos);
					}
				}
			}
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
			var i:int, p:Array, t:String, pos:Number;
			time = (getTimer()-startTime)*.001;
			for ( t in timeline ) {
				pos = Number(t);
				if ( time > pos && pos > currentPos) {
					p = timeline[t];
					for(i;i<p.length;i++){
						(pool.pick() as TimelineTween).init( p[i][0],p[i][1],p[i][2],p[i][3] );
						if (--tweens == 0) stop();
					}
					currentPos = pos;
				}
			}	
		}
		
		public function dispose():void {
			pause();
			pool.purge();
		}
	}
}