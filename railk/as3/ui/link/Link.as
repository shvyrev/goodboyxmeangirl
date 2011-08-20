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
	
	
	public class Link  
	{	
		public static const ROLL_EVENT:String = "roll";
		public static const MOUSE_EVENT:String = "mouse";
		
		public var next:Link;
		public var prev:Link;
		
		public var name:String;
		public var group:String;
		public var navigation:Boolean;
		public var swfAddress:Boolean; 
		public var targets:Dictionary = new Dictionary(true);
		public var active:Boolean;
		
		private var startTime:Number;
		private var startColor:uint;
		private var endColor:uint;
		private var updateType:String;
		private var toUpdate:*;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	name
		 * @param	group
		 * @param	swfAddressEnable
		 */
		public function Link( name:String, group:String = '', navigation:Boolean=false, swfAddress:Boolean = false ) {
			this.name = name;
			this.group = group;
			this.navigation = navigation;
			this.swfAddress = swfAddress;
		}
		
		public function addTarget(name:String, target:Object, event:String = 'mouse', action:Function = null, colors:Object = null, inside:Boolean = false, data:*= null):Link {
			if (inside) target.mouseEnabled = false;
			if (target) {
				initListeners(target, event);
				targets[name] = { target:target, type:getType(target), event:event, colors:colors, action:action, data:data };
			} else targets[name] = { target:target, action:action, data:data };
			activate(targets[name]);
			return this;
		}
		
		/**
		 * GET OBJECT TYPE
		 */
		private function getType( object:* ):String { return (object is TextField)?'text':'object'; }
		
		/**
		 * LISTENERS
		 */
		public function initListeners(target:Object,event:String):void {
			if(target.hasOwnProperty("buttonMode")) target.buttonMode = true;
			if ( event == MOUSE_EVENT){
				target.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
				target.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			} else if ( event == ROLL_EVENT) {
				target.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
				target.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			}
			target.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		public function delListeners(target:Object,event:String):void {
			if(target.hasOwnProperty("buttonMode")) target.buttonMode = false;
			if ( event == MOUSE_EVENT){
				target.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent );
				target.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			} else if ( event == ROLL_EVENT) {
				target.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
				target.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			}
			target.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		public function initAllListeners():void { for each (var t:Object in targets) if (t.target) initListeners(t.target,t.event); }
		public function delAllListeners():void { for each (var t:Object in targets) if (t.target) delListeners(t.target,t.event); }
		
		
		/**
		 * ACTION
		 * 
		 * @param	anchor
		 */
		public function action(data:*= null,mouse:Boolean=false):void {
			var t:Object ;
			if ( !active ) {
				active = true; 
				for each (t in targets) {
					data = (data)?data:((t.data is Function)?t.data.call():t.data);
					if( t.colors != null && t.target ) changeColor(t.target, t.type, (mouse?t.colors.hover:t.colors.out), t.colors.click);
					if ( t.action != null ) t.action("do",t.target,data);
				}
			} else {
				active = false; 
				for each (t in targets) {
					data = (data)?data:((t.data is Function)?t.data.call():t.data);
					if( t.colors != null && t.target) changeColor(t.target, t.type, t.colors.click, (mouse?t.colors.hover:t.colors.out));
					if ( t.action != null ) t.action("undo",t.target,data);
				}
			}
		}
		
		private function activate(t:Object):void {
			if (!active) return;
			if( t.colors != null && t.target) changeColor(t.target, t.type, t.colors.out, t.colors.click);
			if ( t.action != null ) t.action("undo",t.target,t.data);
		}
		
		
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
					if ( swfAddress ) SWFAddress.setValue(name);
					else action(null,true);
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
		 * TO STRING
		 */
		public function toString():String {
			return '[ LINK > ' + this.name +' ]';
		}
	}
}