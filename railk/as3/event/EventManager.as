/**
 * Event manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.event {
	
	import flash.events.EventDispatcher;  
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import railk.as3.data.objectList.ObjectList;
	import railk.as3.data.objectList.ObjectNode;
	
	public class EventManager {
		
		private static var objects:Dictionary = new Dictionary();
		private static var listenerslist:ObjectList;
		private static var walker:ObjectNode; 
		
		public static function add( o:IEventDispatcher, type:String, action:Function,  useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true ):void
		{
			if ( !objects[o] ) objects[o] = new ObjectList();
			objects[o].add( [type, o, null, action] );
			o.addEventListener( type, action, useCapture, priority, useWeakReference );
		}
		
		public static function remove( o:IEventDispatcher, type:String ):Boolean
		{
			if ( objects[o] )
			{
				listenerslist = objects[o];
				if ( listenerslist.getObjectByName( type ) )
				{
					o.removeEventListener( type, listenerslist.getObjectByName( type ).action );
					listenerslist.remove( type );
					return true;
				}	
				else return false;
			}
			else return false;
		}
		
		public static function removeAllFrom( o:IEventDispatcher ):Boolean
		{
			if ( objects[o] )
			{
				listenerslist = objects[o];
				walker = listenerslist.head;
				while ( walker ) {
					o.removeEventListener( walker.name, walker.action );
					listenerslist.remove( walker.name );
					walker = walker.next;
				}
				return true;
				
			}
			else return false;
		}
		
		public static function removeAll():void
		{
			for ( var key in objects )
			{
				listenerslist = objects[key];
				walker = listenerslist.head;
				while ( walker ) {
					key.removeEventListener( walker.name, walker.action );
					listenerslist.remove( walker.name );
					walker = walker.next;
				}
			}
		}
		
		public static function hasListener( o:IEventDispatcher ):Number
		{
			var result:Number;
			if ( objects[0] ) result = objects[0].length;
			else result = -1;
			return result;
		}
		
		public static function listeners( o:IEventDispatcher ):String
		{
			var result:String = '[ '+o+' '+ (o as Object).name+' listeners > ';
			if ( objects[o] )
			{
				listenerslist = objects[o];
				walker = listenerslist.head;
				while ( walker ) {
					result += '( type:' + walker.name +' ),';
					walker = walker.next;
				}
			}
			result += ' END ]';
			return result;
		}
		
		public static function allListeners():String
		{
			var result:String = '';
			for ( var key in objects )
			{
				result += '[ '+key+' '+ (key as Object).name+' listeners > ';
				listenerslist = objects[key];
				walker = listenerslist.head;
				while ( walker ) {
					result += '( type:' + walker.name +' ),';
					walker = walker.next;
				}
				result += ' END ]\n';
			}
			return result;
		}
	}
	
}