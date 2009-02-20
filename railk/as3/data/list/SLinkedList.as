/**
* Single linked List
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.data.list
{
	public class SLinkedList
	{
		private var _head                                   :SListNode;
		private var _tail                                   :SListNode;
		private var _length                                 :int;
		private var node                                    :SListNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	...args    ['name',data:*,'group'=null,action:Function=null,args:Object=null],...
		 */
		public function SLinkedList( ...args )
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
			if ( ! _head ) _head = _tail = new SListNode( 0, args[0][0], args[0][1], args[0][2], args[0][3], args[0][4] );
			else 
			{ 
				_tail.insertAfter( new SListNode( _tail.id + 1, args[0][0], args[0][1], args[0][2], args[0][3], args[0][4] ) ); 
				_tail = _tail.next; 
			}
			
			if ( args.length > 1 )
			{
				for ( var i:int = 1; i < args.length; i++)
				{
					node = new SListNode( _tail.id+1, args[i][0], args[i][1], args[i][2], args[i][3], args[i][4] );
					_tail.insertAfter(node);
					_tail = _tail.next;
				}
			}
			_length += args.length;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   			   UPDATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function update(name:String, data:*=null, group:String='', action:Function=null, args:Object=null):void 
		{
			var n:SListNode = getNodeByName( name );
			n.data = (data != null)?data:n.data;
			n.group = (group != '')?group:n.group;
			n.action = (action != null)?action:n.action;
			n.args = (args != null)?args:n.args;
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		 INSERT AFTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertAfter( node:SListNode, name:String, data:*, group:String='', action:Function=null, args:Object=null ):void
		{
			node.insertAfter( new SListNode( node.id + 1, name, data, group, action, args ) );
			_length += 1;
			if ( node === _tail ) _tail = tail.next;
			else rebuildID();
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
			var current:SListNode = _head;
			var previous:SListNode = null;
			loop:while ( current )
			{
				if ( value is String ) type = 'name';
				else if ( value is int ) type = 'id';
				else  type = 'data';
				
				if (current[type] == value )
				{ 
					removeNode( current, previous );
					result = true;
					break loop; 
				}	
				else result = false;
				previous = current;
				current = current.next;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		DIRECT REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function removeNode( n:SListNode, p:SListNode ):void
		{
			if ( _length > 1 )
			{
				if ( n == _head ) _head = _head.next;
				else if ( n == _tail ) _tail.next = null;
				else p.next = n.next;
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
			var current:SListNode = _head;
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
			var next:SListNode;
			var current:SListNode = _head;
			_head = null;
			while ( current )
			{
				next = current.next;
				current.next = null;
				current = next;
			}
			_tail = null;
			_length = 0;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GET OBJECT BY NAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getNodeByName( name:String ):SListNode
		{
			var result:*;
			var current:SListNode = _head;
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
		public function getNodeByID( id:int ):SListNode
		{
			var result:SListNode;
			var current:SListNode = _head;
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
			var current:SListNode = _head;
			loop:while ( current )
			{
				if (current.group == name ) { result.push( current ); break loop; }	
				else { result = null; }
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
			var current:SListNode = _head;
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
			var current:SListNode = _head;
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
		public function get head():SListNode { return _head; }
		
		public function get tail():SListNode { return _tail; }
		
		public function get length():int { return _length; }
	}
}