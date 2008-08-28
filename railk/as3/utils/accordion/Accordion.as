/**
* 
* Accordion
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO
* 	rethink the whole class
* 
*/


package railk.as3.utils.accordion
{
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.accordion.AccordionEvent;
	import railk.as3.utils.accordion.accordionItem.AccordionItem;
	import railk.as3.utils.objectList.*;
	
	
	
	public class  Accordion extends DisplayObject {
		
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
		private static var itemList                         :ObjectList;
		private static var containerList                    :ObjectList;
		private var place                                   :ObjectNode;
		private var walker                                  :ObjectNode;		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Accordion( X:int, Y:int, W:int, H:int, itemsWidth:int, itemsHeight:int, dragableItem:Boolean=false ):void {
			//--list
			itemList = new ObjectList();
			containerList = new ObjectList();
			
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
			itemList.add( [name,acItem] );
			
			//--give place
			if ( itemList.length == 1 ){
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
		public function remove( name:String ):Boolean 
		{		
			return itemList.remove( name );
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void 
		{	
			itemList.clear()
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get item( name:String ):* 
		{
			return itemList.getObjectByName( name ).data.content;
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					     MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ){
				case AccordionEvent.ONITEM_OVER :
					break;
				
				case AccordionEvent.ONITEM_OUT :
					break;
					
				case AccordionEvent.ONITEM_ClICK :
					break;
				
				case AccordionEvent.ONSTARTDRAGITEM :
					break;
				
				case AccordionEvent.ONSTOPDRAGITEM :
					break;	
			}
		}
		
	}
	
}