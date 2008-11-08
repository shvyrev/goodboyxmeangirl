/**
 * Sequence manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.sequence
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	 
	public class SequenceManager extends EventDispatcher
	{
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                      :EventDispatcher;
		
		// ______________________________________________________________________________ VARIABLES SEQUENCES
		private static var sequencesList               :ObjectList;
		private static var walker		               :ObjectNode;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																	   GESTION DES LISTENERS DE CLASS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																	   					 MANAGE STEPS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function addStep( id:Number, target:*, action:Function, listenTo:String, sequence:String='', args:Object=null ):void
		{
			if ( sequencesList.getObjectByName( sequence ) )
			{
				(sequencesList.getObjectByName( sequence ).data as Sequence).addStep( id, target, action, listenTo, args );
			}
			else
			{
				sequencesList.add([sequence, new Sequence(sequence)]);
				(sequencesList.tail.data  as Sequence).addStep( id, target, action, listenTo, args );
			}
		}
		
		public static function removeStepByID( sequence:String, id:Number ):void
		{
			(sequencesList.getObjectByName( sequence ).data as Sequence).removeStep( id );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																	   				  MANAGE SEQUENCE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function removeSequence( name:String ):void
		{
			(sequencesList.getObjectByName( name ).data as Sequence).dispose();
			sequencesList.remove( name );
		}
		
		public static function start( name:String='' ):void
		{
			
		}
		
		public static function pause( name:String='' ):void
		{
			
		}
		
		public static function stop( name:String='' ):void
		{
			
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																	   				  	 MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function manageEvent( evt:* ):void
		{
			switch( evt.type )
			{
				case Event.COMPLETE :
					break;
			}
		}
	}
	
}