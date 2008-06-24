/**
* 
* ScrollList class
* 
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	
	
	public class ScrollList extends Sprite {
		
		// _____________________________________________________________________________ VARIABLES SCROLLIST
		private var _name                                        :String;
		private var _orientation                                 :String;
		private var _width                                       :int;
		private var _height                                      :int;
		private var _espacement                                  :int;
		
		// _______________________________________________________________________________ VARIABLES CONTENT
		private var container                                    :Sprite;
		private var objects                                      :Array;
		private var scrollListSize                               :int;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	orientation   'V'|'H'
		 * @param	size          height or width depending on orientation
		 */
		public function ScrollList( name:String, orientation:String, width:int, height:int, espacement:int ):void {
			_name = name;
			_orientation = orientation;
			_espacement = espacement;
			_width = width;
			_height = height;
			
			//--init
			objects = new Array();
			
			//--Container + scrollListRect
			container = new Sprite();
			addChild( container );
			container.scrollRect = new Rectangle( 0,0,width,height );
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     ADD OBJECT TO THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	o
		 * @param	size
		 */
		public function add( o:*, size:int ):void {
			objects.push( { object:o, size:size } );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		CREATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void {
			//--vars
			var place = 0;
			
			//--mise ne place
			for (var i:int = 0; i < objects.length; i++)
			{
				var obj:* = objects[i].object;
				container.addChild( obj );
				if ( _orientation == 'V' ) obj.y = place;
				else if( _orientation == 'H' ) obj.x = place;
				place += objects[i].size + _espacement;
				container.addChild( obj );
			}
			
			//taille totale de la zone de scroll
			scrollListSize = place;
			
			//on ajoute un fond a thumbs pour le scroll
			var fond:GraphicShape = new GraphicShape();
			fond.name = "bg";
			if ( _orientation == 'V' ) fond.rectangle(0x000000, 0, 0, _width, scrollListSize );
			else if ( _orientation == 'H' ) fond.rectangle(0x000000, 0, 0, scrollListSize, _height);
			fond.alpha = 0;
			container.addChildAt(fond, 0);
			
			///////////////////////////////
			initListeners();
			///////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			   INIT LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void {
			container.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			container.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    DEL LSITENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function delListeners():void {
			container.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			container.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	   resize
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize( size:int ):void {
			if ( _orientation == 'V' ) 	container.scrollRect = new Rectangle( 0,0,_width,size );
			else if ( _orientation == 'H' ) container.scrollRect = new Rectangle( 0,0,size,_height );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			delListeners();
			container = null;
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     				 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case MouseEvent.ROLL_OVER :
					container.addEventListener(Event.ENTER_FRAME, manageEvent, false,0,true);
					break;
				
				case MouseEvent.ROLL_OUT :
					container.removeEventListener(Event.ENTER_FRAME, manageEvent );
					break;
				
				case Event.ENTER_FRAME :
					//--vars
					var rect:Rectangle = container.scrollRect;
					
					//--change
					if ( _orientation == 'V' )
					{
						if ( mouseY < _height && mouseY > _height-200 && rect.y < (scrollListSize-rect.height) )
						{
							rect.y += 13;
							container.scrollRect = rect;
						}
						else if ( mouseY > 0 && mouseY < 200 && rect.y > 0 )
						{
							rect.y -= 13;
							container.scrollRect = rect;
						}
					}
					else if (_orientation == 'H' )
					{
						if ( mouseX < _width && mouseX > _width-200 && rect.x < (scrollListSize-rect.width) )
						{
							rect.x += 13;
							container.scrollRect = rect;
						}
						else if ( mouseX > 0 && mouseX < 200 && rect.x > 0 )
						{
							rect.x -= 13;
							container.scrollRect = rect;
						}
					}
					break;
			}
		}
		
		
	}
	
}