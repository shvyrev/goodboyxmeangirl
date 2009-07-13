﻿/**
 * Div Structure
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	public class DivStruct extends Div implements IDiv
	{	
		private var current:IDiv;
		private var previous:IDiv;
		private var divs:Array = [];
		
		public function DivStruct(name:String='undefined', float:String='none', align:String='none', margins:Object=null, position:String='relative', x:Number=0, y:Number=0, data:*=null):void {
			super(name, float, align, margins, position, x, y, data);
		}
		
		public function addDiv(div:IDiv=null, name:String='', float:String='none', align:String='none', margins:Object=null, posistion:String='relative', x:Number=0, y:Number=0, data:*= null):void {
			current = (div)?div:new Div( name, float, align, margins, position, x, y, data);
			if (posistion == 'relative') placeDiv(current);
			divs[divs.length] = addChild(current as Div);
		}
		
		private function placeDiv(current:IDiv):void {
			var X:Number = ((previous)?previous.x:0), Y:Number = ((previous)?previous.y:0);
			if (current.float == 'none') Y = Y+current.margins.top+((previous)?previous.height+previous.margins.bottom:0);
			else if (current.float == 'left') X = X + current.margins.left + ((previous)?previous.width + previous.margins.right:0);
			current.x = X;
			current.y = Y;
			current.state.update();
			if (previous) previous.addArc(current);
			current.bind();
			previous = current;
		}
		
		public function delDiv(name:String):void {
			for (var i:int = 0; i < divs.length; ++i) {
				if (divs[i].name == name ) {
					divs[i].unbind();
					divs[i].resetArcs();
					for (var j:int = 0; j < divs.length; ++j) divs[j].removeArc(divs[i]);
					removeChild(divs[i]);
				}
			}
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
				previous = current = null;
			}
		}
	}
}