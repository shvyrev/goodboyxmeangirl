/**
* Object List
* 
* @author Richard Rodney
* @version
*/


package railk.as3.utils.objectList
{
	import caurina.transitions.AuxFunctions;
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
		 * @param	...args    ['name',*,'group',function]
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
		 * @param	...args    ['name',*,'group'=null,function=null]
		 */
		public function add( ...args ):void
		{
			if ( !head ) _head = _tail = new ObjectNode( 0, args[0][0], args[0][1], args[0][2], args[0][3] );
			else _tail.insertAfter( new ObjectNode( _tail.id+1, args[0][0], args[0][1], args[0][2], args[0][3] ) );
			
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
		public function insertAfter( node:ObjectNode, name:String, object:*, group:String='', script:Function=null ):void
		{
			node.insertAfter( new ObjectNode( node.id + 1, name, object, group, script ) );
			_length += 1;
			if ( node === _tail ) _tail = tail.next;
			else rebuildID();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		INSERT BEFORE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function insertBefore( node:ObjectNode, name:String, object:*, group:String='', script:Function=null ):void
		{
			node.insertBefore( new ObjectNode( node.id - 1, name, object, group, script ) );
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
					if ( _length > 1 )
					{
						if ( current == _head )
						{
							_head = _head.next;
							_head.prev = null;
						}
						else if (current == _tail )
						{
							_tail = _tail.prev;
							_tail.next = null;
						}
						else
						{
							current.prev.next = current.next;
							current.next.prev = current.prev;
						}
					}
					else
					{
						_tail = _head = null;
					}
					current.dispose();
					
					_length -= 1;
					rebuildID();
					result = true;
					break loop; 
				}	
				else { result = false; }	
				current = current.next;
			}
			return result;
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
		// 																				   GET OBJECT BY NAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @return
		 */
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
		/**
		 * 
		 * @param	id
		 * @return
		 */
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
		/**
		 * 
		 * @param	name
		 * @return
		 */
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
		// 																				              ITERATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function iterate( id:int ):ObjectNode { return getObjectByID( id ); }
		
		
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