/**
 * Layout Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.data.objectList.ObjectList;
	
	public class LayoutManager
	{
		
		private var layoutsList:ObjectList;
		
		public static function init():void
		{
			layoutsList = new ObjectList();
		}
		
		public static function addLayout( name:String, group:String, parent:Object, structure:LayoutStruct, isDynamic:Boolean=true ):void
		{
			layoutsList.add([name,new Layout(parent,structure,isDynamic),group]);
		}
		
		public static function removeLayout( name:String ):void
		{
			layoutsList.remove(name);
		}
		
		public function getLayout(name:String):void
		{
			layoutsList.getObjectByGroup(name);
		}
	}
	
}