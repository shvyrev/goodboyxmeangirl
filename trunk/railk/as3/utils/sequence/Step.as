/**
 * Step for sequence manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils.sequence
{	 
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import railk.as3.utils.objectList.ObjectList;
	
	public class Step extends EventDispatcher
	{
		public var id:Number;
		public var targetsList:ObjectList
		public var args:Object;
		public var state:String;
		
		public function Step( id:Number, args:Object = null)
		{
			this.id = id;
			this.args = args;
			this.targetsList = new ObjectList();
		}
		
		public function addTarget( name:String, target:*, action:Function, listenTo:String ):void
		{
			targetsList.add([name,target,'',action,{ listenTo:listenTo }])
		}
		
		public function dispose():String
		{	
			
		}
		
		public function toString():String
		{	
			return '[ STEP > +'(this.id as String).toUpperCase()'+  ]'
		}
		
		private function manageEvent( evt:* ):void
		{
			switch( evt.type )
			{
				case '' :
					break;
			}
		}
	}	
}