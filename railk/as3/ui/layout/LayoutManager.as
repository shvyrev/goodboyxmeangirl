/**
 * Layout Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.utils.objectList.ObjectList;
	
	public class LayoutManager
	{
		
		private var layoutsList:ObjectList;
		
		public function LayoutManager(container:Object,row:Number=1,column:Number=1):void
		{
			layoutsList = new ObjectList();
			var nbBlocs:Number = row*column;
			for ( var i:int = 0; i < nbBlocs; i++)
			{
				layoutsList.add([String(i),new LayoutBloc(container)]);
			}
		}
		
		public function defineBloc(bloc:Number,name:String,width:Number,height:Number):void
		{
			layoutsList.update(bloc, null, name);
			(layoutsList.getObjectByName(bloc).data as LayoutBloc).defineBloc(name, width, height);
		}
		
		public function getBloc(name:String):void
		{
			layoutsList.getObjectByGroup(name);
		}
	}
	
}