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
		public var target:Object;
		public var id:int=0;
		public var startTime:Number;
		public var position:Number=0;
		public var duration:Number;
		public var elapsedTime:Number=0;
		public var props:Array=[];
		public var autoRotateH:Object={rotation:true,rotation2:true,rotationX:true,rotationY:true,rotationZ:true};
		
		public var delay:Number=0;
		public var ease:Function=engine.defaultEase;
		public var autoDispose:Boolean=true;
		public var autoStart:Boolean=true;
		public var autoRotate:Boolean;
		public var autoAlpha:Boolean;
		public var rounded:Boolean;
		public var onBegin:Function;
		public var onBeginParams:Array=[];
		public var onUpdate:Function;
		public var onUpdateParams:Array=[];
		public var onComplete:Function;
		public var onCompleteParams:Array=[];
		
		
		public function LiteTween( target:Object=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ) { init( target,duration,props,options,position ); }
		
		public function init( target:Object, duration:Number, props:Object, options:Object=null, position:Number=0 ):void {
			this.target = target;
			this.duration = duration;
			stripProps( props );
			stripOptions( options );
			if (position) setPosition( position );
			if (autoStart && this.target ) start();
		}
		
		public function start():void {
			if (!id) {
				id = engine.add( this );
				if(onBegin!=null) onBegin.apply(null,onBeginParams);
				if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
			}
		}
		
		public function pause():void {
			id = engine.remove( this );
			position += elapsedTime;
		}
		
		public function dispose():void {
			props = null;
			target = null;
		}
		
		public function setPosition(pos:Number):void {
			position = elapsedTime = pos;
			if ( updateProperties(ease(pos,0,1,duration)) == 1) dispose();
		}
		
		public function update( time:Number ):void {
			elapsedTime = time;
			time -= delay-position;
			if ( updateProperties( ((time >= duration)?1:((time <= 0)?0:ease(time,0,1,duration))) ) == 1 ) complete();
		}
		
		protected function updateProperties( ratio:Number ):Number {
			var i:int = 0, value:Number;
			if ( ratio!=0 && target!=null ){
				while ( i < props.length ) {
					value = props[i][2]+(props[i][3]-props[i][2])*ratio;
					target[props[i][0]] = props[i][1] = (rounded)?Math.round(value):value;
					if ( autoAlpha && props[i][0]=='alpha' && value==0 ) target.visible = false;
					i++;
				}
				if(onUpdate!=null) onUpdate.apply(null,onUpdateParams);
				if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			}
			return ratio;
		}
		
		protected function complete():void {
			id = engine.remove( this );
			if(onComplete!=null) onComplete.apply(null,onCompleteParams);
			if(hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
			if(autoDispose) dispose();
		}
		
		protected function stripProps( ps:Object ):void {
			var p:String;
			for ( p in ps ){ props.push( (( autoRotateH.hasOwnProperty(p) )?[p,null,target[p]%360+((Math.abs(target[p]%360-ps[p]%360)<180)?0:(target[p]%360>ps[p]%360)?-360:360), ps[p]%360]:[p,null,target[p],ps[p]]) ); }
		}
		
		protected function stripOptions( os:Object ):void {
			var o:String;
			for ( o in os ) { if ( this.hasOwnProperty(o) || this[o]==null) this[o] = os[o]; }
		}
		
		public function get proxy():* {}
	}
}