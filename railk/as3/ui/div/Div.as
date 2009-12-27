/**
 * Div
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	import flash.events.Event;
	import railk.as3.display.RegistrationPoint;
	
	public class Div extends RegistrationPoint implements IDiv
	{	
		protected var arcs:Array = [];
		protected var isDiv:Boolean;
		protected var _state:DivState;
		protected var _position:String;
		protected var _float:String;
		protected var _align:String;
		protected var _margins:Object = { top:0, right:0, bottom:0, left:0 };
		protected var _data:Object;
		protected var _constraint:String;
		
		public function Div(name:String = 'undefined', float:String = 'none', align:String = 'none', margins:Object = null, position:String = 'relative', x:Number = 0, y:Number = 0, data:Object = null, constraint:String = 'XY' ) {
			super();
			this.name = name;
			if (margins) this.margins = margins;
			this.float = float;
			this.align = align;
			this.position = position;
			this.x = x;
			this.y = y;
			this.data = data;
			this.constraint = constraint;
			this.state = new DivState(this);
			addEventListener(Event.ADDED_TO_STAGE, added );
		}
		
		/**
		 * ADDED TO STAGE
		 */
		private function added(evt:Event):void { 
			removeEventListener(Event.ADDED_TO_STAGE, added ),
			isDiv = ('addDiv' in parent)?false:true;
		}
		
		/**
		 * MONITOR CHANGES
		 */
		public function bind():void {
			if (position != 'asbolute') {
				this.addEventListener(Event.CHANGE, check);
				activate(this);
			}
			if (align != 'none') {
				if (stage) initResize(); 
				else addEventListener(Event.ADDED_TO_STAGE, initResize );
			}
		}
		
		public function unbind():void {
			if (position != 'asbolute') {
				this.removeEventListener(Event.CHANGE, check);
				desactivate(this);
			}
			if (align != 'none') stage.removeEventListener(Event.RESIZE, resize );
		}
		
		protected function check(evt:Event):void {
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
			for (var i:int = 0; i < child.numChildren; i++) {
				var subChild:Object = child.getChildAt(i);
				if (!subChild.hasEventListener(Event.CHANGE)) {
					subChild.addEventListener( Event.CHANGE, child.dispatchChange );
					if ( subChild.hasOwnProperty('dispatchChange') && subChild.numChildren > 0) activate(subChild);
				}
			}
		}
		
		private function desactivate(child:Object):void {
			for (var i:int = 0; i < child.numChildren; i++) {
				var subChild:Object = child.getChildAt(i);
				if (subChild.hasEventListener(Event.CHANGE)) {
					subChild.removeEventListener( Event.CHANGE, child.dispatchChange );
					if ( subChild.hasOwnProperty('dispatchChange') && subChild.numChildren > 0) desactivate(subChild);
				}
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
		public function setFocus():void { 
			parent.swapChildren( this, parent.getChildAt(parent.numChildren-1) );
			if (parent is IDiv) (parent as IDiv).setFocus();
		}
		
		/**
		 * RESIZE
		 */
		protected function initResize(evt:Event = null):void {
			removeEventListener( Event.ADDED_TO_STAGE, initResize);
			stage.addEventListener(Event.RESIZE, resize, false , 0, true );
			resize();
		}
		 
		public function resize(evt:Event = null):void {
			var W:Number = (!isDiv)?stage.stageWidth:parent.width;
			var H:Number = (!isDiv)?stage.stageHeight:parent.height;
			switch(_align) {
				case 'TL' : 
					x = state.x;
					y = state.y; 
					break;
				case 'TR' : 
					x = W - width;
					y = state.y;
					break;
				case 'BR' :
					x = W - width;
					y = stage.stageHeight - height;
					break;
				case 'BL' : 
					x = 0;
					y = stage.stageHeight - height;
					break;
				case 'T' :
					x = W*.5-width*.5;
					y = state.y;
					break;
				case 'L' :
					x = state.x;
					y = H*.5-height*.5;
					break;
				case 'R' :
					x = W - width;
					y = H*.5-height*.5;
					break;
				case 'B' :
					x = W*.5-width*.5;
					y = stage.stageHeight - height;
					break;
				case 'CENTER' :
					x = W*.5-width*.5;
					y = H*.5-height*.5;
					break;
				case 'CENTERX' : 
					x = W*.5-width*.5;
					y = state.y;
					break;
				case 'CENTERY' :
					x = state.x;
					y = H*.5-height*.5;
					break;
				default : break;
			}
		}
		
		/**
		 * GETTER/SETTER
		 */
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
		public function get data():Object { return _data; }
		public function set data(value:Object):void { _data = value; }
		public function get constraint():String { return _constraint; }
		public function set constraint(value:String):void { _constraint = value; }
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '['+super.toString().split(' ')[1].split(']')[0].toUpperCase()+'::'+name+']'
		}
	}
}