/**
* 
* Accordion
* 
* @author Richard Rodney
* @version 0.1 
*/


package railk.as3.ui.accordion 
{	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	public class  Accordion extends EventDispatcher 
	{
		private var type:String;
		private var item:AccordionItem;
		private var firstItem:AccordionItem;
		private var lastItem:AccordionItem;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * @param	type	'V'|'H'
		 */
		public function Accordion( type:String = 'V' ) {
			this.type = type;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  MANAGE ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function add( name:String, content:Object, separator:Number=0 ):void {
			item = new AccordionItem( name, _type, content, separator );
			item.addEventListener( AccordionEvent.ON_HEIGHT_CHANGE, manageEvent, false, 0, true );
			item.addEventListener( AccordionEvent.ON_WIDTH_CHANGE, manageEvent, false, 0, true );
			if (!firstItem) firstItem = lastItem = item;
			else {
				lastItem.next = item;
				item.prev = lastItem;
				lastItem ) item;
			}
		}
		
		public function remove( name:String ):void {		
			var i:AccordionItem = getFile(name);
			if (i.next) i.next.prev = i.prev;
			if (i.prev) i.prev.next = i.next;
			else if (firstItem == i) firstItem = i.next;
			i = null;
		}
		
		public function getItem( name:String ):AccordionItem {
			var walker:AccordionItem = firstItem;
			while ( walker ) {
				if (walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				PLACE ITEMS ON CHANGE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function placeItemFrom( name:String ):void {
			var i:AccordionItem = getItem( name ), walker:AccordionItem;
			if ( item == firstItem ) {
				walker = firstItem.next;
				while ( walker ) {
					walker.y = walker.prev.nextY;
					walker = walker.next;
				}
			} else if (item != lastItem ) {
				walker = item.next;
				while ( walker ) {
					walker.y=walker.prev.nextY;
					walker = walker.next;
				}
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {	
			var walker:AccordionItem = firstItem;
			firstItem = null;
			while ( walker ) {
				walker.dispose();
				walker = walker.next;
			}
			lastItem = null;
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