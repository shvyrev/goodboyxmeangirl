/**
* Object Node
* 
* @author Richard Rodney
* @version
*/


package railk.as3.utils.objectList
{
	public class ObjectNode
	{
		// _____________________________________________________________________________ VARIABLES OBJECTNODE
		private var _id                            :int;
		private var _name                          :String;
		private var _data                          :*;
		private var _prev                          :ObjectNode;
		private var _next                          :ObjectNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	data
		 */
		public function ObjectNode( id:int, name:String, data:* ):void {
			_name = name;
			_data = data;
			_id = id;
			_prev = _next = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 INSERT AFTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertAfter( node:ObjectNode ):void
		{
			node.next = _next;
			node.prev = this;
			if (_next) _next.prev = node;
			_next = node;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						INSERT BEFORE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertBefore( node:ObjectNode ):void
		{
			node.next = this;
			node.prev = _prev;
			if (_prev) _prev.next = node;
			_prev = node;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						    TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toString():String {
			return '[ ObjectNode/'+_id+' -> '+ _name + ', ' + String( _data )+' ]';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						      DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			_data = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get id():int { return _id; }
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get data():* { return _data; }
		
		public function set data(value:*):void 
		{
			_data = value;
		}
		
		public function get prev():ObjectNode { return _prev; }
		
		public function set prev(value:ObjectNode):void 
		{
			_prev = value;
		}
		
		public function get next():ObjectNode { return _next; }
		
		public function set next(value:ObjectNode):void 
		{
			_next = value;
		}
		
	}
	
}