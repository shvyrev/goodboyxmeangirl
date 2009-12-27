/**
 * PageDiv Structure
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * TODO CHECK FEW LIMITS BUGS (HORIZONTAL/CENTERX)
 * 
 */

package railk.as3.ui.page
{	
	import flash.events.Event;
	import flash.geom.Point;
	import railk.as3.ui.div.*;
	
	public class PageDiv extends Div implements IDiv
	{
		public var prev:PageDiv;
		public var gap:Number=0;
		
		public var ratio:Number;
		public var type:String;		
		public var onScreen:Boolean;
		public var adaptToScreen:Boolean;
		public var adapt:Function;
		
		public var pos:Point;
		public var oppsPos:Point;
		private var oppsStage:Point;
		private var hasOpps:Boolean;
		
		public function PageDiv(name:String='undefined',float:String='none',align:String='none',margins:Object=null,position:String='relative',x:Number=0,y:Number=0,data:Object=null) {
			super(name,float,align,margins,position,x,y,data);
		}
		
		public function init(ratio:Number, type:String, adaptToScreen:Boolean ):void {
			// vars
			this.ratio = ratio;
			this.type = type;
			this.adaptToScreen = adaptToScreen;
			
			// init
			pos = new Point(x, y);
			oppsPos = new Point();
			oppsStage = new Point(stage.stageWidth, stage.stageHeight);
			
			// ratio
			if ( type.search('Single') != -1 && ratio) opps((type=='verticalSingle')?'y':'x');
			for (var i:int = 0; i < numChildren; i++) getChildAt(i).addEventListener(Event.CHANGE, dispatchChange); 
		}
		
		override public function resize(evt:Event = null):void {
			super.resize(evt);
			switch(type) {
				case 'horizontal' : x += pos.x; break;
				case 'vertical' : y += pos.y; break;
				case 'horizontalSingle' : opps('x'); break;
				case 'verticalSingle' : opps('y'); break;
				default: break;
			}
			if (adaptToScreen && adapt != null ) adapt.apply();
		}
		
		override public function update(from:IDiv):void {
			if (hasOpps) resize();
			else { super.update(from); pos.x = x; pos.y = y; }
		}
		
		/**
		 * ONE PAGE PER SCREEN
		 * @param	type
		 */
		public function opps(type:String):void {
			var size:Number = (type == 'x')?stage.stageWidth:stage.stageHeight;
			gap = ((prev)?(prev.width-size>0?prev.width-size:0)+prev.gap:0);
			oppsPos[type] = (size-oppsStage[type])*ratio + gap;
			this[type] += pos[type] = size*ratio + gap;
			if (onScreen) (parent as PageStruct).opps(oppsPos, type);
			hasOpps = true;
		}
	}
}