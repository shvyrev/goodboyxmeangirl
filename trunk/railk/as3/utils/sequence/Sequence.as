/**
 * Sequence for sequence manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.sequence
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	 
	public class Sequence extends EventDispatcher
	{
		
		public var name:String;
		public var state:String = 'pause';
		private var stepsList:ObjectList;
		private var walker:ObjectNode;
		
		public function Sequence( name:String ):void
		{
			this.name = name;
		}
		
		public function start():void
		{
			this.state = 'start';
			walker = stepsList.head;
			while ( walker)
			{
				((walker.data as Step).targetsList.head.data as IEventDispatcher).addEventListener( walker.args.listenTo, onStepComplete, false, 0, true );
				walker = walker.next;
			}
			
			if (!stepsList.head.args.hasOwnProperty(delay))
			{
				if (stepsList.head.args.hasOwnProperty(actionParams)) stepsList.head.action.apply(null, stepsList.head.args.actionParams);
				else stepsList.head.action.apply(null, stepsList.head.args.actionParams);
			}
			else
			{
				var timer:Timer = new Timer( stepsList.head.args.delay, 1);
				timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true );
			}
		}
		
		private function next():void
		{
			if ( this.state == 'start')
			{
				if (!stepsList.head.args.hasOwnProperty(delay))
				{
					if (stepsList.head.args.hasOwnProperty(actionParams)) stepsList.head.action.apply(null, stepsList.head.args.actionParams);
					else stepsList.head.action.apply(null, stepsList.head.args.actionParams);
				}
				else
				{
					var timer:Timer = new Timer( stepsList.head.args.delay, 1);
					timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true );
				}
			}
		}
		
		public function pause():void
		{
			this.state = 'pause';
		}
		
		public function addStep(id:Number, target:*, action:Function, listenTo:String, args:Object = null):void
		{
			stepsList.add( [String(id), new Step( id )] );
			(stepsList.tail.data as Step ).addTarget( String(stepsList.length), target, action, listenTo, args );
		}
		
		public function removeStepByID( id:Number ):void
		{
			stepsList.remove( String(id) );
		}
		
		public function dispose():void
		{
			walker = stepsList.head;
			while ( walker )
			{
				walker.data.dispose();
				waler = walker.next;
			}
		}
		
		public function toString():String
		{
			return '[SEQUENCE > '+this.name.toUpperCase()+'  ]'
		}
		
		private function onStepComplete( evt:* ):void
		{
			stepsList.remove( stepsList.head.name );
			if ( stepsList.length > 0 ) next();
			else dispatchEvent( Event.COMPLETE ); 
		}
		
		private function onTimerComplete( evt:TimerEvent ):void
		{
			if (stepsList.head.args.hasOwnProperty(actionParams)) stepsList.head.action.apply(null, stepsList.head.args.actionParams);
			else stepsList.head.action.apply(null, stepsList.head.args.actionParams);
		}
	}
}