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
		private var head:Layout;
		private var tail:Layout;
		public static function addLayout( name:String,parent:Object,structure:LayoutStruct ):void {
			if( !head ) head = tail = new Layout(name,parent,structure);
			else {
				var l:Layout = new Layout(name,parent,structure);
				tail.next=l;
				l.prev=tail;
				tail=l
			}
		}
		
		public static function removeLayout( name:String ):Boolean {
			var l:Layout = getLayout(name);
			if (l.next) l.next.prev = l.prev;
			if (l.prev) l.prev.next = l.next;
			else if (head == l) head = l.next;
		}
		
		public function getLayout(name:String):Layout {
			var walker:Layout = tail;
			while (walker) {
				if(name == walker.name) return walker;
				walker = walker.prev;
			}
			return null;
		}
	}
	
}