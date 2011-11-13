/**
 * DIV
 * 
 * @author Richard Rodney
 * @version 0.2 
 */

package railk.as3.ui.div
{	
	import flash.events.Event;
	import railk.as3.display.UISprite;

	public class Div extends UISprite implements IDiv
	{	
		static protected var instance:Number=0;
		protected var _state:DivState;
		protected var _position:String = 'relative';
		protected var _constraint:String = 'none';
		protected var _float:String = 'none';
		protected var _align:String = 'none';
		protected var _master:IDiv;
		protected var _numDiv:int=0;
		protected var _prev:IDiv;
		protected var _next:IDiv;
		protected var firstDiv:IDiv;
		protected var lastDiv:IDiv;
		protected var stageAlign:Boolean;
		protected var stageBound:Boolean;
		
		public function Div(name:String='') {
			super();
			this.name = (!name)?'divInstance'+(instance++):name;
			_state = new DivState();
			addEventListener(Event.ADDED_TO_STAGE, added );
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		/**
		 * INIT
		 * 
		 * @param	float
		 * @param	align
		 * @param	position
		 * @param	constraint
		 * @return
		 */
		public function init(float:String='none', align:String='none', position:String='relative', constraint:String='none'):IDiv {
			_float = float;
			stageAlign = (align.search('STAGE') != -1);
			_align = align.replace('STAGE', "");
			_position = position;
			_constraint = constraint;
			return this;
		}
		
		/**
		 * ADDED TO STAGE
		 */
		protected function added(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added );
			stageBound = (!isNaN(_state.stageWidth) || !isNaN(_state.stageHeight));
			_state.setWidth( (!isNaN(_state.stageWidth))?stage.stageWidth * _state.stageWidth:_state.width );
			_state.setHeight( (!isNaN(_state.stageHeight))?stage.stageHeight * _state.stageHeight:_state.height );
			bind();
		}
		
		protected function removed(evt:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			unbind();
		}
		
		/**
		 * MANAGE DIVS
		 */
		public function addDiv(div:IDiv):IDiv {
			if (!firstDiv) firstDiv = lastDiv = div;
			else {
				lastDiv.next = div;
				div.prev = lastDiv;
				lastDiv = div;
			}
			return insertDiv(div);
		}
		
		public function insertDivBefore(div:IDiv,next:IDiv):IDiv {
			if (!next.prev) firstDiv = div;
			div.prev = next.prev;
			div.next = next;
			if (next.prev) next.prev.next = div;
			next.prev = div;
			return insertDiv(div);
		}
		
		public function insertDivAfter(div:IDiv,prev:IDiv):IDiv {
			if (!prev.next) lastDiv = div;
			div.prev = prev;
			div.next = prev.next;
			if (prev.next) prev.next.prev = div;
			prev.next = div;
			return insertDiv(div);
		}
			
		public function getDiv(name:String):IDiv {
			var d:IDiv = firstDiv;
			while (d) {
				if (d.name == name ) return d;
				d = d.next;
			}
			return null;
		}
		
		public function delDiv(div:IDiv):void {
			if (!div) return;
			div.delAllDiv();
			div.unbind();
			if(div.next) placeDiv(div.next, div.prev);
			removeChild(div as Div);
			
			if (div.prev) div.prev.next = div.next;
			else firstDiv = div.next;
			if (div.next) div.next.prev = div.prev;
			else lastDiv = div.prev;
			_numDiv--;
		}
		
		public function delAllDiv():void {
			var d:IDiv = lastDiv, p:IDiv;
			while (d) {
				p = d.prev;
				d.delAllDiv();
				delDiv(d)
				d = p;
			}
		}
		
		/**
		 * DIV UTILITIES
		 */
		protected function insertDiv(div:IDiv):IDiv {
			div.master = this;
			addChild(div as Div);
			if (div.position == 'relative') {
				placeDiv(div, div.prev);
				alignDiv(div);
			}
			_numDiv++;
			return div;
		}
		
		protected function placeDiv(div:IDiv, prev:IDiv):void {
			var X:Number = ((prev && (div.constraint == 'none' || div.constraint == 'x'))?prev.x:0);
			var Y:Number = ((prev && (div.constraint == 'none' || div.constraint == 'y'))?prev.y:0);
			if (div.float == 'none') Y = Y+((prev)?prev.height+prev.state.bottom:0);
			else if (div.float == 'left') X = X+((prev)?prev.width+prev.state.right:0);
			div.setCoordinate(X+div.state.left+div.state.x,Y+div.state.top+div.state.y);
		}
		
		public function setCoordinate(x:Number, y:Number):void { super.x = x; super.y = y; }
		
		protected function alignDiv(div:IDiv):void {
			var d:IDiv = div.prev;
			while (d) {
				if(d.align!='none') d.resizeDiv();
				if (!d.prev) if (d.master) alignDiv(d.master);
				d = d.prev;
			}
		}
		
		/**
		 * MONITOR CHANGES
		 */
		public function bind():void {
			if (_position != 'absolute') addEventListener(Event.CHANGE, check,false,0,true);
			if (_align != 'none' || stageBound) stage.addEventListener(Event.RESIZE, check, false , 0, true );
			resizeDiv();
		}
		
		public function unbind():void {
			if (_position != 'absolute') removeEventListener(Event.CHANGE, check);
			if(_align!='none' || stageBound) stage.removeEventListener(Event.RESIZE, check );
		}
		
		protected function check(evt:Event):void {
			dispatch = false;
			updateDiv();
			dispatch = true;
		}
		
		public function updateDiv():void {
			var d:IDiv = this;
			while (d) {
				if (_position != 'absolute') placeDiv(d, d.prev);
				if (!d.next) if (_master) _master.updateDiv();
				d = d.next;
			}
			if (_align != 'none' || stageBound) resizeDiv();
		}
		
		/**
		 * RESIZE
		 */
		public function resizeDiv():void {
			if (!isNaN(_state.stageHeight)) _state.setHeight( stage.stageHeight*_state.stageHeight );
			if (!isNaN(_state.stageWidth)) _state.setWidth( stage.stageWidth*_state.stageWidth );
			var W:Number = (!master)?stage.stageWidth:(stageAlign?stage.stageWidth:parent.width), H:Number = (!master)?stage.stageHeight:(stageAlign?stage.stageHeight:parent.height), a:String = _align;
			var w:Number = (isNaN(_state.width)?width:_state.width),  h:Number = (isNaN(_state.height)?height:_state.height);
			super.x = (a=='TL' || a=='L' || a=='CENTERY' )?((_float=='left')?x:_state.x):(a=='TR' || a=='BR' || a=='R')?(W-w)+_state.left+_state.x:(a=='BL')?0:(a=='T' || a=='B' || a=='CENTER' || a=='CENTERX')?W*.5-w*.5+_state.left+_state.x:_state.x;
			super.y = (a == 'TL' || a == 'TR' || a == 'T' || a == 'CENTERX')?_state.y:(a == 'BR' || a == 'BL' || a == 'B')?(stage.stageHeight - h) + _state.top + _state.y:(a == 'L' || a == 'R' || a == 'CENTER' || a == 'CENTERY')?(H * .5 - h * .5)+_state.top+_state.y:_state.y;
		}
		
		/**
		 * FASTER ISNAN
		 */
		protected function isNaN(val:Number): Boolean { return val != val; }
		
		/**
		* GETTER/SETTER
		*/
		public function get numDiv():int { return _numDiv; }
		public function get prev():IDiv { return _prev; }
		public function set prev(value:IDiv):void { _prev = value; }
		public function get next():IDiv { return _next; }
		public function set next(value:IDiv):void { _next = value; }
		public function get master():IDiv { return _master; }
		public function set master(value:IDiv):void { _master = value; }
		public function get float():String { return _float; }
		public function set float(value:String):void { _float=value; }
		public function get align():String { return _align; }
		public function set align(value:String):void { _align=value; }
		public function get position():String { return _position; }
		public function set position(value:String):void { _position = value; }
		public function get constraint():String { return _constraint; }
		public function set constraint(value:String):void { _constraint = value; }
		public function get state():DivState { return _state; }
		public function set state(value:DivState):void { _state = value; }
		override public function get height():Number { return (isNaN(_state.height)?super.height:_state.height); }
		override public function set height(value:Number):void { _state.setHeight(value); dispatchChange(); }
		override public function get width():Number { return (isNaN(_state.width)?super.width:_state.width); }
		override public function set width(value:Number):void { _state.setWidth(value); dispatchChange(); }
		override public function set x(value:Number):void { _state.x = value; dispatchChange(); }
		override public function set y(value:Number):void { _state.y = value;  dispatchChange(); }
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '['+super.toString().split(' ')[1].split(']')[0].toUpperCase()+'::'+name+']'
		}
	}
}