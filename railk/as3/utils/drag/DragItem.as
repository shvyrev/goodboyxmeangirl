/**
 * 
 * drag and trown object with bounds or not
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.drag
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class DragItem
	{
		private static var _bounds:Rectangle;
		private static var _o:Object;
		private static var _orientation:String;
		private static var _stage:Stage;
		
		private static var hasBound:Boolean = false;
		private static var isDragging:Boolean = false;
		private static var current:Number = 0;
		private static var last:Number = 0;
		private static var v:Number = 0;
		private static var offset:Number;
		private static var itemsList:ObjectList;
		private static var walker:ObjectNode
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   	 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function DragItem( stage:Stage, name:String, o:Object, orientation:String, bounds:Rectangle=null )
		{
			_stage = stage;
			_orientation = orientation;
			_o = o;
			if (bounds) 
			{
				hasBound = true;
				_bounds = bounds;
			}
			if ( orientation == 'V' ) current = last = o.y;
			else if ( orientation == 'H' ) current = last = o.x;
			
			////////////////////////////////////
			initListeners();
			////////////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				GESTION DES LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function initListeners():void 
		{
			_o.buttonMode = true;
			_o.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			_stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			_stage.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			
		}
		
		public static function delListeners():void 
		{
			_o.buttonMode = false;
			_o.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			_stage.removeEventListener( Event.ENTER_FRAME, manageEvent );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function dispose():void {
			delListeners();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:*):void 
		{
			switch( evt.type )
			{
				case MouseEvent.MOUSE_UP :
					isDragging = false;
					_stage.removeEventListener(MouseEvent.MOUSE_MOVE, manageEvent );
					break;
					
				case MouseEvent.MOUSE_DOWN :
					isDragging = true;
					offset = (_orientation == 'V')? _o.mouseY : _o.mouseX;
					_stage.addEventListener(MouseEvent.MOUSE_MOVE, manageEvent );
					break;
				
				case MouseEvent.MOUSE_MOVE :
					if ( _orientation == 'V' )
					{
						_o.y = _stage.mouseY - offset;
						if ( hasBound)
						{
							if(_o.y <= _bounds.top) _o.x = _bounds.top;
							else if (_o.y >= _bounds.bottom) _o.x = _bounds.bottom;
						}	
					}
					else if ( _orientation == 'H' )
					{
						_o.x = _stage.mouseX - offset;
						if ( hasBound)
						{
							if(_o.x <= _bounds.left) _o.x = _bounds.left;
							else if (_o.x >= _bounds.right) _o.x = _bounds.right;
						}	
					}
					evt.updateAfterEvent();
					break;
					
				case Event.ENTER_FRAME :
					if(isDragging)
					{
						last = current;
						current = (_orientation == 'V')? _stage.mouseY : _stage.mouseX;
						v = current - last;
					}	
					else
					{
						if( _orientation == 'V') _o.y += v;
						else if( _orientation == 'H') _o.x += v;
					}
					
					if ( hasBound)
					{
						if ( _orientation == 'V' )
						{
							if(_o.y <= _bounds.top)
							{
								_o.y  = _bounds.top;
								v *= -1;
							}
							else if(_o.y >= _bounds.bottom-_o.height)
							{
								_o.y = _bounds.bottom-_o.height;
								v *= -1;
							}
						}
						else if ( _orientation == 'H' )
						{
							if(_o.x <= _bounds.left)
							{
								_o.x  = _bounds.left;
								v *= -1;
							}
							else if(_o.x >= _bounds.right-_o.width)
							{
								_o.x = _bounds.right-_o.width;
								v *= -1;
							}
						}
					}	
					
					v *= .9;
					
					var absv:Number;
					if (v < 0)  absv = -v;
					else absv = v;

					if( absv < 0.5 ) v = 0;
					break;
			}
		}
	}
}