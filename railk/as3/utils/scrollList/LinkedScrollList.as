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
	import railk.as3.event.CustomEvent;
	
	
	public class LinkedScrollList extends Sprite {
		
		// _____________________________________________________________________________ VARIABLES SCROLLIST
		private var orientation                                 :String;
		private var size                                        :Number
		private var espacement                                  :int;
		
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
			this.name = name;
			this.orientation = orientation;
			this.espacement = espacement;
			this.size = size;
						
			objects = new ObjectList();
			scrollLists = new ObjectList();
			
			this.addEventListener( Event.ADDED_TO_STAGE, setup, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setup( evt:Event ):void
		{
			scrollLists.add( [currentScrollList,  new ScrollList( String(currentScrollList), orientation, size, espacement )] );
			initScrollListeners( currentScroll() );
			
			DragAndThrow.init( stage );
			DragAndThrow.enable( String(currentScrollList), currentScroll(), orientation, true );
			
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
			if ( orientation == 'V' ) currentSize += o.height+espacement;
			else if ( orientation == 'H' ) currentSize += o.width+espacement;
			if ( currentSize >= size + o.height )
			{
				objects.add( [name, o] );
				newScroll().add( name, o );
				DragAndThrow.enable( String(currentScrollList), currentScroll(), orientation,true );
				currentSize = o.height+espacement;
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
			scrollLists.add( [scrollLists.length,  new ScrollList( String(currentScrollList), orientation, size, espacement )] );
			initScrollListeners( currentScroll() );
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
				X += walker.data.width+espacement;
				walker = walker.next;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 	   CREATE THE LINKED SCROLL LISTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initScrollListeners(scroll:ScrollList ):void 
		{
			scroll.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollListMove', manageEvent, false, 0, true );
		}
		
		public function delScrollListeners( scroll:ScrollList ):void 
		{
			scroll.removeEventListener( 'onScrollItemChange', manageEvent );
			scroll.removeEventListener( 'onScrollListMove', manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															   MOVE ITEMS TO MANAGE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function crossScrollItems( item:ScrollListItem ):void
		{
			var x:Number = item.globalXY.x;
			var y:Number = item.globalXY.y;
			var height:Number = item.height;
			var width:Number = item.width;
			var scrollname = item.scrollName;
			var scroll:ScrollList;
			
			if ( orientation == 'V' )
			{
				if ( y + height  <= 0 )
				{
					if ( scrollLists.getObjectByName( scrollname ) != scrollLists.head )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						var prevScroll:ScrollList = scrollLists.getObjectByName( scrollname ).prev.data;
						prevScroll.update( item.name, item.o );
						scroll.remove( item.name );
					}
					else 
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						var nextScroll:ScrollList = scrollLists.getObjectByName( scrollname ).next.data;
						nextScroll.update( item.name, item.o );
						scroll.remove( item.name );
					}
				}
			}
			else if ( orientation == 'H' )
			{
				
			}
			
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															  				   MOVE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function moveLinkedScrollLists( item:ScrollList, x:Number, y:Number ):void
		{
			DragAndThrow.drag( item.name, x, y );
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
				case 'onScrollItemChange' :
					crossScrollItems( evt.item );
					break;
					
				case 'onScrollListMove' :
					moveLinkedScrollLists( evt.item, evt.x, evt.y );
					break;	
			}
		}
	}
}