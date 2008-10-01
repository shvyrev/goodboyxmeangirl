/**
* 
* Accordion
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO: ENABLE MODIFICATION FROM THE CENTER OF THE ITEM OR NOT
* 
*/


package railk.as3.utils.accordion {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.accordion.AccordionEvent;
	import railk.as3.utils.objectList.*;
	import railk.as3.tween.process.*;
	
	
	
	public class  Accordion extends EventDispatcher {
		
		// _________________________________________________________________________ VARIABLES ACCORDION ITEM
		private var _type                                   :String;
		private var acItem                                  :AccordionItem;
		private var itemList                         		:ObjectList;
		private var prev                                    :ObjectNode;
		private var next                                    :ObjectNode;
		private var walker                                  :ObjectNode;		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	type	'V'|'H'
		 */
		public function Accordion( type:String ):void {
			_type = type;
			itemList = new ObjectList();
			
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
		public function add( name:String, content:Object ):Boolean 
		{
			acItem = new AccordionItem( name, _type, content );
			acItem.addEventListener( AccordionEvent.ON_HEIGHT_CHANGE, manageEvent, false, 0, true );
			acItem.addEventListener( AccordionEvent.ON_WIDTH_CHANGE, manageEvent, false, 0, true );
			itemList.add( [name,acItem] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   REMOVE AN ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function remove( name:String ):Boolean 
		{		
			return itemList.remove( name );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				PLACE ITEMS ON CHANGE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function placeItemFrom( itemName ):void
		{
			var item:ObjectNode = itemList.getObjectByName( itemName );
			if ( item == itemList.head )
			{
				walker = itemList.head.next;
				loop:while ( walker ) 
				{
					Process.to( walker.data.content, .3, {  walker.data.y:walker.prev.data.nextY } );
					walker = walker.next;
				}
			}
			else if (item != itemList.tail )
			{
				walker = item.next;
				loop:while ( walker ) {
					Process.to( walker.data.content, .3, {  walker.data.y:walker.prev.data.nextY } );
					walker = walker.next;
				}
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void 
		{	
			walker = itemList.head;
			loop:while ( walker ) {
				walker.data.dispose();
				walker = walker.next;
			}
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
				case AccordionEvent.ON_WIDTH_CHANGE :
				case AccordionEvent.ON_HEIGHT_CHANGE :
					placeItemFrom(evt.data);
					break;
			}
		}
		
	}
	
}