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
		public var ratio:Number;
		public var type:String;
		public var adaptToScreen:Boolean;		
		public var onScreen:Boolean;
		public var pos:Point;
		public var oppsPos:Point = new Point();
		public var oppsStage:Point;
		public var oldStage:Point;
		
		public function PageDiv(name:String='undefined',float:String='none',align:String='none',margins:Object=null,position:String='relative',x:Number=0,y:Number=0,data:Object=null) {
			super(name,float,align,margins,position,x,y,data);
		}
		
		public function init(ratio:Number, type:String, adaptToScreen:Boolean ):Number {
			this.ratio = ratio;
			this.type = type;
			this.adaptToScreen = adaptToScreen;
			pos = new Point(x, y);
			oldStage = new Point(stage.stageWidth, stage.stageHeight);
			oppsStage = oldStage.clone();
			if ( type.search('Single') != -1 ) { 
				ratio = ((pos.x + width) / stage.stageWidth>ratio+1)?(pos.x + width) / stage.stageWidth:++ratio; 
				if(this.ratio) opps((type=='verticalSingle')?'y':'x'); 
			} 
			else ++ratio;
			return ratio;
		}
		
		override public function resize(evt:Event=null):void {
			super.resize(evt);
			switch(type) {
				case 'horizontal' : x += pos.x; break;
				case 'vertical' : y += pos.y; break;
				case 'horizontalSingle' : opps('x'); break;
				case 'verticalSingle' : opps('y'); break;
				default: break;
			}
			if (adaptToScreen) adapt();
		}
		
		override public function update(from:IDiv):void {
			super.update(from);
			//trace( ratio, init(ratio, type, adaptToScreen) );
		}
		 
		/**
		 * ONE PAGE PER SCREEN
		 * @param	type
		 */
		public function opps(type:String):void {
			var size:Number = (type=='x')?stage.stageWidth:stage.stageHeight;
			oppsPos[type] = (size - oppsStage[type])*ratio;
			this[type] += pos[type] = size*ratio;
			if(onScreen) (parent as PageStruct).opps(oppsPos,type);
		}
		
		public function adapt():void {
			if ( stage.stageWidth - width > stage.stageHeight -height ) {
				var oldW:Number = width;
				width = (width*stage.stageWidth)/oldStage.x;
				height = (width*height)/oldW;
			} else {
				var oldH:Number = height;
				height = (height*stage.stageHeight)/oldStage.y
				width = (width*height)/oldH
			}
			oldStage.x = stage.stageWidth;
			oldStage.y = stage.stageHeight;
		}
	}
}	