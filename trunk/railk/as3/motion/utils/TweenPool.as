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
	import railk.as3.motion.tween.PoolTween;
	public class TweenPool
	{
		public var growthRate:int=10;
		public var size:int=0;
		public var free:int=0;
		public var tweens:Array = [];
		public var last:PoolTween;
		
		public function TweenPool( size:int = 10, growthRate:int = 10 ) {
			this.growthRate = growthRate;
			this.populate(size);
		}
		
		private function populate(n:int):void {
			var i:int = 0;
			for (i; i < n; i++) {
				last = new PoolTween();
				tweens[free++] = last;
				size++;
			}
		}
		
		public function add( tween:PoolTween ):void {
			tweens[free++] = tween;
			last = tween;
		}
		
		public function remove( tween:PoolTween, options:Array ):PoolTween {
			tweens.pop();
			last = tweens[--free-1];
			tween.init.apply(null,options)
			return tween;
		}
		
		public function pick(...options):PoolTween {
			if (free < 1) populate(growthRate);
			return remove( last,options );
		}
		
		public function release( tween:PoolTween ):void { add( tween ); }
		
		public function purge():void {
			var i:int=0;
			for (i; i < tweens.length; i++) tweens[i].dispose();
			tweens = [];
			size = 0;
		}
	}
}