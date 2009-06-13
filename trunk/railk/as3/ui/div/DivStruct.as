/**
 * Div Structure
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	public class DivStruct extends Div implements IDiv
	{	
		public function DivStruct(name:String):void {
			this.name = name;
		}
		
		public function addDiv( container:*, div:IDiv = null, id:String = '', float:String = 'none', align:String = 'none', margins:Object:null, posistion:String:'relative', x:Number = 0, y:Number = 0, data:*= null):void {
			var d:IDiv, lastDiv:IDiv;
			
			if (container && container.numChildren) lastDiv = container.getChildAt(numChildren - 1);
			else if (numChildren) lastDiv = getChildAt(numChildren - 1);
			if (div) d = div;
			else d = new Div( id, float, align, margins, position, x, y, data);
			
			var X:Number = ((lastDiv)?lastDiv.x:0), Y:Number = ((lastDiv)?lastDiv.y:0);
			if (float == 'none') Y = Y+d.margins.top+((lastDiv)?lastDiv.height+lastDiv.margins.bottom:0);
			else if (float == 'left') X = X+d.margins.left+((lastDiv)?lastDiv.width+lastDiv.margins.right:0);
			d.x = X;
			d.y = Y;
			d.state.update();
			lastDiv.addArc(d);
			d.bind();
		}	
		
		public function delDiv(name:String):void {
			for (var i:int = 0; i < numChildren; ++i) removeArc(getChildAt(i) as IDiv);
			removeChild(getDiv(name));
		}
		
		public function getDiv(name:String):IDiv {
			for (var i:int = 0; i < numChildren; ++i) if (getChildAt(i).name == name ) return getChildAt(i);
			return null;
		}
	}
}