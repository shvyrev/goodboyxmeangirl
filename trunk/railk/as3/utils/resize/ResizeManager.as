/**
* 
* Static class ResizeManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.resize {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.resize.ResizeManagerEvent;
	import railk.as3.utils.resize.resizeItem.ResizeItem;
	
	// __________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	
	
	
	public class ResizeManager extends Object {
		
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                             :EventDispatcher;
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var itemList                           :DLinkedList;
		private static var walker                             :DListNode;
		private static var itr                                :DListIterator;
		
		//____________________________________________________________________________________ VARIABLES ITEM
		private static var item                               :ResizeItem;
		
		// _______________________________________________________________________________ VARIABLE EVENEMENT
		private static var eEvent                             :ResizeManagerEvent;
		
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init():void {
			itemList = new DLinkedList();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			 ADD ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	displayObject
		 * @param	actionType       'place' | 'personnal'
		 * @param	action
		 * @param	group
		 */
		public static function add( name:String, displayObject:*, action:Function, group:String='main' ):void {
			item = new ResizeItem( name, displayObject, group, action );
			itemList.append( item );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			MOVE ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 */
		public static function moveItem( name:String ):void {
			walker = itemList.head;
			while ( walker ) 
			{
				var i:ResizeItem = walker.data ;
				if ( i.name == name ) 
				{
					i.action.apply();
				}
				walker = walker.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		MOVE ALL ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 */
		public static function moveGroup( name:String='main' ):void {
			walker = itemList.head;
			while ( walker ) 
			{
				var i:ResizeItem = walker.data;
				if ( i.group == name ) 
				{
					i.action.apply();
				}
				walker = walker.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE ITEMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public static function remove( name:String ):void {
			walker = itemList.head;
			//--
			while ( walker ) 
			{
				//--
				var i:ResizeItem = walker.data ;
				if ( i.name == name ) {
					itr = new DListIterator(itemList, walker);
					itr.remove();
					
				}
				walker = walker.next;
			}
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:'removed'+ name +'item' };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ONE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		

		public function removeAll():void {
			walker = itemList.head;
			
			while ( walker ) {
				//suppression du node
				itr = new DListIterator(itemList, walker);
				itr.remove();
				//incrementation
				walker = walker.next;
			}
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"removed all item" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ALL, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		public static function getItemContent( name:String ):* {
			walker = itemList.head;
			
			while ( walker ) {
				//--
				if ( walker.data.name == name ) {
					var result = walker.data.content;
				}
				walker = walker.next;
			}
			return result;
		}
		
	}
	
}