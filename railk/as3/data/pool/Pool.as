/**
 * 
 * Pool
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.pool
{
	
	public class Pool
	{
		public var growthRate:int=10;
		public var size:int=0;
		public var free:int=0;
		public var os:Array = [];
		public var last:*;
		public var picked:*;
		public var classe:Class;
		
		public function Pool( classe:Class, size:int = 10, growthRate:int = 10 ) {
			this.classe = classe;
			this.growthRate = growthRate;
			this.populate(size);
		}
		
		private function populate(i:int):void {
			while( --i > -1 ) {
				last = classe();
				os[free++] = last;
				size++;
			}
		}
		
		public function pick():* {
			if (free < 1) populate(growthRate);
			picked = last;
			last = os[--free-1];
			return picked;
		}
		
		public function release( o:* ):void { 
			os[free++] = o;
			last = o;
		}
		
		public function purge():void {
			var i:int=tweens.length;
			while( --i > -1 ) os[i].dispose();
			os = [];
			size = 0;
		}
	}
}