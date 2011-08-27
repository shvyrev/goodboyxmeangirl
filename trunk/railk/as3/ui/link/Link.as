/**
* 
* Link
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.ui.link 
{	
	import flash.events.Event;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.geom.ColorTransform;
	import com.asual.swfaddress.SWFAddress;
	
	public class Link implements ILink
	{	
		private var _prev:ILink;
		private var _name:String;
		private var _title:String;
		private var _group:String;
		private var _navigation:Boolean;
		private var _swfAddress:Boolean; 
		private var _targets:Dictionary = new Dictionary(true);
		private var _active:Boolean;
		
		private var startTime:Number;
		private var startColor:uint;
		private var endColor:uint;
		private var updateType:String;
		private var toUpdate:*;
		private var mouse:Boolean = false;
		private var enabled:Boolean;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	name
		 * @param	group
		 * @param	swfAddressEnable
		 */
		public function Link( name:String, title:String='', group:String = '', navigation:Boolean=false, swfAddress:Boolean = false ) {
			_name = name;
			_title = title;
			_group = group;
			_navigation = navigation;
			_swfAddress = swfAddress;
		}
		
		public function addTarget(name:String, target:Object, event:String = 'mouse', action:Function = null, colors:Object = null, inside:Boolean = false, data:*= null):ILink {
			if (inside) target.mouseEnabled = false;
			if (target) {
				initListeners(target, event);
				_targets[name] = { target:target, type:getType(target), event:event, colors:colors, action:action, data:data };
			} else targets[name] = { target:target, action:action, data:data };
			activate(_targets[name]);
			return this;
		}
		
		/**
		 * GET OBJECT TYPE
		 */
		private function getType( object:* ):String { return (object is TextField)?'text':'object'; }
		
		/**
		 * LISTENERS
		 */
		private function initListeners(target:Object,event:String):void {
			target.buttonMode = true;
			if ( event == 'mouse'){
				target.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
				target.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			} else if ( event == 'roll') {
				target.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
				target.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			}
			target.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		private function delListeners(target:Object,event:String):void {
			target.buttonMode = false;
			if ( event == 'mouse'){
				target.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent );
				target.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			} else if ( event == 'roll') {
				target.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
				target.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			}
			target.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		private function initAllListeners():void { enabled = true; for each (var t:Object in _targets) if (t.target) initListeners(t.target,t.event); }
		private function delAllListeners():void { enabled = false; for each (var t:Object in _targets) if (t.target) delListeners(t.target,t.event); }
		
		/**
		 * ACTION
		 * 
		 * @param	anchor
		 */
		public function action(data:*= null):void {
			if ( !_active ) doAction(data);
			else undoAction(data);
		}
		
		public function doAction(data:*=null):void {
			if (_active) return;
			var t:Object ;
			_active = true; 
			for each (t in targets) {
				data = (data)?data:((t.data is Function)?t.data.call():t.data);
				if( t.colors != null && t.target ) changeColor(t.target, t.type, (mouse?t.colors.hover:t.colors.out), t.colors.click);
				if ( t.action != null ) t.action("do",t.target,data);
			}
		}
		
		public function undoAction(data:*=null):void {
			if (!_active) return;
			var t:Object ;
			_active = false; 
			for each (t in targets) {
				data = (data)?data:((t.data is Function)?t.data.call():t.data);
				if( t.colors != null && t.target) changeColor(t.target, t.type, t.colors.click, (mouse?t.colors.hover:t.colors.out));
				if ( t.action != null ) t.action("undo",t.target,data);
			}
		}
		
		private function activate(t:Object):void {
			if (!_active) return;
			if( t.colors != null && t.target) changeColor(t.target, t.type, t.colors.out, t.colors.click);
			if ( t.action != null ) t.action("undo",t.target,t.data);
		}
		
		/**
		 * ENABLE
		 */
		public function disable():void { if (enabled) delAllListeners(); }
		public function enable():void { if (!enabled) initAllListeners(); }
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { delAllListeners(); }
		
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( e:MouseEvent ):void {
			var t:Object;
			switch( e.type ) {
				case MouseEvent.MOUSE_OVER : 
				case MouseEvent.ROLL_OVER :
					if ( swfAddress ) SWFAddress.setStatus(name);
					for each (t in targets) {
						if ( t.colors != null && !active) changeColor(t.target, t.type, t.colors.out, t.colors.hover); 
						if ( t.action != null ) t.action('hover',t.target,((t.data is Function)?t.data.call():t.data) );
					}
					break;
					
				case MouseEvent.MOUSE_OUT :
				case MouseEvent.ROLL_OUT :
					if ( swfAddress ) SWFAddress.resetStatus();
					for each (t in targets) {
						if( t.colors != null && !active) changeColor(t.target, t.type, t.colors.hover, t.colors.out); 
						if( t.action != null ) t.action('out',t.target,((t.data is Function)?t.data.call():t.data) );
					}	
					break;
					
				case MouseEvent.CLICK :
					mouse = true;
					if ( swfAddress ) SWFAddress.setValue(name);
					else {
						action();
						LinkManager.getInstance().navigationChange(name);
					}
					mouse = false;
					break;
				default : break;
			}
		}
		
		/**
		 * ENGINE
		 */
		private function changeColor(target:*, type:String, startColor:uint, endColor:uint):void {
			target.addEventListener(Event.ENTER_FRAME, update );
			this.startTime = getTimer()*.001;
			this.startColor = startColor 
			this.endColor = endColor 
			this.updateType = type;
			this.toUpdate = target;
		}
		
		private function update(e:Event):void {
			var time:Number = (getTimer()*.001-startTime), target:Object=e.currentTarget;
			if ( updateColor(target,((time>=.2)?1:((time<=0)?0:ease(time,0,1,.2))))==1 ) target.removeEventListener(Event.ENTER_FRAME, update );
		}
		
		private function updateColor(target:Object,ratio:Number):int {
			if ( updateType == 'text') target.textColor = clr(ratio,startColor,endColor);
			else { var c:ColorTransform = new ColorTransform(); c.color=clr(ratio,startColor,endColor); target.transform.colorTransform=c; }
			return ratio;
		}
		
		private function clr(r:Number,b:uint,e:uint):uint {
			var q:Number=1-r;
			return  (((b>>24)&0xFF)*q+((e>>24)&0xFF)*r)<<24|(((b>>16)&0xFF)*q+((e>>16)&0xFF)*r)<<16|(((b>>8)&0xFF)*q+((e>>8)&0xFF)*r)<<8|(b&0xFF)*q+(e&0xFF)*r;
		}
		
		private function ease(t:Number, b:Number, c:Number, d:Number):Number { return c * t / d + b; }
		
		
		/**
		 * GETTER/SETTER
		 */
		public function get prev():ILink { return _prev; }
		public function set prev(value:ILink):void { _prev = value; }
		public function get name():String { return _name; }
		public function get title():String { return _title; }
		public function get group():String { return _group; }
		public function get navigation():Boolean { return _navigation; }
		public function get swfAddress():Boolean { return _swfAddress; }
		public function get targets():Dictionary { return _targets; }
		public function get active():Boolean { return _active; }
		
		
		/**
		 * TO STRING
		 */
		public function toString():String {
			return '[ LINK > ' + this.name +' ]';
		}
	}
}