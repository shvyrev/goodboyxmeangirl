﻿/**
* Object Node
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.objectList
{
	public class ObjectNode
	{
		// _____________________________________________________________________________ VARIABLES OBJECTNODE
		private var _id                            :int;
		private var _name                          :String;
		private var _data                          :*;
		private var _group                         :String;
		private var _action                        :Function;
		private var _args                          :Object;
		private var _prev                          :ObjectNode;
		private var _next                          :ObjectNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	id
		 * @param	name
		 * @param	data
		 * @param	group
		 * @param	action
		 */
		public function ObjectNode( id:int, name:String, data:*, group:String='', action:Function=null, args:Object=null ):void {
			_name = name;
			_data = data;
			_group = group;
			_action = action;
			_args = args;
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
			var g:String;
			if ( ! _group ) g = 'no group';
			else g = _group;
			return '[ ObjectNode/'+_id+' -> '+ g +', '+ _name + ', ' + String( _data )+' ]';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						      DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			_data = null;
			_action = null;
			_args = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get id():int { return _id; }
		
		public function set id(value:int):void { _id = value; }
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void { _name = value; }
		
		public function get data():* { return _data; }
		
		public function set data(value:*):void { _data = value; }
		
		public function get prev():ObjectNode { return _prev; }
		
		public function set prev(value:ObjectNode):void { _prev = value; }
		
		public function get next():ObjectNode { return _next; }
		
		public function set next(value:ObjectNode):void { _next = value; }
		
		public function get action():Function { return _action; }
		
		public function set action(value:Function):void { _action = value; }
		
		public function get group():String { return _group; }
		
		public function set group(value:String):void { _group = value; }
		
		public function get args():Object { return _args; }
		
		public function set args(value:Object):void { _args = value; }
	}
}