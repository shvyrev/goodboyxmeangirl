/**
* 
* ScrollList class
* 
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.scrollList {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.event.CustomEvent;
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	import railk.as3.tween.process.*;
	import railk.as3.utils.Clone;
	
	
	public class ScrollList extends Sprite {
		
		// _____________________________________________________________________________ VARIABLES SCROLLIST
		public var orientation                                  :String;
		public var size	                                     	:Number;
		public var oldSize	                                    :Number=0;
		public var espacement                                   :int;
		public var full                                         :Boolean = false;
		
		// _______________________________________________________________________________ VARIABLES CONTENT
		public var content                                      :Sprite;
		private var fond   										:GraphicShape;
		public var objectsSize                             		:Number;
		public var objects                                     	:DLinkedList;
		private var walker                                      :DListNode;
		private var rectSize                                    :Number = 1;
		private var delta                                       :Number = 70;
		private var oldX	                                	:Number;
		private var oldY	                                	:Number;
		private var bound                                       :Boolean = false;
		private var linked                                      :Boolean = false;
		private var oldStageH                  					:Number;
		private var oldStageW                  					:Number;
		private var lastTail                                    :Object;
		private var lastHead                                    :Object;
		private var headClone                                   :*;
		private var tailClone                                   :*;
		
		
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
		public function ScrollList( name:String='', orientation:String='V', size:Number=1, espacement:int=1, linked=false, bound=true ):void 
		{	
			this.name = name;
			this.orientation = orientation;
			this.espacement = espacement;
			this.size = this.oldSize = size;
			this.bound = bound;
			this.linked = linked;
			
			objects = new DLinkedList();			
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
			objects.getNodeByName( name ).data.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
			lastTail = { x:objects.tail.data.x + objects.tail.data.width + espacement, y:objects.tail.data.y + objects.tail.data.height + espacement };
		}
		
		public function insertBefore( name:String, o:*):void
		{
			objects.insertBefore( objects.head, name, new ScrollListItem( name, o, this.name ));
			objects.getNodeByName( name ).data.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
			lastTail = { x:objects.tail.data.x + objects.tail.data.width + espacement, y:objects.tail.data.y + objects.tail.data.height + espacement };
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
			objectsSize -= objects.getNodeByName( name ).data.height + espacement;
			objects.getNodeByName( name ).data.removeEventListener( 'onScrollItemChange', manageEvent);
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
			objectsSize = place;
			
			fond = new GraphicShape();
			if ( orientation == 'V' ) fond.rectangle(0xff0000, 0, 0, rectSize, size );
			else if ( orientation == 'H' ) fond.rectangle(0xffffff, 0, 0, size , rectSize);
			fond.alpha = 0;
			addChildAt(fond, 0);
			
			this.oldStageH = stage.stageHeight;
			this.oldStageW = stage.stageWidth;
			this.oldX = content.scrollRect.x;
			this.oldY = content.scrollRect.y;
			if ( objects.tail.data.y >= size - objects.tail.data.height - espacement ) full = true;
			lastHead = { x:objects.head.data.x - (objects.head.data.width + espacement), y:objects.head.data.y - (objects.head.data.height + espacement) };
			
			
			///////////////////////////////
			initListeners();
			///////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		   GESTION DES CLONES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function enableClones( head:*, tail:*, first:Boolean=false):void
		{
			if ( head )
			{
				headClone = Clone.deep( head );
				addClone( 'headclone', headClone, first );
			}
			if ( tail )
			{
				tailClone = Clone.deep( tail );
				addClone( 'tailclone', tailClone, first );
			}	
		}
		
		private function addClone( name:String, clone:*, first:Boolean ):void
		{
			if ( name == 'headclone' ) {
				var h:Number = ((first)? clone.height+espacement : 0);
				clone.y =  objects.head.data.y -( h );
			}
			else if ( name == 'tailclone' ) {
				clone.y = objects.tail.data.y + (objects.tail.data.height + espacement);
			}
			clone.name = name;
			content.addChild( clone );
		}
		
		public function removeClones():void
		{
			if (headClone != null) {
				content.removeChild( headClone );
				headClone = null;
			}
			if (tailClone != null) {
				content.removeChild( tailClone );
				tailClone = null;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		UPDATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function update( name:String, o:*, headClone:*=null, tailClone:*=null, head:Boolean = false ):void 
		{	
			
			//////////////////////////////////////////////////////////
			if ( linked ) removeClones();
			//////////////////////////////////////////////////////////
			
			if (head)
			{
				this.content.addChild( o );
				if ( objects.head ) {
					o.y = objects.head.data.y - espacement - objects.head.data.height;
					insertBefore( name, o );
				}
				else {
					o.y = lastHead.y;
					add( name, o );
				}
			}
			else 
			{
				this.content.addChild( o );
				if ( objects.tail ) o.y = objects.tail.data.y + objects.tail.data.height + espacement
				else o.y =  lastTail.y;
				add( name, o );
			}
			objectsSize += o.height + espacement;
			
			//////////////////////////////////////////////////////////
			if ( linked ) enableClones( headClone, tailClone, head );
			//////////////////////////////////////////////////////////
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
			if(!linked) stage.addEventListener( Event.RESIZE, manageEvent, false, 0 , true );
		}
		
		public function delListeners():void {
			this.buttonMode = false;
			this.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			this.removeEventListener( Event.ENTER_FRAME, manageEvent );
			if(!linked) stage.removeEventListener( Event.RESIZE, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize():void {
			if ( orientation == 'V' ) {
				size = (size * stage.stageHeight) / oldStageH;
				oldStageH = stage.stageHeight;
				fond.rectangle(0xff0000, 0, 0, rectSize, size );
				content.scrollRect = new Rectangle( 0, 0, rectSize, size );
			}
			else if ( orientation == 'H' ) {
				size = (size * stage.stageWidth) / oldStageW;
				oldStageW = stage.stageWidth;
				fond.rectangle(0xffffff, 0, 0, size , rectSize);
				content.scrollRect = new Rectangle( 0, 0, size, rectSize );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			delListeners();
			this.removeChild( content );
			this.removeChild( fond );
			
			walker = objects.head;
			while ( walker )
			{
				walker.data.dispose();
				walker = walker.next;
			}
			
			objects = null;
			content = null;
			fond = null;
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
						if ( oldY != rect.y )
						{
							dispatchEvent( new CustomEvent( 'onScrollListMove', { item:this, x:rect.x, y:rect.y  } ) );
						}
					}
					else if ( orientation == "H" ) 
					{
						if ( oldX != rect.x )
						{
							dispatchEvent( new CustomEvent( 'onScrollListMove', { item:this, x:rect.x, y:rect.y } ) );
						}
					}
					break;
				
				case Event.RESIZE :
					if(!linked) resize();
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
					if ( !bound )
					{
						if ( orientation == "V" ) {
							if ( evt.delta != 0) { Process.to( rect, 1, { y:rect.y + evt.delta * delta }, { onUpdate:function(){ content.scrollRect = rect; } } ); }
						}
						else if ( orientation == "H" ) {
							if ( evt.delta != 0) { Process.to( rect, 1, { x:rect.x + evt.delta * delta }, { onUpdate:function(){ content.scrollRect = rect; } } ); }
						}
					}
					else
					{
						if (orientation == "V" ) 
						{
							if ( rect.y >= 0 + evt.delta * delta  && rect.y <= rect.height + evt.delta * delta  ) Process.to( rect, .4, { y: rect.y - (evt.delta * delta)} , {  onUpdate:function(){ content.scrollRect = rect; } } );
							else if ( rect.y < 0 + evt.delta * delta ) Process.to( rect, .4, { y: 0}, { onUpdate:function(){ content.scrollRect = rect; } } );
							else if ( rect.y > rect.height + evt.delta * delta ) Process.to( rect, .4, { y:rect.height }, { onUpdate:function(){ content.scrollRect = rect; } } );
						}
						else if (orientation == "H" ) 
						{
							if ( rect.x >= 0 + evt.delta*delta && rect.x <= rect.width + evt.delta*delta ) Process.to( rect, .4, { x: rect.x - (evt.delta * delta)} , { onUpdate:function(){ content.scrollRect = rect; } } );
							else if( rect.x < 0 + evt.delta*delta ) Process.to( rect, .4, { x: 0 }, { onUpdate:function(){ content.scrollRect = rect; } } );
							else if ( rect.x > rect.height+evt.delta*delta ) Process.to( rect, .4, { x:rect.width }, { onUpdate:function(){ content.scrollRect = rect; } } );
						}
					}
					break;
			}
		}
	}
}