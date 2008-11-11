package railk.as3.transform.item
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class TransformItemAction 
	{
		private var _object:*;
		private var objects:ObjectList;
		private var walker:ObjectNode;
		
		public function TransformItemAction():void
		{
			objects = new ObjectList();
		}
		
		public function enable(name:String, object:*,hover:Function=null,out:Function=null,up:Function=null,down:Function=null,click:Function=null,move:Function=null):void
		{
			_object = object;
			_object.name = name;
			initListeners(_object);
			objects.add([name, object,null,null,{hover:hover, out:out, up:up, down:down, click:click, move:move}]);
		}
		
		private function initListeners(object:*):void
		{
			object.buttonMode = true;
			object.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			object.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
		}
		
		private function delListeners(object:*):void
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
		
		private function manageEvent( evt:* ):void
		{
			var f:Object = objects.getObjectByName(evt.target.name).args;
			switch(evt.type)
			{
				case MouseEvent.CLICK :
					if (f.click != null) f.click.apply();
					break;
					
				case MouseEvent.MOUSE_DOWN :
					if (f.down != null ) f.down.apply();
					evt.target.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					break;
				
				case MouseEvent.MOUSE_UP :
					if (f.up != null ) f.up.apply();
					evt.target.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					break;
					
				case MouseEvent.MOUSE_MOVE :
					if (f.move != null ) f.move.apply();
					break;
					
				case MouseEvent.MOUSE_OVER :
					if (f.hover != null ) f.hover.apply();
					break;
					
				case MouseEvent.MOUSE_OUT :
					if (f.out != null ) f.out.apply();
					break;
			}
		}
	}
	
}