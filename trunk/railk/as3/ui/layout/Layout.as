/**
 * Layout Manager Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.display.VSprite;
	import railk.as3.ui.depth.DepthManager;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class Layout
	{
		private var blocsList:ObjectList;
		private var blocsDepth:DepthManager;
		
		public function Layout(parent:Object,structure:LayoutStruct):void
		{
			blocsDepth = new DepthManager(parent);
			blocsList = new ObjectList();
			var baseBlocs:Number = structure.blocs.length;
			for ( var i:int = 0; i < baseBlocs; i++)
			{
				blocsList.add([String(i), new LayoutBloc(parent)]);
			}
			blocsDepth.sync();
		}
		
		public function getBloc(name:String):void
		{
			blocsList.getObjectByGroup(name);
		}
		
		public function resize():void
		{
			
		}
	}
	
}