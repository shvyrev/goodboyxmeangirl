/**
 * 
 * Tween Pool
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{
	import railk.as3.motion.tweens.Normal;
	import railk.as3.pattern.singleton.Singleton;
	public class Pool
	{
		private var populated:Boolean;
		private var growthRate:int=1;
		private var size:int=0;
		private var free:int=0;
		private var last:Normal;
		private var tweens:Array = [];
		private var picked:Normal;
		
		public static function getInstance():Pool {
			return Singleton.getInstance(Pool);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Pool() {
			Singleton.assertSingle(Pool);
		}
		
		private function populate(i:int):void {
			while ( --i > -1 ) {
				last = new Normal();
				tweens[free++] = last;
				size++;
			}
		}
		
		public function scale( size:int, growthRate:int ):void {
			populate( size - this.size );
			this.growthRate = growthRate;
		}
		
		public function pick(target:*,autoStart:Boolean):Normal {
			if (free < 1) populate(growthRate);
			picked = last;
			last = tweens[--free-1];
			return picked.init(target,autoStart);
		}
		
		public function release( tween:Normal ):void { 
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