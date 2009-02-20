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
	import flash.events.Event	
	
	
	public class  AccordionItem extends EventDispatcher {
		
		// ______________________________________________________________________________ VARIABLES ACCORDION
		private var _name                                   :String;
		private var _type                                   :String;
		private var _X                                      :int;
		private var _Y                                      :int;
		private var _nextX                                  :int;
		private var _nextY                                  :int;
		private var _content                                :Object;
		private var _oldH                                   :Number;
		private var _oldW                                   :Number;
		private var _separator                              :Number;
			
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AccordionItem( name:String, type:String, content:Object, separator:Number )
		{
			_name = name;
			_type = type;
			_X = content.x;
			_Y = content.y;
			_oldH = content.height;
			_oldW = content.width;
			_nextX = _oldW+_X+separator;
			_nextY = _oldH+_Y+separator;
			_content = content;
			_separator = separator;
			content.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void 
		{	
			_content.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get x():int { return _X; }
		
		public function set x(value:int):void 
		{
			_X = value;
			_nextX = _Y + _oldW + _separator;
			_content.x = value;
		}
		
		public function get y():int { return _Y; }
		
		public function set y(value:int):void 
		{
			_Y = value;
			_nextY = _Y + _oldH + _separator;
			_content.y = value;
		}
		
		public function get content():* { return _content; }
		
		public function set content(value:*):void 
		{
			_content = value;
			_oldH = value.height;
			_oldW = value.width;
		}
		
		public function get name():String { return _name; }
		
		public function get nextX():int { return _nextX; }
		
		public function get nextY():int { return _nextY; }
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					     MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void 
		{
			var args:Object;
			var eEvent:AccordionEvent;
			switch( evt.type ){
				case Event.ENTER_FRAME :
					if ( _content.width != _oldW && _type == 'H' )
					{
						_oldW = _content.width;
						_nextX = _X + _oldW + _separator;
						///////////////////////////////////////////////////////////////
						args = { info:name+' width change', data:name };
						eEvent = new AccordionEvent( AccordionEvent.ON_WIDTH_CHANGE, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
					}
					else if ( _content.height != _oldH && _type == 'V' )
					{
						_oldH = content.height;
						_nextY = _Y + _oldH + _separator;
						///////////////////////////////////////////////////////////////
						args = { info:name+' height change', data:name };
						eEvent = new AccordionEvent( AccordionEvent.ON_HEIGHT_CHANGE, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
					}
					break;
				
			}
		}
		
	}
	
}