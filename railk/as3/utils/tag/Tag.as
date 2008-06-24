	
/**
* 
*  TAG
* 
* 
* @author Richard Rodney
* @version 0.1
* 
*/

package railk.as3.utils.tag {
	
	// ___________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	
	

	public class Tag extends Object  {
		
		//_____________________________________________________________________________________ VARIABLES TAG
		private var nom                                     :String;
		private var occurences                              :Number = 0;
		
		// _________________________________________________________________________________ VARIABLES LISTES
		private var fileAssociated                			:DLinkedList;
		private var walker                                  :DListNode;
		private var itr                                     :DListIterator;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Tag( name:String, displayObjectName:String ):void {
			occurences +=  1;
			fileAssociated = new DLinkedList();
			fileAssociated.append( displayObjectName );
			nom = name;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				             ADD FILE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addFile( displayObjectName:String ):void {
			occurences += 1;
			fileAssociated.append( displayObjectName );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function removeFile( file:String ):Boolean {
			var result:Boolean;
			walker = fileAssociated.head;
			
			while ( walker ) {
				if ( walker.data == file ) {
					itr = new DListIterator(fileAssociated, walker);
					itr.remove();
					result = true;
				}
				else {
					result = false;
				}
				walker = walker.next;
			}
			return result;
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			walker = fileAssociated.head;
			
			while ( walker ) {
				walker.data = null;
				walker = walker.next;
			}
			
			fileAssociated.clear();
			occurences = 0;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get name():String {
			return nom;
		}
		
		public function getfile( file:String ):Boolean {
			var result:Boolean;
			walker = fileAssociated.head;
			
			while ( walker ) {
				if ( walker.data == file ) {
					result = true;
				}
				else {
					result = false;
				}
				walker = walker.next;
			}
			return result;
		}
		
		public function get value():Number {
			return occurences;
		}
	}
	
}