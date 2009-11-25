/**
 * Div Structure
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.page
{	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import railk.as3.stage.*;
	import railk.as3.ui.div.*;
	import railk.as3.ui.depth.DepthManager;
	import railk.as3.ui.page.PageManager;
	
	public class PageStruct extends DivStruct implements IDiv
	{
		private var ratio:int = 0;
		private var structure:String;
		private var adaptToScreen:Boolean;
		private var manager:DepthManager;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	type				single/horizontal/vertical/circular
		 * @param	adaptToScreen		true/false reisze the content coresponding to screen size
		 */
		public function PageStruct(structure:String='horizontal',adaptToScreen:Boolean=false) {
			super('container');
			this.structure = structure;
			this.adaptToScreen = adaptToScreen;
			manager = new DepthManager(this);
		}
		
		/**
		 * ADD PAGE
		 * 
		 * @param	div
		 * @param	name
		 * @param	float
		 * @param	align
		 * @param	margins
		 * @param	posistion
		 * @param	x
		 * @param	y
		 * @param	data
		 * @return
		 */
		override public function addDiv(div:IDiv=null, name:String='', float:String='none', align:String='none', margins:Object=null, posistion:String='relative', x:Number=0, y:Number=0, data:*= null):IDiv {
			current = (div)?div:new PageDiv( name, float, align, margins, position, x, y, data);
			if (adaptToScreen) (current as Div).addEventListener(StageManagerEvent.ONSTAGERESIZE, adapt, false, 0, true );
			if (structure != 'single') placeDiv(current);
			return divs[divs.length] = manager.add(current as Div );
		}
		
		/**
		 * DELETE PAGE
		 * 
		 * @param	div
		 */
		override public function delDiv(div:*):void {
			var name:String = (div is String)?div:div.name, index:Number = -1;
			for (var i:int = 0; i < divs.length; i++) {
				if (divs[i].name == name ) {
					divs[i].unbind();
					divs[i].resetArcs();
					for (var j:int = 0; j < divs.length; ++j) divs[j].removeArc(divs[i]);
					manager.remove(divs[i]);
					last = (i-1 >= 0)?divs[i-1]:null;
					if(i+1<=divs.length-1) placeDiv(divs[i+1])
					index = i;
				}
			}
			if(index!=-1) divs.splice(index, 1);
			last = (divs.length > 0)?divs[divs.length - 1]:null;
		}
		
		/**
		 * MANAGE STATIC PAGE
		 */
		public function addStatic( div:IDiv, index:* ):IDiv { return manager.add( div, index ) as IDiv; }
		public function delStatic( div:IDiv ):void { manager.remove(div); }
		
		
		/**
		 * PLACE THE CURRENT PAGE DEPENDING ON THE STRUCTURE TYPE
		 * 
		 * @param	current
		 */
		override protected function placeDiv(current:IDiv):void {
			switch(structure) {
				case 'horizontal' : (current as PageDiv).init(ratio++, structure); break;
				case 'vertical' : (current as PageDiv).init(ratio++, structure); break;
				case 'circular' : (current as PageDiv).init(ratio++, structure); break;
				default : break;
			}
			
			(current as Div).addEventListener(Event.ADDED_TO_STAGE, place, false, 0, true );
			var X:Number = ((last)?last.x:0), Y:Number = ((last)?last.y:0);
			current.x += X;
			current.y += Y;
			current.state.update();
			if (last) last.addArc(current);
			last = current;
		}
		
		/**
		 * UTILITIES
		 */
		public function goTo(name:String, transition:Function, complete:Function):void {
			var d:PageDiv = getDiv(name) as PageDiv;
			if (!d) return;
			transition.apply(null,[this,new Point( -d.oriPos.x, -d.oriPos.y),complete]);
		}
		
		public function changeDepth( name:String, depth:Number ):void {
			manager.changeDepth(name, depth);
		}
		
		public function place(evt:Event):void {
			(current as Div).removeEventListener(Event.ADDED_TO_STAGE, resize )
			current.resize();
		}
		
		private function adapt(evt:StageManagerEvent):void {
			for (var i:int = 0; i < divs.length; i++) {
				divs[i].init( divs[i].ratio, structure);
				divs[i].resize();
			}
		}
	}
}