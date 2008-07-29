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
		private var _group                         :String;
		private var _script                        :Function;
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
		public function ObjectNode( id:int, name:String, data:*, group:String='', script:Function=null ):void {
			_name = name;
			_data = data;
			_group = group;
			_script = script;
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
			return '[ ObjectNode/'+_id+' -> '+ _group +', '+ _name + ', ' + String( _data )+' ]';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						      DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			_data = null;
			_script = null;
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
		
		public function get script():Function { return _script; }
		
		public function set script(value:Function):void 
		{
			_script = value;
		}
		
		public function get group():String { return _group; }
		
		public function set group(value:String):void 
		{
			_group = value;
		}
		
	}
	
}