/**
 * Div
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	import railk.as3.display.RegistrationPoint;
	import flash.events.Event;
	
	public class Div extends RegistrationPoint implements IDiv
	{
		protected var lastDiv:IDiv;
		protected var arcs:Array = [];
		protected var _data:*;
		protected var _state:DivState;
		protected var _position:String;
		protected var _float:String;
		protected var _align:String;
		protected var _margins:Object = { top:0,right:0,bottom:0,left:0 };
		
		
		public function Div(name:String='undefined', float:String='none', align:String='none', margins:Object=null, position:String='relative', x:Number=0, y:Number=0, data:*=null ) {
			this.name = name;
			if (margins) this.margins = margins;
			this.float = float;
			this.align = align;
			this.position = position;
			this.x = x;
			this.y = y;
			this.data = data;
			this.state = new DivState(this);
		}
		
		public function bind():void { 
			this.addEventListener(Event.CHANGE, check); 
			if (align!='none') stage.addEventListener(Event.RESIZE, resize, false ,0, true );
		}
		
		public function unbind():void { 
			this.removeEventListener(Event.CHANGE, check);
			if (align!='none') stage.removeEventListener(Event.RESIZE, resize ); 
		}
		
		private function check(evt:Event):void { 
			for (var i:int = 0; i < arcs.length ; ++i) arcs[i].div.update(this);
		}
		
		public function update(from:IDiv):void {
			if (y >= from.y && y < from.y+from.height ) x = int(state.x+(from.x-from.state.x)+(from.width-from.state.width));
			if (x >= from.x && x < from.x + from.width ) y = int(state.y+(from.y-from.state.y)+(from.height-from.state.height));
		}
		
		public function addArc(div:IDiv):void { arcs[arcs.length] = new DivArc(div); }
		public function removeArc(div:IDiv):Boolean {
			var i:int = arcs.length;
			while( --i > -1 ) {
				if (arcs[i] == div) {
					arcs.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * RESIZE
		 */
		private function resize(evt:Event):void {
			switch(_align) {
				case 'TL' : x = y = 0; break;
				case 'TR' : 
					x = stage.stageWidth - width;
					y = 0;
					break;
				case 'BR' :
					x = stage.stageWidth - width;
					y = stage.stageHeight - height;
					break;
				case 'BL' : 
					x = 0;
					y = stage.stageHeight - height;
					break;
				case 'T' :
					x = stage.stageWidth*.5-width*.5;
					y = 0;
					break;
				case 'L' :
					x = 0;
					y = stage.stageHeight*.5-height*.5;
					break;
				case 'R' :
					x = stage.stageWidth - width;
					y = stage.stageHeight*.5-height*.5;
					break;
				case 'B' :
					x = stage.stageWidth*.5-width*.5;
					y = stage.stageHeight - height;
					break;
				case 'CENTER' :
					x = stage.stageWidth*.5-width*.5;
					y = stage.stageHeight*.5-height*.5;
					break;
			}
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get data():* { return _data; }
		public function set data(value:*):void { _data=value; }
		public function get state():DivState { return _state; }
		public function set state(value:DivState):void { _state=value; }
		public function get float():String { return _float; }
		public function set float(value:String):void { _float=value; }
		public function get align():String { return _align; }
		public function set align(value:String):void { _align=value; }
		public function get position():String { return _position; }
		public function set position(value:String):void { _position=value; }
		public function get margins():Object { return _margins; }
		public function set margins(value:Object):void { _margins = value; }
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '[ DIV > name:'+name+' ]'
		}
	}
}