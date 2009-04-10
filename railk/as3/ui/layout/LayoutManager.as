/**
 * Layout Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{	
	public class LayoutManager
	{
		static private var head:Layout;
		static private var tail:Layout;
		public static function addLayout( name:String,structure:Array ):Layout {
			if( !head ) head = tail = new Layout(name,structure);
			else {
				var l:Layout = new Layout(name,structure);
				tail.next=l;
				l.prev=tail;
				tail=l
			}
			return tail;
		}
		
		public static function removeLayout( name:String ):void {
			var l:Layout = getLayout(name);
			if (l.next) l.next.prev = l.prev;
			if (l.prev) l.prev.next = l.next;
			else if (head == l) head = l.next;
		}
		
		public static function getLayout(name:String):Layout {
			var walker:Layout = tail;
			while (walker) {
				if(name == walker.name) return walker;
				walker = walker.prev;
			}
			return null;
		}
	}
	
}