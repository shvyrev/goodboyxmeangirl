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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.display.GraphicShape;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.utils.CustomEvent;
	import railk.as3.tween.process.*;
	
	
	public class ScrollList extends Sprite {
		
		// _____________________________________________________________________________ VARIABLES SCROLLIST
		private var _name                                        :String;
		private var _orientation                                 :String;
		private var _size	                                     :Number;
		private var _espacement                                  :int;
		
		// _______________________________________________________________________________ VARIABLES CONTENT
		private var container                                    :Sprite;
		private var objects                                      :ObjectList;
		private var walker                                       :ObjectNode;
		private var scrollListSize                               :Number;
		private var rectSize                                     :Number = 1;
		private var delta                                        :Number = 14;
		private var oldMouseY                                	 :Number=0;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	orientation   'V'|'H'
		 * @param	width
		 * @param	height
		 * @param	espacement
		 */
		public function ScrollList( name:String, orientation:String, size:Number, espacement:int ):void 
		{
			_name = name;
			_orientation = orientation;
			_espacement = espacement;
			_size = size;
			
			//--init
			objects = new ObjectList();
			
			//--Container + scrollListRect
			container = new Sprite();
			addChild( container );
			if ( _orientation == 'V' ) container.scrollRect = new Rectangle( 0,0,rectSize,size );
			else if ( _orientation == 'H' ) container.scrollRect = new Rectangle( 0,0,size,rectSize );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     ADD OBJECT TO THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	o
		 */
		public function add( name:String,  o:* ):void 
		{ 
			objects.add( [ name, o ] );
		}	
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		CREATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void 
		{
			var place = 0;
			var count:int = 0;
			//--mise ne place
			walker = objects.head;
			while ( walker ) 
			{
				var obj:* = walker.data;
				container.addChild( obj );
				if ( _orientation == 'V' )
				{
					if ( obj.width > rectSize ) {
						rectSize = obj.width;
						container.scrollRect = new Rectangle( 0,0,rectSize,_size );
					}
					
					obj.y = place;
					place += obj.height + _espacement;
				}
				else if ( _orientation == 'H' )
				{
					if ( obj.height > rectSize ) {
						rectSize = obj.height;
						container.scrollRect = new Rectangle( 0,0,_size,rectSize );
					}
					
					obj.x = place;
					place += obj.width + _espacement;
				}
				count++;
				walker = walker.next;
			}
			trace( count );
			
			//taille totale de la zone de scroll
			scrollListSize = place;
			//on ajoute un fond a thumbs pour le scroll
			var fond:GraphicShape = new GraphicShape();
			fond.name = "bg";
			if ( _orientation == 'V' ) fond.rectangle(0xffffff, 0, 0, rectSize, scrollListSize );
			else if ( _orientation == 'H' ) fond.rectangle(0xffffff, 0, 0, scrollListSize, rectSize);
			fond.alpha = 0;
			container.addChildAt(fond, 0);
			
			///////////////////////////////
			initListeners();
			///////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			container.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			container.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			container.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			container.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			StageManager._stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			container.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			container.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			container.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			container.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			StageManager._stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	   resize
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize():void {
			if ( _orientation == 'V' ) 	container.scrollRect = new Rectangle( 0,0,rectSize,_size );
			else if ( _orientation == 'H' ) container.scrollRect = new Rectangle( 0,0,_size,rectSize );
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
		private function manageEvent( evt:* ):void 
		{
			var args:Object = new Object();
			var eEvent:*;
			var rect:Rectangle = container.scrollRect;
			var value:Number;
			switch( evt.type )
			{
				/*case Event.ENTER_FRAME:
					if ( content.height != contentCheck.height || content.width != contentCheck.width ) {
						contentCheck.height = content.height;
						contentCheck.width = content.width;
						resize();
					}
					break;*/
				
				case StageManagerEvent.ONSTAGERESIZE :
					resize();
					///////////////////////////////////////////////////////////////
					args = { info:name+' height change', data:name };
					eEvent = new CustomEvent( 'onScrollResize', args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
				
				case MouseEvent.ROLL_OVER :
					///////////////////////////////////////////////////////////////
					args = { info:name+' height change', data:name };
					eEvent = new CustomEvent( 'onScrollOver', args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.ROLL_OUT :
					///////////////////////////////////////////////////////////////
					args = { info:name+' height change', data:name };
					eEvent = new CustomEvent( 'onScrollOut', args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.MOUSE_DOWN :
					oldMouseY = mouseY;
					trace( oldMouseY );
					StageManager._stage.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					container.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
					break;
					
				case MouseEvent.MOUSE_UP :
					oldMouseY = mouseY;
					StageManager._stage.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					container.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
					break;
					
				case MouseEvent.MOUSE_MOVE :
					if ( _orientation == "V" ) {
						trace( rect.y +' / '+ (oldMouseY-mouseY) );
						if ( rect.y > rect.height ) { value = rect.height; }
						else if ( rect.y < 0 ) { value = 0; }
						else { value = rect.y + (oldMouseY-mouseY); }
						Process.to( rect, .4, { y:value}, { onUpdate:function() { container.scrollRect = rect; } } );
					}
					else if ( _orientation == "H" ) {
						if ( mouseX >= rect.width ) { value = rect.width; }
						else if ( mouseX <= container.width ) { value = 0; }
						else { value = mouseX - container.width / 2; }
						Process.to( container, 1, { x:value} );
					}
					break;
					
				case MouseEvent.MOUSE_WHEEL :
					if ( _orientation== "V" ) {
						if ( rect.y >= 0 + evt.delta*delta  && rect.y <= rect.height+ evt.delta*delta  ) {
							Process.to( rect, .4, { y:rect.y - (evt.delta * delta) }, { onUpdate:function() { container.scrollRect = rect; } } );
						}
						else if( rect.y < 0 + evt.delta*delta ) {
							Process.to( rect, .4, { y: 0}, { onUpdate:function() { container.scrollRect = rect; } } );
						}
						else if ( rect.y > rect.height + evt.delta*delta ) {
							Process.to( rect, .4, { y:rect.height }, { onUpdate:function() { container.scrollRect = rect; } } );
						}
					}
					else if ( _orientation == "H" ) {
						if ( container.x >= 0 + evt.delta*delta && container.x <= rect.width + evt.delta*delta ) {
							Process.to( container, .4, { x: container.x + (evt.delta * delta)} );
						}
						else if( container.x < 0 + evt.delta*delta ) {
							Process.to( container, .4, { x: 0 } );
						}
						else if ( container.x > rect.height+evt.delta*delta ) {
							Process.to( container, .4, { x:rect.width } );
						}
					}
					break;
			}
		}
	}
}