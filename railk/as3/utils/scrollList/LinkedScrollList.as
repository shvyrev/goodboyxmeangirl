/**
* 
* ScrollList class
* 
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.scrollList {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.drag.DragAndThrow;
	import railk.as3.utils.CustomEvent;
	
	
	public class LinkedScrollList extends Sprite {
		
		// _____________________________________________________________________________ VARIABLES SCROLLIST
		private var _name                                        :String;
		private var _orientation                                 :String;
		private var _size                                        :Number
		private var _espacement                                  :int;
		
		// _______________________________________________________________________________ VARIABLES CONTENT
		private var walker                                       :ObjectNode;
		private var objects                                      :ObjectList;
		private var scrollLists                                  :ObjectList;
		private var currentScrollList                            :int = 0;
		private var currentSize                                  :Number = 0;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	orientation   'V'|'H'
		 * @param	size
		 * @param	espacement
		 */
		public function LinkedScrollList( name:String, orientation:String, size:Number, espacement:int ):void 
		{
			_name = name;
			_orientation = orientation;
			_espacement = espacement;
			_size = size;
			
			objects = new ObjectList();
			scrollLists = new ObjectList();
			
			this.addEventListener( Event.ADDED_TO_STAGE, setup, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setup( evt:Event ):void
		{
			scrollLists.add( [currentScrollList,  new ScrollList( String(currentScrollList), _orientation, _size, _espacement )] );
			initScrollListeners( currentScroll() );
			
			DragAndThrow.init( stage );
			DragAndThrow.enable( String(currentScrollList), currentScroll(), _orientation, true );
			
			this.removeEventListener( Event.ADDED_TO_STAGE, setup );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																  ADD OBJECT TO THE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	o
		 */
		public function add( name:String, o:* ):void 
		{ 
			o.alpha = .3;
			if ( _orientation == 'V' ) currentSize += o.height+_espacement;
			else if ( _orientation == 'H' ) currentSize += o.width+_espacement;
			if ( currentSize >= _size + o.height )
			{
				objects.add( [name, o] );
				newScroll().add( name, o );
				DragAndThrow.enable( String(currentScrollList), currentScroll(), _orientation,true );
				currentSize = o.height+_espacement;
			}
			else
			{
				objects.add( [name, o] );
				currentScroll().add( name, o );
			}	
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 		CREATE NEW SCROLL WHEN NEEDED
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function newScroll():ScrollList 
		{
			currentScrollList += 1;
			scrollLists.add( [scrollLists.length,  new ScrollList( String(currentScrollList), _orientation, _size, _espacement )] );
			return scrollLists.getObjectByName( String(currentScrollList) ).data as ScrollList;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 		CREATE NEW SCROLL WHEN NEEDED
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function currentScroll():ScrollList
		{
			return scrollLists.getObjectByName( String(currentScrollList) ).data as ScrollList;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 	   CREATE THE LINKED SCROLL LISTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void {
			var X:Number = 0;
			walker = scrollLists.head;
			while ( walker ) 
			{
				walker.data.x = X;
				addChild( walker.data );
				walker.data.create();
				X += walker.data.width+_espacement;
				walker = walker.next;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 	   CREATE THE LINKED SCROLL LISTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initScrollListeners(scroll:ScrollList ):void 
		{
			scroll.addEventListener( 'onTop', manageEvent, false, 0, true );
			scroll.addEventListener( 'onBottom', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollOver', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollOut', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollResize', manageEvent, false, 0, true );
		}
		
		public function delScrollListeners( scroll:ScrollList ):void 
		{
			scroll.removeEventListener( 'onTop', manageEvent );
			scroll.removeEventListener( 'onBottom', manageEvent );
			scroll.addEventListener( 'onScrollOver', manageEvent );
			scroll.addEventListener( 'onScrollOut', manageEvent );
			scroll.addEventListener( 'onScrollResize', manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			objects.clear();
			walker = scrollLists.head;
			while ( walker ) 
			{
				delScrollListeners( walker.data );
				walker.data.dispose();
				walker = walker.next;
			}
			scrollLists.clear();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String 
		{
			return DragAndThrow.toString();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     				 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case 'onTop' :
					break;
					
				case 'onBottom' :
					break;	
			}
		}
	}
}