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
		protected var current:IDiv;
		protected var last:IDiv;
		protected var divs:Array = [];
		
		public function DivStruct(name:String='undefined', float:String='none', align:String='none', margins:Object=null, position:String='relative', x:Number=0, y:Number=0, data:*=null):void {
			super(name, float, align, margins, position, x, y, data);
		}
		
		/**
		 * ACTIVATE
		 */
		public function activate():void {
			var i:int;
			for (i = 0; i < divs.length; i++) divs[i].state.init();
			for (i = 0; i < divs.length; i++) divs[i].bind();
		}
		
		/**
		 * MANAGE DIVS
		 */
		public function addDiv(div:IDiv=null, name:String='', float:String='none', align:String='none', margins:Object=null, posistion:String='relative', x:Number=0, y:Number=0, data:*= null):IDiv {
			current = (div)?div:new Div( name, float, align, margins, position, x, y, data);
			if (current.position == 'relative') placeDiv(current);
			divs[divs.length] = addChild(current as Div);
			return current;
		}
		
		public function placeDiv(current:IDiv):void {
			var X:Number = ((last)?last.x:0), Y:Number = ((last)?last.y:0);
			if (current.float == 'none') Y = Y+current.margins.top+((last)?last.height+last.margins.bottom:0);
			else if (current.float == 'left') X = X + current.margins.left + ((last)?last.width + last.margins.right:0);
			current.x += X;
			current.y += Y;
			if (last) last.addArc(current);
			last = current;
		}
		
		public function delDiv(div:*):void {
			var name:String = (div is String)?div:div.name, index:Number=-1;
			for (var i:int = 0; i < divs.length; ++i) {
				if (divs[i].name == name ) {
					divs[i].unbind();
					divs[i].resetArcs();
					for (var j:int = 0; j < divs.length; ++j) divs[j].removeArc(divs[i]);
					removeChild(divs[i]);
					last = (i-1 >= 0)?divs[i-1]:null;
					if(i+1<=divs.length-1) placeDiv(divs[i+1])
					index = i;
				}
			}
			if(index!=-1) divs.splice(index, 1);
			last = (divs.length > 0)?divs[divs.length - 1]:null;
		}
		
		public function getDiv(name:String):IDiv {
			for (var i:int = 0; i < divs.length; ++i) if (divs[i].name == name ) return divs[i];
			return null;
		}
		
		public function delAllDiv():void {
			for (var i:int = 0; i < divs.length; ++i) {
				divs[i].unbind();
				divs[i].resetArcs();
				removeChild(divs[i]);
				last = current = null;
			}
			divs = [];
		}
	}
}