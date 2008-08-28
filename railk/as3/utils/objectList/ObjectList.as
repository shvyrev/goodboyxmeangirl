/**
* Object List
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.utils.objectList
{
	public class  ObjectList
	{
		// ____________________________________________________________________________ VARIABLES OBJECT LIST
		private var _head                                   :ObjectNode;
		private var _tail                                   :ObjectNode;
		private var _length                                 :int;
		private var node                                    :ObjectNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	...args    ['name',displayObject:*,'group'=null,function=null],...
		 */
		public function ObjectList( ...args ):void 
		{
			_head = _tail = null;
			if ( args.length > 0) add.apply( this, args );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   				  ADD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	...args    ['name',displayObject:*,'group'=null,function=null],...
		 */
		public function add( ...args ):void
		{
			if ( ! _head ) _head = _tail = new ObjectNode( 0, args[0][0], args[0][1], args[0][2], args[0][3] );
			else 
			{ 
				_tail.insertAfter( new ObjectNode( _tail.id + 1, args[0][0], args[0][1], args[0][2], args[0][3] ) ); 
				_tail = _tail.next; 
			}
			
			if ( args.length > 1 )
			{
				for ( var i:int = 1; i < args.length; i++)
				{
					node = new ObjectNode( _tail.id+1, args[i][0], args[i][1], args[i][2], args[i][3] );
					_tail.insertAfter(node);
					_tail = _tail.next;
				}
			}
			_length += args.length;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		 INSERT AFTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertAfter( node:ObjectNode, name:String, object:*, group:String='', action:Function=null ):void
		{
			node.insertAfter( new ObjectNode( node.id + 1, name, object, group, action ) );
			_length += 1;
			if ( node === _tail ) _tail = tail.next;
			else rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		INSERT BEFORE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertBefore( node:ObjectNode, name:String, object:*, group:String='', action:Function=null ):void
		{
			node.insertBefore( new ObjectNode( node.id - 1, name, object, group, action ) );
			_length += 1;
			if ( node === _head ) _head = _head.prev;
			rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		       REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function remove( name:String ):Boolean
		{
			var result:Boolean;
			var current:ObjectNode = _head;
			loop:while ( current )
			{
				if (current.name == name )
				{ 
					removeObjectNode( current );
					result = true;
					break loop; 
				}	
				else { result = false; }	
				current = current.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		DIRECT REMOVE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function removeObjectNode( o:ObjectNode ):void
		{
			if ( _length > 1 )
			{
				if ( o == _head )
				{
					_head = _head.next;
					_head.prev = null;
				}
				else if (o == _tail )
				{
					_tail = _tail.prev;
					_tail.next = null;
				}
				else
				{
					o.prev.next = o.next;
					o.next.prev = o.prev;
				}
			}
			else 
			{ 
				_tail = _head = null; 
			}
			o.dispose();
			_length -= 1;
			rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   REBUILD ID
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function rebuildID():void {
			var current:ObjectNode = _head;
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
			var next:ObjectNode;
			var current:ObjectNode = _head;
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
		public function getObjectByName( name:String ):ObjectNode
		{
			var result:*;
			var current:ObjectNode = _head;
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
		public function getObjectByID( id:int ):ObjectNode
		{
			var result:ObjectNode;
			var current:ObjectNode = _head;
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
		public function getObjectByGroup( name:String ):Array
		{
			var result:Array = new Array();
			var current:ObjectNode = _head;
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
			var current:ObjectNode = _head;
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
			var current:ObjectNode = _head;
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
		public function get head():ObjectNode { return _head; }
		
		public function get tail():ObjectNode { return _tail; }
		
		public function get length():int { return _length; }
	}
}