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
	
	public class  AccordionItem extends EventDispatcher 
	{
		public var next:AccordionItem;
		public var prev:AccordionItem;
		
		public var name      :String;
		public var nextX     :Number;
		public var nextY     :Number;
		private var type     :String;
		private var X        :Number;
		private var Y        :Number;
		private var oldH     :Number;
		private var oldW     :Number;
		private var separator:Number;
		private var _content :Object;
			
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AccordionItem( name:String, type:String, content:Object, separator:Number )
		{
			this.name = name;
			this.type = type;
			this.X = content.x;
			this.Y = content.y;
			this.oldH = content.height;
			this.oldW = content.width;
			this.nextX = this.oldW+this.X+separator;
			this.nextY = this.oldH+this.Y+separator;
			this.separator = separator;
			_content = content;
			content.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {	
			_content.removeEventListener( Event.ENTER_FRAME, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get x():Number { return X; }
		public function set x(value:Number):void 
		{
			X = value;
			nextX = Y+oldW+separator;
			_content.x = value;
		}
		
		public function get y():Number { return Y; }
		public function set y(value:Number):void 
		{
			Y = value;
			nextY = Y+oldH+separator;
			_content.y = value;
		}
		
		public function get content():* { return _content; }
		public function set content(value:*):void 
		{
			_content = value;
			oldH = value.height;
			oldW = value.width;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					     MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ){
				case Event.ENTER_FRAME :
					if ( _content.width != oldW && type == 'H' ) {
						oldW = _content.width;
						nextX = X+oldW+separator;
						dispatchEvent( new AccordionEvent( AccordionEvent.ON_WIDTH_CHANGE, { info:name+' width change', data:name } ) );
					} else if ( _content.height != oldH && type == 'V' ) {
						oldH = _content.height;
						nextY = Y+oldH+separator;
						dispatchEvent( new AccordionEvent( AccordionEvent.ON_HEIGHT_CHANGE, { info:name+' height change', data:name } ) );
					}
					break;	
			}
		}
	}
}