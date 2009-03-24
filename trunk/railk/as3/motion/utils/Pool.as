/**
 * 
 * Tween Pool
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{
	import flash.utils.Dictionary;
	import railk.as3.motion.RTweens;
	public class Pool
	{
		public var growthRate:int=10;
		public var size:int=0;
		public var free:int=0;
		public var tweens:Array = [];
		public var last:RTweens;
		public var picked:RTweens;
		
		public function Pool( size:int = 10, growthRate:int = 10 ) {
			this.growthRate = growthRate;
			this.populate(size);
		}
		
		private function populate(i:int):void {
			while( --i > -1 ) {
				last = new RTweens();
				tweens[free++] = last;
				size++;
			}
		}
		
		public function pick(...options):RTweens {
			if (free < 1) populate(growthRate);
			picked = last;
			last = tweens[--free-1];
			picked.init.apply(null, options);
			return picked;
		}
		
		public function release( tween:RTweens ):void { 
			tweens[free++] = tween;
			last = tween;
		}
		
		public function purge():void {
			var i:int=tweens.length;
			while( --i > -1 ) tweens[i].dispose();
			tweens = [];
			size = 0;
		}
	}
}