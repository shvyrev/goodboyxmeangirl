﻿/**
* 
* Object Pool Class
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.pool {
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.list.*;

	public class Pool
	{
		// ____________________________________________________________________________ VARIABLES RAPATRIEES
		private var _growth_rate                                     :int = 0x10;
		private var _capacity                                        :int = _growth_rate << 1;
		private var _max_capacity                                    :int = _capacity * 10;
		private var _object                                          :Class;
		private var _factory                                         :PoolFactory;
		
		// __________________________________________________________________________________ VARIABLES POOL
		private var freeObject                                       :int=0;
		private var pool                                             :DLinkedList;
		private var walker                                           :DListNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Pool( object:Class, factory:PoolFactory, capacity:int=0, growth_rate:int=0 ): void
		{
			_object = object;
			_factory = factory;
			if ( capacity ) _capacity = capacity;
			if ( growth_rate ) _growth_rate = growth_rate;
			pool = new ObjectList();
			
			var i:int = _capacity;
			while( --i > -1 )
				pool.add( [String(i), new object(),'free'] );

			freeObject = _capacity;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   CREATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create( name, ...args ):*
		{
			if( !freeObject )
			{
				var i: int = _growth_rate;
				while( --i > -1 )
					pool.insertBefore( pool.head, String(pool.length+1), new _object() );
				
				freeObject = _growth_rate;
				
				return create( args );
			}
			else
			{
				freeObject--;
				
				walker = pool.head;
				loop:while ( walker ) {
					if ( walker.group == 'free' )
					{
						var o:* = walker.data;
						walker.group = 'used';
						walker.name = name;
						break loop;
					}
					walker = walker.next;
				}
				
				_factory.initObject( o,args );
				return o;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  RELEASE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function release( name, object:* ): void
		{
			freeObject++;
			var n:DListNode = pool.getNodeByName( name );
			n.data = object;
			n.name = String( pool.length+1 );
			n.group = 'free';
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								PURGE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function purge(): void
		{
			walker = pool.head;
			loop:while ( walker ) {
				walker.data = null;
				walker = walker.next;
			}
			pool.clear();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toString():String
		{
			return pool.toString();
		}
	}
}