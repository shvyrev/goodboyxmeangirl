/**
* 
* Sequence manager for Process tween engine
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.tween.process.plugin.sequence
{
	import railk.as3.tween.process.Process;
	import railk.as3.utils.objectList.ObjectList;
	public class  Sequence implements ISequence
	{
		private var itemList:ObjectList;
		
		public function Sequence():void { itemList = new ObjectList(); }
		
		public function add( name:String, tween:Process, group:String = '', action:Function=null ):void 
		{
			itemList.add( [name, tween, group, action] );
		}
		
		public function insertBefore( who:String, name:String, tween:Process, group:String = '', action:Function=null ):void 
		{
			
		}
		
		public function insertAfter( who:String, name:String, tween:Process, group:String = '', action:Function=null ):void 
		{
			
		}
		
		public function remove( name:String ):void 
		{
			
		}
		
		public function removeGroup( group:String ):void 
		{
			
		}
		
		public function removeAll():void 
		{
			
		}
		
		public function play():void 
		{
			itemList.getObjectByName('p1').data.play();
		}
		
		public function next():void 
		{
			
		}
		
		public function prev():void 
		{
			
		}
	}
	
}