/**
 * Div
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import railk.as3.display.UISprite;
	
	import railk.as3.utils.Logger;
	
	public class Div extends UISprite implements IDiv
	{	
		protected var arcs:Array = [];
		protected var isDiv:Boolean;
		protected var _state:DivState;
		protected var _padding:Point;
		protected var _position:String;
		protected var _float:String;
		protected var _align:String;
		protected var _margins:DivMargin;
		protected var _data:Object;
		protected var _constraint:String;
		
		protected var _master:Object;
		protected var _numDiv:int=0;
		protected var _next:IDiv;
		protected var _prev:IDiv;
		protected var first:IDiv;
		protected var last:IDiv;
		
		public function Div(name:String='undefined', float:String='none', align:String='none', margins:DivMargin=null, position:String='relative', x:Number=0, y:Number=0, data:Object=null, constraint:String='XY' ) {
			super();
			this.name = name;
			this.margins = margins?margins:new DivMargin();
			this.float = float;
			this.align = align;
			this.position = position;
			this.padding = new Point(x,y);
			this.data = data;
			this.constraint = constraint;
			_state = new DivState(this);
			addEventListener(Event.ADDED_TO_STAGE, added );
		}
		
		/**
		 * ADDED TO STAGE
		 */
		private function added(evt:Event):void { 
			removeEventListener(Event.ADDED_TO_STAGE, added );
			isDiv = (master)?('addDiv' in master):false;
		}
		
		/**
		 * CHILD MANAGEMENT
		 */
		override public function addChild(child:DisplayObject):DisplayObject { activate(this); super.addChild(child); boulderDash(); return child; }
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject { activate(this); super.addChildAt(child, index); boulderDash(); return child; }
		override public function removeChild(child:DisplayObject):DisplayObject { activate(this); super.removeChild(child); check(); boulderDash(); return child; }
		override public function removeChildAt(index:int):DisplayObject { activate(this); var c:DisplayObject = super.removeChildAt(index); check(); boulderDash(); return c; }
		
		/**
		 * MANAGE DIVS
		 */
		public function addDiv(div:IDiv):IDiv {
			div.master = getMaster();
			if (div.position == 'relative') setupDiv(div);
			addChild(div as Div);
			if (!first) first = last = div;
			else {
				last.next = div;
				div.prev = last;
				last = div;
			}
			_numDiv++;
			return this;
		}
		
		public function insertDivBefore(before:*,div:IDiv):IDiv {
			var d:IDiv = getDiv((before is String)?before:before.name);
			if (!d) return null;
			div.next = d;
			div.prev = d.prev;
			if (d.prev) d.prev.next = div;
			d.prev = div;
			
			div.prev.addArc(div);
			d.prev.removeArc(div.next);
			placeDiv(div,div.prev);
			insert(div);
			return this;
		}
		
		public function insertDivAfter(after:*,div:IDiv):IDiv {
			var d:IDiv = getDiv((after is String)?after:after.name);
			if (!d) return null;
			div.next = d.next;
			div.prev = d;
			if (d.next) d.next.prev = div;
			d.next = div;
			
			d.addArc(div);
			d.removeArc(div.next);
			placeDiv(div,d);
			insert(div);
			return this;
		}
		
		public function delDiv(div:*):void {
			var d:IDiv = getDiv((div is String)?div:div.name);
			if (!d) return;
			if(d.prev) d.prev.removeArc(d);
			if (d.next) {
				if(d.prev) d.prev.addArc(d.next)
				placeDiv(d.next,d.prev);
				var n:IDiv = d.next;
				while (n) { n.state.init(); n = n.next; }
			}
			if ( first != last ) {
				if ( d == first ) { first = first.next; first.prev = null; }
				else if ( d == last ) { last = last.prev; last.next = null; }
				else { d.prev.next = d.next; d.next.prev = d.prev; }
			}
			else first = last = null;
			d.resetArcs();
			d.delAllDiv();
			d.unbind();
			removeChild(d as Div);
			_numDiv--;
		}
		
		public function getDiv(name:String):IDiv {
			var d:IDiv = first;
			while (d) {
				if (d.name == name ) return d;
				d = d.next;
			}
			return null;
		}
		
		public function delAllDiv():void {
			var d:IDiv = first, n:IDiv;
			while (d) {
				n = d.next;
				d.delAllDiv();
				delDiv(d)
				d = n;
			}
		}
		
		/**
		 * MONITOR CHANGES
		 */
		public function bind():void {
			if (position != 'asbolute') {
				this.addEventListener(Event.CHANGE, check);
				activate(this);
			}
			if (stage) initResize(); 
			else addEventListener(Event.ADDED_TO_STAGE, initResize, false, 0, true );
		}
		
		public function unbind():void {
			if (position != 'asbolute') {
				this.removeEventListener(Event.CHANGE, check);
				desactivate(this);
			}
			stage.removeEventListener(Event.RESIZE, resize );
		}
		
		protected function check(evt:Event=null):void {
			dispatch = false;
			resize();
			dispatch = true;
			for (var i:int = 0; i < arcs.length ; ++i) arcs[i].div.update(this);
		}
		
		public function update(from:IDiv):void {
			if (y >= from.y && y < from.y+from.height && (constraint=='XY' || constraint=='X') ) x = _state.x+((from.x-from.state.x)+(from.width-from.state.width));
			if (x >= from.x && x < from.x+from.width && (constraint=='XY' || constraint=='Y') ) y = _state.y+((from.y-from.state.y)+(from.height-from.state.height));
		}
		
		/**
		 * MANAGE CHANGE EVENTS
		 */
		private function activate(child:Object):void {
			if (!('numChildren' in child)) return;
			for (var i:int = 0; i < child.numChildren; i++) {
				var subChild:Object = child.getChildAt(i);
				subChild.addEventListener( Event.CHANGE, child.dispatchChange );
				if ('dispatchChange' in subChild) activate(subChild);
			}
		}
		
		private function desactivate(child:Object):void {
			if (!('numChildren' in child)) return;
			for (var i:int = 0; i < child.numChildren; i++) {
				var subChild:Object = child.getChildAt(i);
				subChild.removeEventListener( Event.CHANGE, child.dispatchChange );
				if ('dispatchChange' in subChild) desactivate(subChild);
			}
		}
		
		/**
		 * MANAGE ARCS
		 */
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
		public function resetArcs():void { arcs = []; }
		
		/**
		 * UTILITIES
		 */
		protected function setupDiv(div:IDiv):void {
			placeDiv(div,last);
			if (last) last.addArc(div);
			state.init();
			div.state.init();
			div.bind();
		}
		
		protected function placeDiv(div:IDiv, prev:IDiv):void {
			var X:Number = ((prev)?prev.x:0), Y:Number = ((prev)?prev.y:0);
			if (div.float == 'none') Y = Y+div.margins.top+((prev)?prev.height+prev.margins.bottom:0)+div.padding.y;
			else if (div.float == 'left') X = X+div.margins.left+((prev)?prev.width+prev.margins.right:0)+div.padding.x;
			div.x = X;
			div.y = Y;
		}
		
		protected function insert(div:IDiv):void {
			div.master = this;
			div.addArc(div.next);
			placeDiv(div.next,div);
			state.init();
			var n:IDiv = div;
			while (n) { n.state.init(); n = n.next; }
			div.bind();
			addChild(div as Div);
			_numDiv++;
		}
		
		protected function getMaster():* { return this; }
		
		protected function boulderDash():void {
			state.init();
			if (stage) initResize();
			else if(!hasEventListener(Event.ADDED_TO_STAGE)) addEventListener(Event.ADDED_TO_STAGE, initResize);
			var m:* = master;
			while (m && m is IDiv) { m.state.init(); m.resize(); m = m.master; }
		}
		
		/**
		 * RESIZE
		 */
		protected function initResize(evt:Event=null):void {
			removeEventListener( Event.ADDED_TO_STAGE, initResize);
			stage.addEventListener(Event.RESIZE, resize, false , 0, true );
			resize();
		}
		 
		public function resize(evt:Event = null):void {
			var W:Number = (!isDiv)?stage.stageWidth:parent.width, H:Number = (!isDiv)?stage.stageHeight:parent.height, a:String=_align;
			x = (a=='TL' || a=='L' || a=='CENTERY' )?state.x:(a=='TR' || a=='BR' || a=='R')?W-width:(a=='BL')?0:(a=='T' || a=='B' || a=='CENTER' || a=='CENTERX')?W*.5-width*.5:x;
			y = (a=='TL' || a=='TR' || a=='T' || a=='CENTERX')?state.y:(a=='BR' || a=='BL' || a=='B')?stage.stageHeight-height:(a=='L' || a=='R' || a=='CENTER' || a=='CENTERY')?H*.5-height*.5:y;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get numDiv():int { return _numDiv; }
		public function get state():DivState { return _state; }
		public function get prev():IDiv { return _prev; }
		public function set prev(value:IDiv):void { _prev = value; }
		public function get next():IDiv { return _next; }	
		public function set next(value:IDiv):void { _next = value; }
		public function get master():Object { return _master; }
		public function set master(value:Object):void { _master = value; }
		public function get float():String { return _float; }
		public function set float(value:String):void { _float=value; }
		public function get align():String { return _align; }
		public function set align(value:String):void { _align=value; }
		public function get position():String { return _position; }
		public function set position(value:String):void { _position=value; }
		public function get margins():DivMargin { return _margins; }
		public function set margins(value:DivMargin):void { _margins = value; }
		public function get data():Object { return _data; }
		public function set data(value:Object):void { _data = value; }
		public function get constraint():String { return _constraint; }
		public function set constraint(value:String):void { _constraint = value; }
		public function get padding():Point { return _padding; }
		public function set padding(value:Point):void { _padding = value; }
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '['+super.toString().split(' ')[1].split(']')[0].toUpperCase()+'::'+name+']'
		}
	}
}