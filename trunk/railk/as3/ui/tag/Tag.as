/**
* 
*  TAG
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.ui.tag {
	
	// ___________________________________________________________________________________ IMPORT OBJECT LIST
	import railk.as3.data.list.*;
	

	public class Tag {
		
		//_____________________________________________________________________________________ VARIABLES TAG
		private var _name                                   :String;
		private var occurences                              :Number = 0;
		
		// _________________________________________________________________________________ VARIABLES LISTES
		private var fileAssociated                			:DLinkedList;
		private var walker                                  :DListNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Tag( name:String, displayObjectName:String ):void {
			occurences +=  1;
			_name = name;
			fileAssociated = new DLinkedList();
			fileAssociated.add( [displayObjectName,displayObjectName] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				             ADD FILE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addFile( displayObjectName:String ):void {
			occurences += 1;
			fileAssociated.add( [displayObjectName,displayObjectName] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		  REMOVE FILE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function removeFile( file:String ):Boolean { return fileAssociated.remove( file ); }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			fileAssociated.clear();
			occurences = 0;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get name():String { return _name; }
		
		public function file( file:String ):Boolean {
			var result:Boolean;
			if ( fileAssociated.getNodeByName( file ) ) result = true;
			else result = false;
			return result;
		}
		
		public function get value():Number { return occurences; }
	}
}