/**
* Object List
* 
* @author Richard Rodney
* @version
*/


package railk.as3.utils.objectList
{
	public class  ObjectList
	{
		// ____________________________________________________________________________ VARIABLES OBJECT LIST
		private var _head                                   :ObjectNode;
		private var _tail                                   :ObjectNode;
		private var _nodes                                  :Number;
		private var node                                    :ObjectNode;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	...args    ['name',*]
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
		 * @param	...args
		 */
		public function add( ...args ):void
		{
			if ( !head ) _head = _tail = new ObjectNode( 1, args[0][0], args[0][1] );
			else _tail.insertAfter( new ObjectNode( _tail.id+1, args[0][0], args[0][1] ) );
			
			if ( args.length > 1 )
			{
				for ( var i:int = 1; i < args.length; i++)
				{
					node = new ObjectNode( _tail.id+1, args[i][0], args[i][1] );
					_tail.insertAfter(node);
					_tail = _tail.next;
				}
			}
			_nodes += args.length;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   			  ITERATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function iterate( value:int ):ObjectNode
		{
			var result:ObjectNode;
			var current:ObjectNode = _head;
			loop:while ( current )
			{
				if (current.id == value ){ result = current;  break loop; }	
				else { result = null; }	
				current = current.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GET OBJECT BY NAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public function getObjectByName( name:String ):*
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
		
		public function get nodes():Number { return _nodes; }
	}
	
}