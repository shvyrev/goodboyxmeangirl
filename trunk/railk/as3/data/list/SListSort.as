/**
* Single linked List Sort class
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO:
* 	ALPHABETIC SORT
*/


package railk.as3.data.list
{	
	
	public class  SListSort
	{
		// _______________________________________________________________________________________ CONSTANTES
		public static const NUMERIC                         :String = 'numeric';
		public static const ALPHA                           :String = 'alpha';
		public static const DESC                            :String = 'desc';
		public static const ASC                             :String = 'asc';
		
		// ____________________________________________________________________________ VARIABLES OBJECT LIST
		private static var sortedList                       :SLinkedList;	
		private static var walker                           :SListNode;	
		
		
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
		public static function sort( list:SLinkedList, sortType:String, sortMode:String, sortValue:String ):SLinkedList 
		{
			var result:SLinkedList;
			switch( sortType )
			{
				case NUMERIC:
					result = numericSort( list, sortMode, sortValue );
					break;
					
				case ALPHA :
					result = alphaSort( list, sortMode, sortValue );
					break;
				
				default : throw( new Error("this sort type doesn't exist");
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 NUMERICAL SORT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function numericSort(list:SLinkedList, mode:String, value:String):SLinkedList
		{
			var currentValue = list.head.data[value];
			var currentNode:SListNode;
			var previousNode:SListNode = null;
			
			sortedList = new SLinkedList();
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
							sortedList.insertAfter( previousNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = previousNode;
						}
						
						currentValue = walker.data[value];
						previousNode = walker;
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
							sortedList.insertAfter( previousNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = previousNode;
						}
						else {
							sortedList.insertAfter( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.next;
						}
						
						currentValue = walker.data[value];
						previousNode = walker;
						walker = walker.next;
					}
					break;
				
				default : throw( new Error("this sort type doesn't exist");
			}
			return sortedList;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					ALPHABETICAL SORT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function alphaSort(list:SLinkedList, mode:String, value:String):SLinkedList
		{
			sortedList = new SLinkedList();
			switch( mode )
			{
				case DESC :
					break;
					
				case ASC :
					break;
				
				default : throw( new Error('this type do no exist');
			}
			return sortedList;
		}
	}	
}