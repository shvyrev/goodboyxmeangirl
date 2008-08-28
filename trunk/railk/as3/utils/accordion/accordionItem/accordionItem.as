/**
* accordionItem
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.accordion.accordionItem {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.accordion.AccordionEvent;
	import railk.as3.utils.objectList.ObjectNode;
	
	
	public class AccordionItem extends DisplayObject {
		
		
		// _________________________________________________________________________ VARIABLES ACCORDION ITEM
		private var _name                              :String;
		private var _place                             :ObjectNode;
		private var _content                           :*;
		private var _active                            :Boolean;
		private var _dragable                          :Boolean;
		private var rect                               :Rectangle;
		
		// __________________________________________________________________________________ VARIABLES EVENT
		private var eEvent                             :AccordionEvent;
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AccordionItem( name:String, content:*, active:Boolean=false, dragable:Boolean=false, dragRect:Rectangle=null ):void {
			_name = name;
			_content = content;
			_active = active;
			_dragable = dragable;
			rect = dragRect;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					GESTION LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			_content.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			_content.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			_content.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			if(_dragable ){
				_content.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
				_content.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			}	
		}
		
		public function delListeners():void {
			_content.removeEventListener( MouseEvent.CLICK, manageEvent );
			_content.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			_content.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			if(_dragable ){
				_content.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
				_content.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			}	
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			delListeners();
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function set place( o:ObjectNode ):void {
			_place = o;
		}
		
		public function get place():ObjectNode {
			return _place;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get content():* {
			return _content;
		}
		
		public function set isActive( o:Boolean ):void {
			_active = o;
		}
		
		public function get isActive():Boolean {
			return _active;
		}
		
		public function set isDragable( o:Boolean ):void {
			_dragable = o;
		}
		
		public function get isDragable():Boolean {
			return _dragable;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function private function manageEvent( evt:* ):void {
			var args:Object;
			switch( evt.type ){
				case MouseEvent.CLICK :
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"item clicked ", item:this; };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new AccordionEvent( AccordionEvent.ONITEM_ClICK, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
				
				case MouseEvent.ROLL_OVER :
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"item over ", item:this; };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new AccordionEvent( AccordionEvent.ONITEM_OVER, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.ROLL_OUT :
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"item out ", item:this; };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new AccordionEvent( AccordionEvent.ONITEM_OUT, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.MOUSE_UP :
					stopDrag();
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"item drag ", item:this; };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new AccordionEvent( AccordionEvent.ONSTOPDRAGITEM, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.MOUSE_DOWN :
					_content.startDrag(false, rect );
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"item stopdrag ", item:this; };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new AccordionEvent( AccordionEvent.ONSTARTDRAGITEM, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;	
			}
		}
		
	}
	
}