/**
 * PAGE Div Structure
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.page
{	
	import flash.geom.Point;
	import railk.as3.ui.div.*;
	
	public class PageStruct extends DivStruct implements IDiv
	{
		private var ratio:Number = 0;
		private var structure:String;
		private var adaptToScreen:Boolean;
		private var onScreen:PageDiv;
		private var oppsPos:Point = new Point();
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	type				single/horizontal/vertical/horizontalSingle/verticalSingle/other to come
		 * @param	adaptToScreen		true/false reisze the content coresponding to screen size
		 */
		public function PageStruct(structure:String='horizontal',adaptToScreen:Boolean=false) {
			super('container');
			this.structure = structure;
			this.adaptToScreen = adaptToScreen;
		}
		
		/**
		 * ADD PAGE
		 */
		override public function addDiv(div:IDiv=null, name:String='', float:String='none', align:String='none', margins:Object=null, posistion:String='relative', x:Number=0, y:Number=0, data:*= null):IDiv {
			current = (div)?div:new PageDiv( name, float, align, margins, position, x, y, data);
			if (!onScreen) { onScreen = current as PageDiv; onScreen.onScreen = true; }
			divs[divs.length] = addChild(current as Div );
			return current;
		}
		
		/**
		 * MANAGE STATIC PAGE
		 */
		public function addStatic( div:IDiv, onTop:Boolean ):IDiv { return parent.addChildAt( div as Div, (onTop)?parent.numChildren-1:0 ) as IDiv; }
		public function delStatic( div:IDiv ):void { parent.removeChild(div as Div); }
		
		/**
		 * PLACE THE CURRENT PAGE DEPENDING ON THE STRUCTURE TYPE
		 * 
		 * @param	current
		 */
		override public function placeDiv(current:IDiv):void {
			if (structure.search('horizontal') != -1) { current.float = 'left'; current.constraint = 'X';}
			else if (structure.search('vertical') != -1) current.constraint = 'Y';
			if (structure != 'single') { super.placeDiv(current); ratio = (current as PageDiv).init(ratio, structure, adaptToScreen ); }
			current.bind();
		}
		
		/**
		 * UTILITIES
		 */
		public function changeDepth( name:String, depth:Number ):void { swapChildren( getChildByName(name), getChildAt(depth) ); }
		
		public function opps(pos:Point, type:String):void {
			this[type] += oppsPos[type]-pos[type];
			oppsPos = pos.clone();
		}
		
		public function goTo(name:String, transition:Function, complete:Function):void {
			onScreen.onScreen = false;
			onScreen = getDiv(name) as PageDiv;
			onScreen.onScreen = true;
			oppsPos = onScreen.oppsPos.clone();
			transition.apply(null,[this,new Point( -onScreen.pos.x, -onScreen.pos.y),complete]);
		}
	}
}