/**
 * Step for sequence manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.timeline.sequence
{	 
	import railk.as3.data.objectList.ObjectList;
	import railk.as3.data.objectList.ObjectNode;
	
	public class Step
	{
		public var id:Number;
		public var targetsList:ObjectList
		private var walker:ObjectNode;
		public var state:String;
		
		public function Step( id:Number )
		{
			this.id = id;
			this.targetsList = new ObjectList();
		}
		
		public function addTarget( name:String, target:*, action:Function, listenTo:String, args:Object = null ):void
		{
			if ( args.hasOwnProperty( actionParams ) ) targetsList.add([name,target,'',action,{ listenTo:listenTo, actionParams:args.actionParams }])
			else targetsList.add([name,target,'',action,{ listenTo:listenTo }])
		}
		
		public function dispose():String
		{	
			walker = targetsList.head;
			while ( walker )
			{
				walker.data = null;
				walker.action = null;
				walker.args = null;
				walker = walker.next;
			}
			targetsList.clear();
		}
		
		public function toString():String
		{	
			var result:String = '[ STEP > +'(this.id as String).toUpperCase() + '\n';
			walker = targetsList.head;
			while ( walker )
			{
				result += '( target > ' + walker.name + ' ,' + walker.data + ' )\n';
				walker = walker.next;
			}
			result += 'END STEP ]';
		}
	}	
}