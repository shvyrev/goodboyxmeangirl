/**
* Doubly linked List
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.data.list
{
	public class DLinkedList
	{
		// ____________________________________________________________________________ VARIABLES OBJECT LIST
		private var _head                                   :DListNode;
		private var _tail                                   :DListNode;
		private var _length                                 :int;
		private var node                                    :DListNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	...args    ['name',data:*,'group'=null,action:Function=null,args:Object=null],...
		 */
		public function DLinkedList( ...args ):void 
		{
			_head = _tail = null;
			if ( args.length > 0) add.apply( this, args );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   				  ADD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	...args ['name',data:*,'group'=null,action:Function=null,args:Object=null],...
		 */
		public function add( ...args ):void
		{
			if ( ! _head ) _head = _tail = new DListNode( 0, args[0][0], args[0][1], args[0][2], args[0][3], args[0][4] );
			else 
			{ 
				_tail.insertAfter( new DListNode( _tail.id + 1, args[0][0], args[0][1], args[0][2], args[0][3], args[0][4] ) ); 
				_tail = _tail.next; 
			}
			
			if ( args.length > 1 )
			{
				for ( var i:int = 1; i < args.length; i++)
				{
					node = new DListNode( _tail.id+1, args[i][0], args[i][1], args[i][2], args[i][3], args[i][4] );
					_tail.insertAfter(node);
					_tail = _tail.next;
				}
			}
			_length += args.length;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   			   UPDATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function update(name:String, data:*=null, group:String='', action:Function=null, args:Object=null):void {
			var n:DListNode = getNodeByName( name );
			n.data = (data != null)?data:n.data;
			n.group = (group != '')?group:n.group;
			n.action = (action != null)?action:n.action;
			n.args = (args != null)?args:n.args;
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		 INSERT AFTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertAfter( node:DListNode, name:String, data:*, group:String='', action:Function=null, args:Object=null ):void
		{
			node.insertAfter( new DListNode( node.id + 1, name, data, group, action, args ) );
			_length += 1;
			if ( node === _tail ) _tail = tail.next;
			else rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		INSERT BEFORE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertBefore( node:DListNode, name:String, data:*, group:String='', action:Function=null, args:Object=null ):void
		{
			node.insertBefore( new DListNode( node.id - 1, name, data, group, action, args ) );
			_length += 1;
			if ( node === _head ) _head = _head.prev;
			rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		       REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	value  an ID/ a NAME / or an Object
		 * @return
		 */
		public function remove( value:* ):Boolean
		{
			var result:Boolean;
			var type:String;
			var current:DListNode = _head;
			loop:while ( current )
			{
				if ( value is String ) type = 'name';
				else if ( value is int ) type = 'id';
				else  type = 'data';
				
				if (current[type] == value )
				{ 
					removeNode( current );
					result = true;
					break loop; 
				}	
				else result = false;
				current = current.next;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		DIRECT REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function removeNode( n:DListNode ):void
		{
			if ( _length > 1 )
			{
				if ( n == _head )
				{
					_head = _head.next;
					_head.prev = null;
				}
				else if ( n == _tail )
				{
					_tail = _tail.prev;
					_tail.next = null;
				}
				else
				{
					n.prev.next = n.next;
					n.next.prev = n.prev;
				}
			}
			else 
			{ 
				_tail = _head = null; 
			}
			n.dispose();
			_length -= 1;
			rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   REBUILD ID
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function rebuildID():void {
			var current:DListNode = _head;
			var id:int = 0;
			loop:while ( current )
			{
				current.id = id;
				id += 1;
				current = current.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   	CLEAR OBJECT LIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function clear():void
		{
			var next:DListNode;
			var current:DListNode = _head;
			_head = null;
			while ( current )
			{
				next = current.next;
				current.next = current.prev = null;
				current = next;
			}
			_tail = null;
			_length = 0;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GET OBJECT BY NAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getNodeByName( name:String ):DListNode
		{
			var result:*;
			var current:DListNode = _head;
			loop:while ( current )
			{
				if (current.name == name ){ result = current; break loop; }	
				else { result = null; }	
				current = current.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   	 GET OBJECT BY ID
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getNodeByID( id:int ):DListNode
		{
			var result:DListNode;
			var current:DListNode = _head;
			loop:while ( current )
			{
				if (current.id == id ){ result = current;  break loop; }	
				else { result = null; }	
				current = current.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  GET OBJECT BY GROUP
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getNodeByGroup( name:String ):Array
		{
			var result:Array = new Array();
			var current:DListNode = _head;
			loop:while ( current )
			{
				if (current.group == name ){ result.push( current ); break loop; }	
				current = current.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						    TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toString():String 
		{
			var result:String = '';
			var current:DListNode = _head;
			while ( current )
			{
				result += current.toString()+'\n';
				current = current.next;
			}
			if( ! result ) result = '[ empty ]'
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						     TO ARRAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toArray():Array {
			var result:Array = new Array();
			var current:DListNode = _head;
			while ( current )
			{
				result.push( current.data );
				current = current.next;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get head():DListNode { return _head; }
		
		public function get tail():DListNode { return _tail; }
		
		public function get length():int { return _length; }
	}
}