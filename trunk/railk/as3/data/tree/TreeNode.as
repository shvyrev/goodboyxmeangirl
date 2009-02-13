/**
* Tree Node
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.tree
{
	import railk.as3.data.objectList.ObjectList;
	import railk.as3.data.objectList.ObjectNode;
	
	public class TreeNode 
	{
		public var parent:TreeNode;
		public var name:String;
		public var data:*;
		public var childs:ObjectList;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	obj
		 * @param	parent
		 */
		public function TreeNode(name:String, obj:*= null, parent:TreeNode=null):void {
			data = obj;
			childs = new ObjectList();
			this.name = name;
			
			if (parent)
			{
				this.parent = parent;
				parent.childs.add([name,this]);
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								 SIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get size():int {
			var c:int = 1;
			var node:ObjectNode = childs.head;
			while (node)
			{
				c += TreeNode(node.data).size;
				node = node.next;
			}
			return c;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   IS/HAS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function isRoot():Boolean {
			return !Boolean(parent);
		}
		
		public function isLeaf():Boolean {
			return childs.length == 0;
		}
		
		public function hasChildren():Boolean {
			return childs.length > 0;
		}
		
		public function hasSiblings():Boolean {
			if (parent)
				return parent.childs.length > 1;
			return false;
		}
		
		public function isEmpty():Boolean {
			return childs.length == 0;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		DEPTH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get depth():int {
			if (!parent) return 0;
			
			var node:TreeNode = this, c:int = 0;
			while (node.parent)
			{
				c++;
				node = node.parent;
			}
			return c;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		  NUM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get numChildren():int {
			return childs.length;
		}
		
		public function get numSiblings():int {
			if (parent)
				return parent.childs.length;
			return 0;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 GET TREENODE BY NAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getTreeNodeByName(name:String):TreeNode {
			var result:TreeNode;
			
			if ( name == this.name ) result = this;
			else {
				var t:Array = treePlanner( this );
				for (var i:int = 0; i < t.length ; i++) 
				{
					if ( t[i].name == name ) {
						result = t[i];
						break;
					}
				}
			}
			return result;
		}
		
		private function treePlanner( from:TreeNode ):Array {
			var result:Array = new Array();
			result.push( from );
			if ( from.hasChildren() ) {
				result = result.concat( subTreePlanner( from ) );
			}
			return result;
		}
		
		private function subTreePlanner( t:TreeNode ):Array {
			var result:Array = new Array();
			var walker:ObjectNode = t.childs.head;
			loop:while ( walker ) {
				result.push( walker.data );
				if ( walker.data.hasChildren() ) result = result.concat( subTreePlanner( walker.data ) );
				walker = walker.next;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		CLEAR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function clear():void {
			while (childs.head)
			{
				var node:TreeNode = childs.head.data;
				childs.removeObjectNode(childs.head);
				node.clear();
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   TREE TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function treeToString():String {
			var result:String='';
			var t:Array = treePlanner( this ); 
			
			for (var i:int = 0; i < t.length ; i++) 
			{
				result += t[i]+'\n';
			}
			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		 TO ARRAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toArray():Array
		{
			return treePlanner( this );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toString():String 
		{
			var s:String = "[TreeNode "+ name +" > " + (parent == null ? "(root)" : "( parent is "+parent.name+" )");
			
			if (childs.length == 0)
				s += "(leaf)";
			else
				s += " has " + childs.length + " child node" + (size > 1 || size == 0 ? "s" : "");
			
			s += ", data=" + data + "]";
			
			return s;
		}	
	}
}