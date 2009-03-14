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
		private var first:*=null;
		private var last:*= null;
		
		public var growthRate:int=10;
		public var size:int=0;
		public var free:int=0;
		public var classe:Class;
		
		public function Pool( classe:Class, size:int = 10, growthRate:int = 10 ) {
			this.classe = classe;
			this.growthRate = growthRate;
			this.populate(size);
		}
		
		private function populate(n:int):void {
			var i:int=0;
			for (i; i < n; i++) {
				if ( !first ) {
					first = last = new classe();
					first.head = true;
				} 
				else add( new classe() );
				size++;
				free++
			}
		}
		
		public function add( node:* ):void {
			last.next = node;
			last.tail = false;
			node.prev = last;
			last = node;
		}
		
		public function remove( node:* ):* {
			if ( size > 1 ) {
				if ( node == first ){
					first = first.next;
					first.prev = null;
				} else if ( node == last ) {
					last = last.prev;
					last.next = null;
				} else {
					node.prev.next = node.next;
					node.next.prev = node.prev;
				}
			} else first = last = null;
			
			node.prev = node.next = null;
			node.head = false;
			node.tail = true;
			return node;
		}
		
		public function pick():* {
			if (free == 0) populate(growthRate);
			free--;
			return remove(last);
		}
		
		public function release(node:*):void {
			add( node );
			free++;
		}
		
		public function purge():void {
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
	}
}