/**
 * Sequence manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.timeline.sequence
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import railk.as3.event.CustomEvent;
	
	import railk.as3.data.objectList.ObjectList;
	import railk.as3.data.objectList.ObjectNode;
	 
	public class SequenceManager extends EventDispatcher
	{
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                      :EventDispatcher;
		
		// ______________________________________________________________________________ VARIABLES SEQUENCES
		private static var sequencesList               :ObjectList;
		private static var walker		               :ObjectNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   					 MANAGE STEPS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addStep( id:Number, target:*, action:Function, listenTo:String, sequence:String='', args:Object=null ):void
		{
			if ( sequencesList.getObjectByName( sequence ) )
			{
				(sequencesList.getObjectByName( sequence ).data as Sequence).addStep( id, target, action, listenTo, args );
			}
			else
			{
				sequencesList.add([sequence, new Sequence(sequence)]);
				(sequencesList.tail.data  as Sequence).addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
				(sequencesList.tail.data  as Sequence).addStep( id, target, action, listenTo, args );
			}
		}
		
		public static function removeStepByID( sequence:String, id:Number ):void
		{
			(sequencesList.getObjectByName( sequence ).data as Sequence).removeStep( id );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   				  MANAGE SEQUENCE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function removeSequence( name:String ):void
		{
			(sequencesList.getObjectByName( name ).data as Sequence).removeEventListener( Event.COMPLETE, manageEvent );
			(sequencesList.getObjectByName( name ).data as Sequence).dispose();
			sequencesList.remove( name );
		}
		
		public static function start( name:String='' ):void
		{
			(sequencesList.getObjectByName(name).data as Sequence).start();
		}
		
		public static function pause( name:String='' ):void
		{
			(sequencesList.getObjectByName(name).data as Sequence).pause();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   				  	 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function manageEvent( evt:Event ):void
		{
			switch( evt.type )
			{
				case Event.COMPLETE :
					dispatchEvent( new CustomEvent( Event.COMPLETE, { sequence:evt.target } ) );
					break;
			}
		}
	}
	
}