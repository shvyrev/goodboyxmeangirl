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
		
		public function Pool( size:int = 10, growthRate:int = 10 ) {
			this.growthRate = growthRate;
			this.populate(size);
		}
		
		private function populate(n:int):void {
			var i:int = 0;
			for (i; i < n; i++) {
				last = new RTweens();
				tweens[free++] = last;
				size++;
			}
		}
		
		public function add( tween:RTweens ):void {
			tweens[free++] = tween;
			last = tween;
		}
		
		public function remove( tween:RTweens, options:Array ):RTweens {
			last = tweens[--free-1];
			tween.init.apply(null,options)
			return tween;
		}
		
		public function pick(...options):RTweens {
			if (free < 1) populate(growthRate);
			return remove( last,options );
		}
		
		public function release( tween:RTweens ):void { add( tween ); }
		
		public function purge():void {
			var i:int=0;
			for (i; i < tweens.length; i++) tweens[i].dispose();
			tweens = [];
			size = 0;
		}
	}
}