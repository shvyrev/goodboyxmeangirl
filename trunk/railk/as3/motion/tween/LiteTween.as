/**
 * 
 * Lite Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.tween
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import railk.as3.motion.IRTween
	import railk.as3.motion.core.Engine;
	
	public class LiteTween extends EventDispatcher implements IRTween
	{	
		protected var engine:Engine = Engine.getInstance();
		protected var tween:IRTween;
		
		protected var _id:int;
		protected var _target:Object;
		protected var _startTime:Number;
		protected var _head:Boolean = false;
		protected var _tail:Boolean = true;
		protected var _next:IRTween = null;
		protected var _prev:IRTween = null;
		
		public var duration:Number;
		public var elapsedTime:Number=0;
		public var props:Array = [];
		public var autoRotateHash:Object = {rotation:true,rotation2:true,rotationX:true,rotationY:true,rotationZ:true};
		
		public var delay:Number = 0;
		public var ease:Function = engine.defaultEase;
		public var autoDispose:Boolean = true;
		public var autoStart:Boolean = true;
		public var autoRotate:Boolean = false;
		public var autoAlpha:Boolean = false;
		public var rounded:Boolean = false;
		
		public var onBegin:Function;
		public var onBeginParams:Array=[];
		public var onUpdate:Function;
		public var onUpdateParams:Array=[];
		public var onComplete:Function;
		public var onCompleteParams:Array=[];
		
		
		static public function to( target:Object, duration:Number, props:Object, options:Object = null ):LiteTween { return new LiteTween( target, duration, props, options); }
		
		public function LiteTween( target:Object, duration:Number, props:Object, options:Object = null )
		{
			_target = target;
			this.tween = this;
			this.duration = duration;
			this.stripProps( props );
			this.stripOptions( options );
			if ( autoStart ) start();
		}
		
		public function start():void 
		{ 
			_id = engine.add( tween );
			if(onBegin!=null) onBegin.apply(null,onBeginParams);
			if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
		}
		
		public function pause():void{}
		
		public function overlap():void{}
		
		public function dispose():void
		{
			_prev = null;
			_next = null;
			onBegin = null;
			onUpdate = null;
			onComplete = null;
			_target = null;
			tween = null;
		}
		
		public function update( time:Number ):void
		{
			var ratio:Number;
			elapsedTime = time;
			time -= delay;
			if( time >= duration ){
				time = duration;
				ratio = 1;
				if(onComplete!=null) onComplete.apply(null,onCompleteParams);
				if (hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
				engine.remove( tween );
				if(autoDispose) dispose();
			} else {
				ratio = (time <= 0)?0:ease( time, 0, 1, duration );
			}
			updateProperties( ratio );
		}
		
		public function updateProperties( ratio:Number ):void
		{
			var i:int = 0, value:Number
			if ( ratio != 0 && _target!=null ){
				while ( i < props.length ) {
					value = props[i][2]+(props[i][3]-props[i][2])*ratio;
					_target[props[i][0]] = props[i][1] = (rounded)?int(value):value;
					if(onUpdate!=null) onUpdate.apply(null,onUpdateParams);
					if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
					i++;
				}
			}	
		}
		
		protected function stripProps( props:Object ):void
		{
			var p:String;
			for ( p in props ){ this.props.push( (( autoRotateHash.hasOwnProperty(p) )?[p,null,_target[p]%360+((Math.abs(_target[p]%360-props[p]%360)<180)?0:(_target[p]%360>props[p]%360)?-360:360), props[p]%360]:[p,null,_target[p],props[p]]) ); }
		}
		
		protected function stripOptions( options:Object ):void
		{
			var o:String;
			for ( o in options ) { if ( this[o] != undefined || this[o]==null) this[o] = options[o]; }
		}
		
		public function get id():int { return _id; }
		public function get target():Object { return _target; }
		public function get head():Boolean { return _head; }
		public function set head(value:Boolean):void { _head = value; }
		public function get tail():Boolean { return _tail; }
		public function set tail(value:Boolean):void { _tail = value; }
		public function get next():IRTween { return _next; }
		public function set next(value:IRTween):void { _next = value; }
		public function get prev():IRTween { return _prev; }
		public function set prev(value:IRTween):void { _prev = value; }
		public function get startTime():Number { return _startTime; }
		public function set startTime(value:Number):void { _startTime = value; }
	}
	
}