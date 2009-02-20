/**
* Object List Sort class
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO:
* 	ALPHABETIC SORT
*/


package railk.as3.data.list
{	
	
	public class  DListSort
	{
		// _______________________________________________________________________________________ CONSTANTES
		public static const NUMERIC                         :String = 'numeric';
		public static const ALPHA                           :String = 'alpha';
		public static const DESC                            :String = 'desc';
		public static const ASC                             :String = 'asc';
		
		// ____________________________________________________________________________ VARIABLES OBJECT LIST
		private static var sortedList                       :DLinkedList;	
		private static var walker                           :DListNode;	
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  SORT A LIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	list
		 * @param	sortType
		 * @param	sortMode
		 * @param	sortValue
		 * @return
		 */
		public static function sort( list:DLinkedList, sortType:String, sortMode:String, sortValue:String ):DLinkedList 
		{
			var result:DLinkedList;
			switch( sortType )
			{
				case NUMERIC:
					result = numericSort( list, sortMode, sortValue );
					break;
					
				case ALPHA :
					result = alphaSort( list, sortMode, sortValue );
					break;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 NUMERICAL SORT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function numericSort(list:DLinkedList, mode:String, value:String):DLinkedList
		{
			var currentValue = list.head.data[value];
			var currentNode:DListNode;
			sortedList = new DLinkedList();
			walker = list.head;
			
			switch( mode )
			{
				case DESC :
					while ( walker ) {
						if ( sortedList.length == 0 ) {
							sortedList.add( [walker.name, walker.data, walker.group, walker.action] );
							currentNode = sortedList.head;
						}
						else if ( walker.data[value] <= currentValue ) {
							sortedList.insertAfter( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.next;
						}
						else {
							sortedList.insertBefore( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.prev;
						}
						
						currentValue = walker.data[value];
						walker = walker.next;
					}
					break
					
				case ASC :
					while ( walker ) {
						if ( sortedList.length == 0 ) {
							sortedList.add( [walker.name, walker.data, walker.group, walker.action] );
							currentNode = sortedList.head;
						}
						else if ( walker.data[value] <= currentValue ) {
							sortedList.insertBefore( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.prev;
						}
						else {
							sortedList.insertAfter( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.next;
						}
						
						currentValue = walker.data[value];
						walker = walker.next;
					}
					break;
			}
			return sortedList;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					ALPHABETICAL SORT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function alphaSort(list:DLinkedList, mode:String, value:String):DLinkedList
		{
			sortedList = new DLinkedList();
			switch( mode )
			{
				case DESC :
					break;
					
				case ASC :
					break;
			}
			return sortedList;
		}
	}	
}