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
		private var activeScrollList                             :String;
		private var oldStageH                                    :Number;
		private var oldStageW                                    :Number;
		
		
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
			oldStageH = stage.stageHeight;
			oldStageW = stage.stageWidth;
			DragAndThrow.init( stage );
			DragAndThrow.addEventListener( 'onScrollListDrag', manageEvent, false, 0, true );
			this.removeEventListener( Event.ADDED_TO_STAGE, setup );
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			
			/////////////////////////////
			firstScroll();
			/////////////////////////////
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
		// 																 						   NEW SCROLL
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function firstScroll():void
		{
			scrollLists.add( [currentScrollList,  new ScrollList( String(currentScrollList), orientation, size, espacement,true,false )] );
			initScrollListeners( currentScroll() );
			DragAndThrow.enable( String(currentScrollList), currentScroll(), orientation, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 		CREATE NEW SCROLL WHEN NEEDED
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function newScroll():ScrollList 
		{
			currentScrollList += 1;
			scrollLists.add( [scrollLists.length,  new ScrollList( String(currentScrollList), orientation, size, espacement,true,false )] );
			initScrollListeners( currentScroll() );
			return scrollLists.getObjectByName( String(currentScrollList) ).data as ScrollList;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 		CREATE NEW SCROLL WHEN NEEDED
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function currentScroll():ScrollList
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
			
			walker = scrollLists.head;
			while ( walker ) 
			{
				if ( walker == scrollLists.head )
				{ 
					if (scrollLists.tail.data.full) walker.data.enableClones( scrollLists.tail.data.objects.tail.data.o, walker.next.data.objects.head.data.o );
					else walker.data.enableClones( null, walker.next.data.objects.head.data.o );
				}
				else if (walker == scrollLists.tail)
				{ 
					if (scrollLists.tail.data.full) walker.data.enableClones( walker.prev.data.objects.tail.data.o, scrollLists.head.data.objects.head.data.o );
					else walker.data.enableClones( walker.prev.data.objects.tail.data.o, null );
				}
				else walker.data.enableClones( walker.prev.data.objects.tail.data.o, walker.next.data.objects.head.data.o );
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
			scroll.addEventListener( 'onScrollListOver', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollListOut', manageEvent, false, 0, true );
		}
		
		public function delScrollListeners( scroll:ScrollList ):void 
		{
			scroll.removeEventListener( 'onScrollItemChange', manageEvent );
			scroll.removeEventListener( 'onScrollListMove', manageEvent );
			scroll.removeEventListener( 'onScrollListOver', manageEvent );
			scroll.removeEventListener( 'onScrollListOut', manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															   MOVE ITEMS TO MANAGE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function crossScrollItems( item:ScrollListItem ):void
		{
			var x:Number = item.oldX;
			var y:Number = item.oldY;
			var height:Number = item.height;
			var width:Number = item.width;
			var scrollname = item.scrollName;
			var scroll:ScrollList;
			var prevScroll:ScrollList;
			var nextScroll:ScrollList;
			var tailScroll:ScrollList;
			var headScroll:ScrollList;
			
			if ( orientation == 'V' )
			{
				if ( y + height  <= 0 )
				{
					if ( scrollLists.getObjectByName( scrollname ) ==  scrollLists.head && scrollLists.getObjectByName( scrollname ) == scrollLists.tail )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						tailScroll = scrollLists.tail.data;
						if( scroll.remove( item.name ) ) tailScroll.update( item.name, item.o );
					}
					else if ( scrollLists.getObjectByName( scrollname ) == scrollLists.head )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						tailScroll = scrollLists.tail.data;
						if( scroll.remove( item.name ) ) tailScroll.update( item.name, item.o );
					}
					else 
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						prevScroll = scrollLists.getObjectByName( scrollname ).prev.data;
						if ( scroll.remove( item.name ) ) prevScroll.update( item.name, item.o );
					}
				}
				else if ( y > size )
				{
					if ( scrollLists.getObjectByName( scrollname ) == scrollLists.head && scrollLists.getObjectByName( scrollname ) == scrollLists.tail )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						headScroll = scrollLists.head.data;
						if( scroll.remove( item.name ) ) headScroll.update( item.name, item.o, true );
					}	
					else if ( scrollLists.getObjectByName( scrollname ) == scrollLists.tail )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						headScroll = scrollLists.head.data;
						if( scroll.remove( item.name ) ) headScroll.update( item.name, item.o, true );
					}
					else 
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						nextScroll = scrollLists.getObjectByName( scrollname ).next.data;
						if( scroll.remove( item.name ) ) nextScroll.update( item.name, item.o, true );
					}
				}
			}
			else if ( orientation == 'H' )
			{
				if ( x + width  <= 0 )
				{
					if ( scrollLists.getObjectByName( scrollname ) ==  scrollLists.head && scrollLists.getObjectByName( scrollname ) == scrollLists.tail )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						tailScroll = scrollLists.tail.data;
						if( scroll.remove( item.name ) ) tailScroll.update( item.name, item.o );
					}
					else if ( scrollLists.getObjectByName( scrollname ) == scrollLists.head )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						tailScroll = scrollLists.tail.data;
						if( scroll.remove( item.name ) ) tailScroll.update( item.name, item.o );
					}
					else 
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						prevScroll = scrollLists.getObjectByName( scrollname ).prev.data;
						if ( scroll.remove( item.name ) ) prevScroll.update( item.name, item.o );
					}
				}
				else if ( x > size )
				{
					if ( scrollLists.getObjectByName( scrollname ) == scrollLists.head && scrollLists.getObjectByName( scrollname ) == scrollLists.tail )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						headScroll = scrollLists.head.data;
						if( scroll.remove( item.name ) ) headScroll.update( item.name, item.o, true );
					}	
					else if ( scrollLists.getObjectByName( scrollname ) == scrollLists.tail )
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						headScroll = scrollLists.head.data;
						if( scroll.remove( item.name ) ) headScroll.update( item.name, item.o, true );
					}
					else 
					{
						scroll = scrollLists.getObjectByName( scrollname ).data
						nextScroll = scrollLists.getObjectByName( scrollname ).next.data;
						if( scroll.remove( item.name ) ) nextScroll.update( item.name, item.o, true );
					}
				}
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
		// 															  				   				   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function resize():void
		{	
			if( scrollLists.length != 0)
			{
				walker = scrollLists.head;
				while ( walker )
				{
					DragAndThrow.disable( walker.data.name );
					delScrollListeners( walker.data );
					this.removeChild( walker.data );
					walker.data.dispose();
					walker = walker.next;
				}
				scrollLists.clear();
			}
			
			size = (size * stage.stageHeight) / oldStageH;
			currentScrollList = currentSize = 0;
			firstScroll();
			walker = objects.head;
			while (walker)
			{
				if ( orientation == 'V' ) currentSize += walker.data.height+espacement;
				else if ( orientation == 'H' ) currentSize += walker.data.width+espacement;
				if ( currentSize >= size + walker.data.height )
				{
					newScroll().add( walker.name, walker.data );
					DragAndThrow.enable( String(currentScrollList), currentScroll(), orientation,true );
					currentSize = walker.data.height+espacement;
				}
				else
				{
					currentScroll().add( walker.name, walker.data );
				}	
				walker = walker.next;
			}
			create();
			oldStageH = stage.stageHeight;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			objects.clear();
			walker = scrollLists.head;
			while ( walker ) 
			{
				DragAndThrow.disable( walker.data.name );
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
				case Event.RESIZE :
					resize();
					break;
					
				case 'onScrollItemChange' :
					crossScrollItems( evt.item );
					break;
					
				case 'onScrollListMove' :
					if( activeScrollList == evt.item.name ) moveLinkedScrollLists( evt.item, evt.x, evt.y );
					break;
					
				case 'onScrollListDrag' :
					activeScrollList = evt.name;
					break;
					
				case 'onScrollListOver' :
					break;
					
				case 'onScrollListOut' :
					break;	
			}
		}
	}
}