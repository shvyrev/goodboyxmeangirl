/**
 * 
 * lightweight Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import railk.as3.motion.core.Engine;
	import railk.as3.motion.utils.Prop;
	
	public class RTweeny extends EventDispatcher
	{
		/**
		 * actions
		 */
		static public function to( target:Object=null,duration:Number=NaN,props:Object=null,options:Object=null,position:Number=0 ):RTweeny { return new RTweeny(target,duration,props,options,position); }

		/**
		 * Class
		 */
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
		public var autoVisible:Boolean;
		public var rounded:Boolean;
		public var onBegin:Function;
		public var onBeginParams:Array=[];
		public var onUpdate:Function;
		public var onUpdateParams:Array=[];
		public var onComplete:Function;
		public var onCompleteParams:Array=[];
		
		
		public function RTweeny( target:Object=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ) { init( target,duration,props,options,position ); }
		
		public function init( target:Object, duration:Number, props:Object, options:Object=null, position:Number=0 ):void {
			this.target = target;
			this.duration = duration;
			stripProps( props );
			stripOptions( options );
			if (position) setPosition( position );
			if (autoStart && this.target ) start();
		}
		
		public function start():void {
			if (!id && target) {
				id = engine.add( this );
				if(onBegin!=null) onBegin.apply(null,onBeginParams);
				if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
			}
		}
		
		public function pause():void {
			if(id && target){
				id = engine.remove( this );
				position += elapsedTime;
			}	
		}
		
		public function dispose():void { target = props = null; }
		
		public function setPosition(pos:Number):void {
			position = elapsedTime = pos;
			if ( updateProperties(ease(pos,0,1,duration)) == 1 && autoDispose ) dispose();
		}
		
		public function update( time:Number ):void {
			elapsedTime = time = time-startTime;
			time -= delay-position;
			if ( updateProperties( ((time >= duration)?1:((time <= 0)?0:ease(time,0,1,duration))) ) == 1 ) complete();
		}
		
		protected function updateProperties( ratio:Number ):Number {
			var i:int=props.length;
			if ( target ) {
				while( --i > -1 ) {
					var p:Prop = props[i];
					var value:Number=Number(p.start)+Number(p.end-p.start)*ratio+1e-18-1e-18;
					target[p.type] = p.current = (rounded)?Math.round(value):value;
					if ( autoVisible && p.type == 'alpha' ) target.visible = value > 0;
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
			for ( var p:String in ps ) props[props.length] = new Prop(p,p,target[p],ps[p],autoRotateH.hasOwnProperty(p));
		}
		
		protected function stripOptions( os:Object ):void {
			for ( var o:String in os ) if ( this.hasOwnProperty(o) || this[o]==null) this[o] = os[o];
		}
	}
}