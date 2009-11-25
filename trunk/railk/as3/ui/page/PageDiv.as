/**
 * PageDiv Structure
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.page
{	
	import flash.events.Event;
	import flash.geom.Point;
	import railk.as3.ui.div.*;
	import railk.as3.stage.StageManager;
	
	public class PageDiv extends Div implements IDiv
	{
		public var ratio:int;
		public var type:String;
		public var pos:Point;
		public var oldPos:Point;
		public var oriPos:Point;
		
		public function PageDiv(name:String='undefined',float:String='none',align:String='none',margins:Object=null,position:String='relative',x:Number=0,y:Number=0,options:Object=null) {
			super(name,float,align,margins,position,x,y,options);
		}
		
		public function init(ratio:Number, type:String):void {
			this.ratio = ratio;
			this.type = type;
			oriPos = pos = new Point((type == 'horizontal'?ratio * StageManager.width:0), (type == 'horizontal'?0:ratio * StageManager.height));
			oldPos =  new Point();
		}		
		
		override public function resize(evt:Event=null):void {
			super.resize(evt);
			if(type=='horizontal') { x += pos.x = (ratio*StageManager.width)-oldPos.x; oldPos.x = x; }
			else if(type=='vertical') { y += pos.y = (ratio*StageManager.height)-oldPos.y; oldPos.y = y; }
			state.update();
		}
	}
}	