/**
* 
* Link
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.ui.link 
{	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.geom.ColorTransform;
	import com.asual.swfaddress.SWFAddress;
	
	
	public class Link  
	{	
		public var next:Link;
		public var prev:Link;
		
		public var name:String;
		public var target:Object;
		public var content:Object;
		public var action:Function;
		public var colors:Object;
		public var type:String;
		public var dummy:Boolean;
		public var data:*;
		public var swfAddress:Boolean;     
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
		 * @param	target
		 * @param	type
		 * @param	colors
		 * @param	actions
		 * @param	swfAddressEnable
		 * @param	dummy
		 */
		public function Link( name:String, target:Object = null, type:String = 'mouse', action:Function = null, colors:Object = null, swfAddress:Boolean = false, dummy:Boolean = false, data:*=null ) {
			this.content = new Object();
			this.name = name;
			this.target = (dummy)?new Shape():target;
			this.action = action;
			this.colors = colors;
			this.type = type;
			this.dummy = dummy;
			this.data = data;			
			this.swfAddress = swfAddress;
			initListeners();			
		}
		
		public function addContent( name:String, target:Object = null, action:Function = null, colors:Object = null, inside:Boolean = false, data:*=null):void {
			if (inside) target.mouseEnabled = false;
			content[name] = { object:target, type:getType(target), colors:colors, action:action, data:data };
			
		}
		
		/**
		 * GET OBJECT TYPE
		 */
		private function getType( object:* ):String { return (object is TextField)?'text':'object'; }
		
		/**
		 * LISTENERS
		 */
		public function initListeners():void {
			if(!dummy) this.target.buttonMode = true;
			if ( type == 'mouse'){
				target.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
				target.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			} else if ( type == 'roll') {
				target.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
				target.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			}
			target.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			if(!dummy) this.target.buttonMode = false;
			if ( type == 'mouse') {
				target.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent );
				target.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			} else if ( type == 'roll') {
				target.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
				target.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			}
			target.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		/**
		 * TO STRING
		 */
		public function toString():String {
			return '[ LINK > ' + this.name +' ]';
		}
		
		
		/**
		 * DEEP LINK ACTIONS
		 * 
		 * @param	data
		 */
		public function deepLinkAction(data:*= null):void { action(data).call(); }
		
		
		/**
		 * NORMAL LINK ACTIONS
		 */
		public function doAction():void { 
			var prop:String;
			if ( action != null ) { 
				active = true; 
				action("do",target,((data is Function)?data.call():data));
				for ( prop in content ) if ( content[prop].action != null ) content[prop].action("do",content[prop].object,((content[prop].data is Function)?content[prop].data.call():content[prop].data));
			} 
		}
		
		public function undoAction():void {
			var prop:String;
			if ( action != null ) { 
				active = false; 
				action("undo",target,((data is Function)?data.call():data));
				for ( prop in content ) if ( content[prop].action != null ) content[prop].action("undo",content[prop].object,((content[prop].data is Function)?content[prop].data.call():content[prop].data));
			} 
		}
		
		
		/**
		 * GETTER/SETTER
		 */
		public function get mouseChildren():Boolean { return target.mouseChildren; }
		public function set mouseChildren(value:Boolean):void { target.mouseChildren = value; }
		
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { delListeners(); }
		
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( evt:* ):void {
			var prop:String, type:String = getType( target );
			switch( evt.type ) {
				case MouseEvent.MOUSE_OVER : 
				case MouseEvent.ROLL_OVER :
					if ( swfAddress ) SWFAddress.setStatus(name);
					if ( colors ) changeColor(target, type, colors.out, colors.hover );
					if ( action != null ) action('hover',target,((data is Function)?data.call():data) );
					//--content
					for ( prop in content ) {
						if ( content[prop].colors != null ) changeColor(content[prop].object, type, content[prop].colors.out, content[prop].colors.hover); 
						if ( content[prop].action != null ) content[prop].action('hover',content[prop].object,((content[prop].data is Function)?content[prop].data.call():content[prop].data) );
					}
					break;
					
				case MouseEvent.MOUSE_OUT :
				case MouseEvent.ROLL_OUT :
					if ( swfAddress ) SWFAddress.resetStatus();
					if ( colors ) changeColor(target, type, colors.hover, colors.out );
					if ( action != null ) action('out',target,((data is Function)?data.call():data) );
					//--content
					for ( prop in content ) {
						if( content[prop].colors != null ) changeColor(content[prop].object, type, content[prop].colors.hover, content[prop].colors.out); 
						if( content[prop].action != null ) content[prop].action('out',content[prop].object,((content[prop].data is Function)?content[prop].data.call():content[prop].data) );
					}	
					break;
					
				case MouseEvent.CLICK :
					if ( swfAddress ) SWFAddress.setValue(name);
					else {
						if (active) { active = false; if( action != null ){ action("undo",target,((data is Function)?data.call():data) ); } }
						else{ active = true; if( action != null ){ action("do",target,((data is Function)?data.call():data)); } }
					}
					if ( colors ) changeColor(target, type, colors.hover, colors.click );
					//--content
					for ( prop in content ) {
						if( content[prop].colors != null ) changeColor(content[prop].object, type, content[prop].colors.hover, content[prop].colors.click); 
						if ( content[prop].action != null  ) { 
							if( !active ) content[prop].action("do",content[prop].object,((content[prop].data is Function)?content[prop].data.call():content[prop].data) );
							else content[prop].action("undo",content[prop].object,((content[prop].data is Function)?content[prop].data.call():content[prop].data) );
						}
					}	
					break;
			}
		}
		
		/**
		 * ENGINE
		 */
		private function changeColor(target:*, type:String, startColor:uint, endColor:uint):void {
			target.addEventListener('enterFrame', update );
			this.startTime = getTimer()*.001;
			this.startColor = startColor 
			this.endColor = endColor 
			this.updateType = type;
			this.toUpdate = target;
		}
		
		private function update(evt:*):void {
			var time:Number = (getTimer()*.001-startTime);
			if ( updateColor(((time>=.2)?1:((time<=0)?0:ease(time,0,1,.2))))==1 ) target.removeEventListener('enterFrame', update );
		}
		
		private function updateColor(ratio:Number):int {
			if ( updateType == 'text') target.textColor = clr(ratio,startColor,endColor);
			else { var c:ColorTransform = new ColorTransform(); c.color=clr(ratio,startColor,endColor); target.transform.colorTransform=c; }
			return ratio;
		}
		
		private function clr(r:Number,b:uint,e:uint):uint {
			var q:Number=1-r;
			return  (((b>>24)&0xFF)*q+((e>>24)&0xFF)*r)<<24|(((b>>16)&0xFF)*q+((e>>16)&0xFF)*r)<<16|(((b>>8)&0xFF)*q+((e>>8)&0xFF)*r)<<8|(b&0xFF)*q+(e&0xFF)*r;
		}
		
		private function ease(t:Number,b:Number,c:Number,d:Number):Number { return c*t/d+b; }
	}
}