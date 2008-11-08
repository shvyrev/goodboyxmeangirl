/**
 * Sequence for sequence manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.sequence
{
	import flash.events.EventDispatcher;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	 
	public class Sequence extends EventDispatcher
	{
		
		public var name:String;
		private var stepsList:ObjectList;
		private var walker:ObjectNode;
		
		public function Sequence( name:String ):void
		{
			this.name = name;
		}
		
		public function addStep(id:Number, target:*, action:Function, listenTo:String, args:Object = null):void
		{
			stepsList.add( [String(id), new Step( id, args )] );
			(stepsList.tail.data as Step ).addTarget( String(stepsList.length), target, action, listenTo );
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
				
				waler = walker.next;
			}
		}
		
		public function toString():String
		{
			return '[SEQUENCE > '+this.name.toUpperCase()+'  ]'
		}
	}
}