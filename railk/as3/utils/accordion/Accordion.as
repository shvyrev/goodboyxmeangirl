/**
* 
* Accordion
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.accordion
{
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.accordion.AccordionEvent;
	import railk.as3.utils.accordion.accordionItem.AccordionItem;
	
	// __________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	
	
	public class  Accordion extends DisplayObject{
		
		// ______________________________________________________________________________ VARIABLES ACCORDION
		private var _X                                      :int;
		private var _Y                                      :int;
		private var _W                                      :int;
		private var _H                                      :int;
		private var dragable                                :Boolean;
		private var dragRect                                :Rectangle;
		private var action                                  :Function;
		
		// _________________________________________________________________________ VARIABLES ACCORDION ITEM
		private var acItem                                  :AccordionItem;
		private var acItemWidth                             :int;
		private var acItemheight                            :int;
		
		// _________________________________________________________________________________ VARIABLES LISTES
		private static var itemList                         :DLinkedList;
		private static var containerList                    :DLinkedList;
		private var place                                   :DListNode;
		private var walker                                  :DListNode;
		private var itr                                     :DListIterator;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Accordion( X:int, Y:int, W:int, H:int, itemsWidth:int, itemsHeight:int, dragableItem:Boolean=false ):void {
			//--list
			itemList = new DLinkedList();
			containerList = new DLinkedList();
			
			//--vars
			_X = X;
			_Y = Y;
			_W = W;
			_H = H;
			dragable = dragableItem;
			if ( dragable ) dragRect = new Rectangle( X, Y, W, H );
			else dragRect = null;
				
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					      SET ACTIONS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	f
		 */
		public function setActions( f:Function ):void {
			action = f;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  ADD AN ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	content
		 * @return
		 */
		public function add( name:String, content:* ):Boolean {
			
			//--create
			acItem = new AccordionItem( name, content, active, dragable, dragRect );
			
			//--add
			itemList.append( acItem );
			
			//--give place
			if ( itemList.size == 1 ){
				place = itemList.head;
			}
			else {
				place = place.next;
			}
			acItem.place = place;
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   REMOVE AN ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function remove( name:String ):Boolean {
			
			walker = itemList.head;
			while ( walker ) {
				if ( walker.data.name == name ) {
					itr = new DListIterator(itemList, walker);
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
		// 																					        TO ACTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function forAction( place:DListNode ):Object {
			var result:Object;
			var prevArray:Array = new Array();
			var nextArray:Array = new Array();
			
			//--the Object
			itr = new DListIterator(itemList, place);
			result.object = itr.data.content;
			
			//--previous Object
			itr = new DListIterator(itemList, place);
			while (itr.valid()){
				prevArray.push( itr.data.content )
				itr.back();
			}
			result.prev = prevArray;
			
			//--next object
			itr = new DListIterator(itemList, place);
			while (itr.valid()){
				prevArray.push( itr.data.content )
				itr.forth();
			}
			result.next = nextArray;
			
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			
			walker = itemList.head;
			while ( walker ) {
				walker.data.dispose();
				itr = new DListIterator(itemList, walker);
				itr.remove();
				walker = walker.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get item( name:String ):* {
			
			walker = itemList.head;
			while ( walker ) {
				if ( walker.data.name == name ) {
					result = walker.data.content;
				}
				else {
					result = null;
				}
				walker = walker.next;
			}
			return result;
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					     MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ){
				case AccordionEvent.ONITEM_OVER :
					action( "over", forAction( evt.item.place ) );
					break;
				
				case AccordionEvent.ONITEM_OUT :
					action( "out", forAction( evt.item.place ) );
					break;
					
				case AccordionEvent.ONITEM_ClICK :
					action( "click", forAction( evt.item.place ) );
					break;
				
				case AccordionEvent.ONSTARTDRAGITEM :
					action( "startdrag", forAction( evt.item.place ) );
					break;
				
				case AccordionEvent.ONSTOPDRAGITEM :
					action( "stopdrag", forAction( evt.item.place ) );
					break;	
			}
		}
		
	}
	
}