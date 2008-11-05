package railk.as3.transform.item
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class TransformItemAction 
	{
		private static var _object:*;
		private static var _hover:Function;
		private static var _out:Function;
		private static var _click:Function;
		private static var _move:Function;
		
		private static var objects:ObjectList;
		private static var walker:ObjectNode;
		
		public static function init():void
		{
			objects = new ObjectList();
		}
		
		public static function enable(name:String, object:*,hover:Function=null,out:Function=null,click:Function=null,move:Function=null):void
		{
			_object = object;
			_hover = hover;
			_out = out;
			_click = click;
			_move = move;
			
			initListeners(_object);
			objects.add([name, object]);
		}
		
		private static function initListeners(object:*):void
		{
			object.buttonMode = true;
			object.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
		}
		
		private static function delListeners(object:*):void
		{
			object.buttonMode = false;
			object.removeEventListener( MouseEvent.CLICK, manageEvent );
			object.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent );
			object.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			object.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			object.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
		}
		
		public function dispose():void
		{
			walker = objects.head;
			while ( walker )
			{
				delListeners(walker.data);
				walker = walker.next;
			}
			objects.clear();
		}
		
		private static function manageEvent( evt:* ):void
		{
			switch(evt.type)
			{
				case MouseEvent.CLICK :
					if (_click != null) _click.apply();
					break;
					
				case MouseEvent.MOUSE_DOWN :
					_object.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					break;
				
				case MouseEvent.MOUSE_UP :
					_object.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					break;
					
				case MouseEvent.MOUSE_MOVE :
					if (_move != null ) _move.apply();
					break;
					
				case MouseEvent.MOUSE_OVER :
					if (_hover != null ) _hover.apply();
					break;
					
				case MouseEvent.MOUSE_OUT :
					if (_out != null ) _out.apply();
					break;
			}
		}
	}
	
}