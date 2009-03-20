/**
 * 
 * RTween Timeline
 * 
 * @author Richard Rodney
 * @version 0.1 
 * 
 * TODO:
 * 	_callbacks apply
 * 	_gotoandplay correct bug
 */

package railk.as3.motion
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import railk.as3.motion.utils.CallBack;
	
	public class RTweenTimeline
	{	
		private var timeline:Object={};
		private var labels:Object={};
		private var callBacks:Object={};
		private var tweens:Dictionary = new Dictionary(true);
		private var activeTweens:Dictionary = new Dictionary(true);
		private var pausedTweens:Dictionary = new Dictionary(true);
		private var tween:Object;
		
		private var ticker:Shape = new Shape();
		private var startTime:Number=0;
		private var time:Number = 0;
		private var duration:Number = 0;
		private var currentPos:Number=-1;
		private var paused:Boolean;
		private var reversed:Boolean;
		private var length:int=0;
		
		/**
		 * enables modules for RTween if using special properties
		 */
		static public function enable( ...modules ):Boolean { return true; } 
		
		/**
		 * Timeline management
		 */
		public function add( classe:Class, pos:Number, target:Object, duration:Number, props:Object, options:Object = null ):void {
			if ( options ) options['autoDispose'] = false;
			else options = { autoDispose:false };
			var t:Array = [target, duration, props, options];
			if ( timeline[pos] ) timeline[pos].push(t);
			else timeline[pos] = [t];
			tweens[t] = new classe();
			tweens[t].addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
			this.duration += (pos+duration) - this.duration;
			length++;
		}
		
		public function start():void {
			if (paused) {
				startTime = getTimer()-time*1000;
				for ( tween in pausedTweens ) {
					activeTweens[tween] = pausedTweens[tween];
					activeTweens[tween].start();
					delete pausedTweens[tween];
				}
				paused = false;
			} 
			else startTime = getTimer();
			if(!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener( Event.ENTER_FRAME, tick, false, 0, true);
		}
		
		public function pause():void {
			stop();
			for ( tween in activeTweens ) {
				pausedTweens[tween] = activeTweens[tween];
				pausedTweens[tween].pause();
				delete activeTweens[tween];
			}
		}
		
		public function reset():void { 
			startTime = getTimer(); 
			currentPos = -1;
		}
		
		public function reverse():void { reversed = (reversed)?false:true; }
		
		public function stop():void {
			paused = true;
			ticker.removeEventListener( Event.ENTER_FRAME, tick );
		}
		
		public function dispose():void {
			stop();
			for ( tween in tweens ) tweens[tween].dispose();
			tweens = null;
		}
		
		/**
		 * Labels
		 */
		public function addLabel( pos:Number, name:String ):void { labels[name] = pos; }
		
		public function removeLabel( name:String ):void { delete labels[name]; }
		
		/**
		 * CallBacks
		 */
		public function addCallBack( pos:Number, action:Function, params:Array = null ):void { callBacks[pos] = new CallBack(pos, action, params); }
		
		public function removeCallBack( pos:Number ):void { delete callBacks[pos]; }
		
		/**
		 * Gotos
		 */
		public function goToAndPlay( posLabel:* ):void { goTo( ((posLabel is String)?labels[posLabel]:posLabel) ); }
		
		public function goToAndStop( posLabel:* ):void { goTo( ((posLabel is String)?labels[posLabel]:posLabel),true ); }
		
		private function goTo( time:Number, paused:Boolean = false ):void {
			this.time = time;
			var t:String, p:Number, a:Array, b:Array=[], e:Array=[], i:int;
			for ( t in timeline ) {
				p = Number(t);
				a = timeline[t]
				for (i=0; i < a.length; i++) {
					if ( p + a[i][1] > time ) {
						if ( p < time) {
							e.push([a[i], time-p]);
							currentPos = p;
						}
					} else b.push([a[i],a[i][1]]);
				}	
			}
			
			if ( e.length < 1 && b.length < 1 ) {
				for( tween in pausedTweens ) pausedTweens[tween].setPosition(0);
				for( tween in activeTweens ) activeTweens[tween].setPosition(0);
			}
			else {
				replace(b);
				replace(e);
				length -= b.length + e.length;
			}
			
			if (paused) pause();
			else start();
		}
		
		private function replace( data:Array ):void {
			var i:int;
			for (i = 0; i < data.length; i++) {
				tween = tweens[data[i][0]];
				if ( pausedTweens[tween] ) pausedTweens[tween].setPosition(data[i][1]);
				else if ( activeTweens[tween] ) activeTweens[tween].setPosition(data[i][1]);
				else {
					activeTweens[tween] = tween
					tween.init( data[i][0][0], data[i][0][1], data[i][0][2], data[i][0][3], data[i][1] );
				}
				length++;
			}
		}
		
		/**
		 * Ticker
		 */
		private function tick(evt:Event):void {
			time = (!reversed)?((getTimer()-startTime)*.001):(duration-((getTimer()-startTime)*.001));
			var i:int, p:Array, t:String, pos:Number;
			for ( t in timeline ) {
				pos = Number(t);
				if ( time > pos && pos > currentPos) {
					p = timeline[t];
					for(i;i<p.length;i++){
						tweens[p[i]].init( p[i][0], p[i][1], p[i][2], p[i][3] );
						activeTweens[tweens[p[i]]] = tweens[p[i]];
					}
					currentPos = pos;
				}
			}
		}
		
		/**
		 * Event
		 */
		private function manageEvent( evt:Event ):void {
			evt.target.removeEventListener(Event.COMPLETE, manageEvent);
			delete activeTweens[evt.target]; 
			if (--length <= 0) stop();
		}
	}
}