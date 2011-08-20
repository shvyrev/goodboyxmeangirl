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
	
	internal class PageStruct extends Div implements IDiv
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
		public function PageStruct(structure:String='single',adaptToScreen:Boolean=false) {
			super('structure');
			this.structure = structure;
			this.adaptToScreen = adaptToScreen;
		}
		
		/**
		 * ADD PAGE
		 */
		override public function addDiv(div:IDiv):IDiv {
			if (!onScreen) { onScreen = div as PageDiv; onScreen.onScreen = true; }
			var d:IDiv = super.addDiv(div);
			if (structure != 'single') (div as PageDiv).init(ratio++, structure, adaptToScreen);
			return d;
		}
		
		/**
		 * MANAGE BLOCKS
		 */
		public function addBlock(div:IDiv, onTop:Boolean):IDiv { return parent.addChildAt( div as Div, (onTop?parent.numChildren:0)) as IDiv; }
		public function delBlock(div:IDiv):void { parent.removeChild(div as Div); }
		
		/**
		 * PLACE THE CURRENT PAGE DEPENDING ON THE STRUCTURE TYPE
		 * 
		 * @param	current
		 */
		override protected function setupDiv(div:IDiv):void {
			if (structure.search('horizontal') != -1) { div.float = 'left'; div.constraint = 'X';}
			else if (structure.search('vertical') != -1) div.constraint = 'Y';
			if (structure != 'single') super.setupDiv(div);
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
		
		override protected function getMaster():* { return stage; }
	}
}