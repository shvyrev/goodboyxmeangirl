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
	import railk.as3.display.GraphicShape;
	import railk.as3.tween.process.*;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	import railk.as3.event.CustomEvent;
	import railk.as3.utils.drag.DragAndThrow;
	
	
	public class ScrollList extends Sprite {
		
		// _____________________________________________________________________________ VARIABLES SCROLLIST
		public var orientation                                  :String;
		public var size	                                     	:Number;
		public var espacement                                   :int;
		
		// _______________________________________________________________________________ VARIABLES CONTENT
		public var content                                       :Sprite;
		private var scrollListSize                             	 :Number;
		private var objects                                      :ObjectList;
		private var walker                                       :ObjectNode;
		private var rectSize                                     :Number = 1;
		private var delta                                        :Number = 14;
		private var oldX	                                	 :Number;
		private var oldY	                                	 :Number;
		
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
		public function ScrollList( name:String='', orientation:String='V', size:Number=200, espacement:int=10 ):void 
		{	
			this.name = name;
			this.orientation = orientation;
			this.espacement = espacement;
			this.size = this.scrollListSize = size;
			
			objects = new ObjectList();			
			content = new Sprite();
			addChild( content );
			
			if ( orientation == 'V' ) content.scrollRect = new Rectangle( 0,0,rectSize,size );
			else if ( orientation == 'H' ) content.scrollRect = new Rectangle( 0, 0, size, rectSize );
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
			objects.add( [ name, new ScrollListItem( name, o, this.name ) ] );
			objects.getObjectByName( name ).data.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
		}
		
		public function insertBefore( name:String, o:*):void
		{
			objects.insertBefore( objects.head, name, new ScrollListItem( name, o, this.name ));
			objects.getObjectByName( name ).data.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	  REMOVE OBJECT TO THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 */
		public function remove( name:String):Boolean 
		{ 
			objects.getObjectByName( name ).data.removeEventListener( 'onScrollItemChange', manageEvent);
			return  objects.remove( name );
		}	
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		CREATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void 
		{
			var place = 0;
			walker = objects.head;
			while ( walker ) 
			{
				var obj:* = walker.data.o;
				content.addChild( obj );
				if ( orientation == 'V' )
				{
					if ( obj.width > rectSize ) {
						rectSize = obj.width;
						content.scrollRect = new Rectangle( 0,0,rectSize,size );
					}
					
					obj.y = place;
					place += obj.height + espacement;
				}
				else if ( orientation == 'H' )
				{
					if ( obj.height > rectSize ) {
						rectSize = obj.height;
						content.scrollRect = new Rectangle( 0,0,size,rectSize );
					}
					
					obj.x = place;
					place += obj.width + espacement;
				}
				walker = walker.next;
			}
			
			var fond:GraphicShape = new GraphicShape();
			fond.name = "bg";
			if ( orientation == 'V' ) fond.rectangle(0xff0000, 0, 0, rectSize, scrollListSize );
			else if ( orientation == 'H' ) fond.rectangle(0xffffff, 0, 0, scrollListSize , rectSize);
			fond.alpha = 0;
			addChildAt(fond, 0);
			
			this.oldX = content.scrollRect.x;
			this.oldY = content.scrollRect.y;
			
			///////////////////////////////
			initListeners();
			///////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		UPDATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function update( name:String, o:*, head:Boolean=false ):void 
		{	
			if (head)
			{
				this.content.addChild( o );
				o.y = objects.head.data.y - espacement - o.height;
				insertBefore( name, o );
			}
			else 
			{
				this.content.addChild( o );
				o.y = objects.tail.data.y + o.height + espacement
				add( name, o );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			this.buttonMode = true;
			this.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			this.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			this.buttonMode = true;
			this.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			this.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize():void {
			if ( orientation == 'V' ) 	content.scrollRect = new Rectangle( 0,0,rectSize,size );
			else if ( orientation == 'H' ) content.scrollRect = new Rectangle( 0,0,size,rectSize );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			delListeners();
			content = null;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String
		{
			return '[ SCROLL_LIST > ' + name + ', ( orientation : ' + orientation + ' ), ( size : ' + size + ' ), ( espacement : ' + espacement + ' ) ]';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     				 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void 
		{
			var args:Object = new Object();
			var eEvent:*;
			var rect:Rectangle = content.scrollRect;
			var value:Number;
			switch( evt.type )
			{
				case 'onScrollItemChange' :
					dispatchEvent( new CustomEvent( evt.type, { item:evt.item}) );
					break;
					
				case Event.ENTER_FRAME :
					if ( orientation == "V" ) 
					{
						if ( oldY != content.scrollRect.y )
						{
							dispatchEvent( new CustomEvent( 'onScrollListMove', { item:this, x:content.scrollRect.x, y:content.scrollRect.y  } ) );
						}
					}
					else if ( orientation == "H" ) 
					{
						if ( oldX != content.scrollRect.x )
						{
							dispatchEvent( new CustomEvent( 'onScrollListMove', { item:this, x:content.scrollRect.x, y:content.scrollRect.y } ) );
						}
					}
					break;
				
				case Event.RESIZE :
					resize();
					///////////////////////////////////////////////////////////////
					args = { info:name+' height change', data:name };
					eEvent = new CustomEvent( 'onScrollResize', args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
				
				case MouseEvent.ROLL_OVER :
					stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true );
					///////////////////////////////////////////////////////////////
					args = { info:name+' height change', name:this.name };
					eEvent = new CustomEvent( 'onScrollListOver', args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.ROLL_OUT :
					stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent );
					///////////////////////////////////////////////////////////////
					args = { info:name+' height change', name:this.name };
					eEvent = new CustomEvent( 'onScrollListOut', args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case MouseEvent.MOUSE_WHEEL :
					if ( orientation == "V" ) {
						DragAndThrow.drag( this.name, rect.x, rect.y - (evt.delta * delta) );
						/*if ( rect.y >= 0 + evt.delta*delta  && rect.y <= rect.height+ evt.delta*delta  ) {
							Process.to( rect, .4, { y:rect.y - (evt.delta * delta) }, { onUpdate:function() { content.scrollRect = rect; } } );
						}
						else if( rect.y < 0 + evt.delta*delta ) {
							Process.to( rect, .4, { y: 0}, { onUpdate:function() { content.scrollRect = rect; } } );
						}
						else if ( rect.y > rect.height + evt.delta*delta ) {
							Process.to( rect, .4, { y:rect.height }, { onUpdate:function() { content.scrollRect = rect; } } );
						}*/
					}
					else if ( orientation == "H" ) {
						if ( rect.x >= 0 + evt.delta*delta && rect.x <= rect.width + evt.delta*delta ) {
							Process.to( rect, .4, { x: rect.x + (evt.delta * delta)}, { onUpdate:function() { content.scrollRect = rect; } } );
						}
						else if( rect.x < 0 + evt.delta*delta ) {
							Process.to( rect, .4, { x: 0 }, { onUpdate:function() { content.scrollRect = rect; } } );
						}
						else if ( rect.x > rect.height+evt.delta*delta ) {
							Process.to( rect, .4, { x:rect.width }, { onUpdate:function() { content.scrollRect = rect; } } );
						}
					}
					break;
			}
		}
	}
}