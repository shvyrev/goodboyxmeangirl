/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import railk.as3.ui.layout.Layout;
	public class Page
	{
		public var next:Page;
		public var prev:Page;
		
		public var name:String;
		public var parent:Page;
		public var firstChild:Page;
		public var lastChild:Page;
		public var length:Number=0;
		
		
		public function Page( parent:Page, name:String, layour:Layout, assets:Array=null) {
			this.parent = parent;
			this.name = name;
		}
		
		public function addChild( child:Page ):void {
			if (!firstChild) firstChild = lastChild = child;
			else {
				lastChild.next = child;
				child.prev = lastChild;
				lastChild = child;
			}
			length++;
		}
		
		public function setActive():void {
			
		}
		
		public function dispose():void {

		}
		
		/**
		 * 	GETTER/SETTER
		 */
		public function get isRoot():Boolean { return !Boolean(parent); }
		
		public function get isLeaf():Boolean { return length == 0; }
		
		public function get hasChildren():Boolean { return length > 0; }
		
		public function get depth():int {
			if (!parent) return 0;
			var child:Page = this, c:int = 0;
			while (child.parent) {
				c++;
				child = child.parent;
			}
			return c;
		}
		
		public function get numChildren():int { return length; }
		
		public function get numSiblings():int {
			if (parent) return parent.length;
			return 0;
		}
	}
}