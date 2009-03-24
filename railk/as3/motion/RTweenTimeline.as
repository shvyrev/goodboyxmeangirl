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
	import railk.as3.utils.ObjectMerger;
	
	public class RTweenTimeline
	{	
		private var timeline:Object={};
		private var labels:Object={};
		private var callBacks:Object={};
		private var tweens:Dictionary = new Dictionary(true);
		private var tween:Object;
		
		private var ticker:Shape = new Shape();
		private var startTime:Number=0;
		private var elapsedTime:Number = 0;
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
		 * Timeline append
		 */
		public function append( pos:Number, target:Object, duration:Number, props:Object, options:Object = null ):void {
			if ( !willOverwrite(target, pos, ObjectMerger.merge(props, options, { duration:duration, delay:0 } )) ) {
				var t:Array = [target, duration, props, options];
				if ( timeline[pos] ) timeline[pos].push(t);
				else timeline[pos] = [t];
				tweens[t] = new RTween();
				tweens[t].target = target;
				tweens[t].autoDispose = false;
				tweens[t].delay = pos;
				tweens[t].addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
			}
			this.duration += (pos + duration) - this.duration;
			length++;
		}
		
		/**
		 * Timeline management
		 */
		public function start():void {
			if (paused) {
				startTime = getTimer()-elapsedTime*1000;
				for ( tween in tweens ) tweens[tween].start();
				paused = false;
			} else {
				startTime = getTimer();
				var i:int, p:Array, t:String;
				for ( t in timeline ) {
					p = timeline[t];
					for (i=0;i<p.length;i++) tweens[p[i]].init( p[i][0], p[i][1], p[i][2], p[i][3] );
				}
			}
			ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true );
		}
		
		public function pause():void {
			stop();
			paused = true;
			for ( tween in tweens ) tweens[tween].pause();
		}
		
		public function reset():void { 
			startTime = getTimer(); 
			currentPos = -1;
		}
		
		public function reverse():void { 
			reversed = (reversed)?false:true; 
		}
		
		public function stop():void {
			ticker.removeEventListener( Event.ENTER_FRAME, tick );
		}
		
		public function dispose():void {
			pause();
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
		public function addCallBack( pos:Number, action:Function, params:Array = null ):void { 
			if ( callBacks[pos] ) callBacks[pos].push(new CallBack(pos, action, params));
			else callBacks[pos] = [new CallBack(pos, action, params)];
		}
		
		public function removeCallBack( pos:Number ):void { delete callBacks[pos]; }
		
		/**
		 * Gotos
		 */
		public function goToAndPlay( posLabel:* ):void { goTo( ((posLabel is String)?labels[posLabel]:posLabel) ); }
		
		public function goToAndStop( posLabel:* ):void { goTo( ((posLabel is String)?labels[posLabel]:posLabel),true ); }
		
		private function goTo( pos:Number, paused:Boolean = false ):void {
			for ( var o:Object in tweens) tweens[o].setPosition(pos);
			if (paused) pause();
			else start();
		}
		
		/**
		 * willOverwrite
		 */
		private function willOverwrite( target:*, pos:Number, props:Object ):Boolean {
			for ( var o:Object in tweens ) if (tweens[o].target == target ) { addCallBack( pos, function(paused:Boolean) { if(!paused) tweens[o].setProps(props); } ); return true; }
			return false;
		}
		
		/**
		 * Event
		 */
		private function manageEvent( evt:Event ):void {
			evt.target.removeEventListener(Event.COMPLETE, manageEvent);
			--length;
		}
		
		/**
		 * Tick
		 */
		private function tick( evt:Event ):void {
			elapsedTime = (!reversed)?((getTimer() - startTime) * .001):(duration - ((getTimer() - startTime) * .001));
			for ( var o:Object in callBacks ) {
				for ( var i:int = 0; i < callBacks[o].length; i++) {
					if ( elapsedTime >= callBacks[o][i].pos && callBacks[o][i].pos > currentPos ) {
						if(i==callBacks[o].length-1) currentPos = callBacks[o][i].pos;
						callBacks[o][i].apply(paused);
					}
				}
				
			}
			if ( elapsedTime >= duration) stop();
		}
	}
}