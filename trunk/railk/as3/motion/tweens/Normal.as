/**
 * Regualar Tween (7.3k with all modules) (4,9k alone );
 * 		Strong typed with pooling and module system including :
 * 			text / textColor /
 * 			color / 
 * 			tint / brightness / saturation / contrast / hue / treshold /
 * 			filters /
 * 			bezier /
 * 		Includes eventSystem + callbacks functions
 * 		Includes reflect and repeat
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.tweens
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import railk.as3.motion.utils.*;
	
	final public class Normal extends EventDispatcher
	{
		static private const tweens:Array=[];
		static private const ticker:Shape = new Shape();
		static private const pool:Pool = Pool.getInstance();
		
		static private var length:int;
		static private var head:Normal;
		private var prev:Normal;
		private var next:Normal;
		
		public var id:int=0;
		public var target:Object;
		public var startTime:Number;
		public var position:Number=0;
		public var duration:Number;
		public var elapsedTime:Number=0;
		public var props:Array=[];
		public var autoStart:Boolean=true;
		public var autoVisible:Boolean;
		
		public var _repeat:int=0;
		public var _reflect:Boolean;
		public var _delay:Number=0;
		public var _ease:Function=easeOut;
		public var _rounded:Boolean;
		public var _dispose:Boolean=true;
		public var _onBegin:Function;
		public var _onBeginParams:Array=[];
		public var _onUpdate:Function;
		public var _onUpdateParams:Array=[];
		public var _onComplete:Function;
		public var _onCompleteParams:Array = [];
		
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	target
		 */
		public function Normal() { super(); }
		public function init(target:Object = null, autoStart:Boolean=true):Normal {
			this.target = target; 
			this.autoStart
			return this;
		}
		
		/**
		 * TO
		 * 
		 * @param	duration
		 * @param	props
		 * @return
		 */
		public function to( duration:Number=0, props:Object=null ):Normal {
			this.duration = duration;
			stripProps( props );
			if (autoStart && this.target ) play();
			return this;
		}
		
		/**
		 * ACTIONS
		 */
		public function setPosition(pos:Number):Normal { position = pos; update(pos, true); return this; }
		public function scalePool(size:int,growth:int):Normal { pool.scale(size,growth); return this; }
		public function setModule(...modules):Normal { return this; }
		public function delay( value:Number ):Normal { _delay = value; return this; }
		public function ease( value:Function ):Normal { _ease = value; return this; }
		public function repeat( value:int ):Normal { _repeat = value; return this; }
		public function reflect( value:Boolean ):Normal { _reflect = value; return this; }
		public function rounded( value:Boolean ):Normal { _rounded = value; return this; }
		public function dispose( value:Boolean ):Normal { _dispose = value; return this; }
		public function onBegin( value:Function, ...args ):Normal { _onBegin = value; _onBeginParams = args; return this; }
		public function onUpdate( value:Function, ...args ):Normal { _onUpdate = value; _onUpdateParams = args; return this; }
		public function onComplete( value:Function, ...args ):Normal { _onComplete = value; _onCompleteParams = args; return this; }
		
		/**
		 * PLAY/PAUSE
		 */
		public function play():void { if (!id && target) id = add( this ); }
		
		public function pause():void {
			if(id && target){
				id = remove( this );
				position += elapsedTime;
			}
		}
		
		/**
		 * KILL TWEEN
		 */
		public function killTween():void { 
			target = props = null;
			props=[];
			pool.release(this);
		}
		
		/**
		 * MANAGE PROPERTIES
		 */
		public function setProps( os:Object ):void { for ( var o:String in os ) setProp( o, os[o] ); }
		public function setProp(name:String, value:*):void {
			var o:Object={}, i:int=props.length;
			if ( hasOwnProperty(name) ) this[name]=value;
			else {
				while( --i > -1 ){
					var p:Prop= props[i];
					if (p.type == name) { 
						p.end = value; 
						p.start = p.current;
						return; 
					}
				}
				o[name]=value; stripProps(o);
			}
			position = 0;
			reset(this);
		}
		
		public function getProp(name:String):* {
			var i:int=props.length;
			if ( this.hasOwnProperty(name) ) return this[name];
			else while( --i > -1 ) if (props[i].type == name) return props[i].current;
		}
		
		public function delProp(name:String):* {
			var i:int = props.length;
			while( --i > -1 ) if (props[i].type == name) props.splice(i,1);
		}
		
		protected function stripProps( ps:Object ):void {
			var cf:Boolean=false, colorFilters:Object={};
			for ( var p:String in ps ) {
				switch( p ) {
					case 'volume': case 'pan': props[props.length] = new Prop('sound',p,target.soundTransform[p],ps[p]); break;
					case 'text': case 'textColor': props[props.length] = new Prop('text',p,target[p],ps[p]); break;
					case 'color': var c:ColorTransform = target.transform.colorTransform; props[props.length] = new Prop(p, p, c, new ColorTransform(0 - c.redMultiplier, 0 - c.greenMultiplier, 0 - c.blueMultiplier, 0, ((ps[p] >> 16) & 0xff) - c.redOffset, ((ps[p] >> 8) & 0xff) - c.greenOffset, (ps[p] & 0xff) - c.blueOffset)); break;
					case 'hexColor': props[props.length] = new Prop(p,p,target,ps[p]); break;
					case 'GlowFilter': case 'BlurFilter': case 'BevelFilter': case 'DropShadowFilter':  props[props.length] = new Prop('filter',p,filter(p,ps[p]),ps[p]); break;
					case 'tint': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': colorFilters[p] = [p,null,target.filters,ps[p]]; cf=true; break;
					default :
						if( p=='alphaVisible' ){ p='alpha'; autoVisible=true }
						props[props.length] = new Prop(((ps[p] is Array)?'bezier':p), p, ((ps[p] is Array)?bezier(target[p],ps[p]):target[p]), ps[p], (p.search('rotation') != -1)); 
						break;
				}
			}
			if (cf) props[props.length] = new Prop('colorFilter','', null, colorFilters);
		}
		
		
		/**
		 * UPDATE
		 */
		public function update( time:Number, manual:Boolean=false ):void {
			if ( time >= 0 && _onBegin!=null) {
				_onBegin.apply(null, _onBeginParams);
				_onBegin = null;
				if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
			}
			elapsedTime=time=(manual)?time:time-startTime;
			time -= _delay - ((manual)?0:position);
			if ( updateProps( ((time >= duration)?1:((time <= 0)?0:_ease(time,0,1,duration))) ) == 1 ) complete();
		}
		
		private function updateProps( ratio:Number ):Number {
			var i:int=props.length;
			if ( target && ratio ) {
				while( --i > -1 ) {
					var p:Prop=props[i];
					switch( p.type ) {
						case 'sound': case 'text': case 'color': case 'hexColor': case 'colorFilter': case 'filter': case 'bezier': 
							props[i] = getDefinitionByName('railk.as3.motion.modules::'+cap(p.type)+'Module').update( target, p, ratio ); 
							break;
						default :
							var value:Number = value = Number(p.start)+Number(p.end-p.start)*ratio+ 1e-18-1e-18;
							target[p.type] = p.current = (_rounded)?Math.round(value):value;
							if ( autoVisible && p.type == 'alpha' ) target.visible = value > 0;
							break;
					}
				}
				if (_onUpdate != null) _onUpdate.apply(null, _onUpdateParams);
				if( hasEventListener(Event.CHANGE) ) dispatchEvent(new Event(Event.CHANGE));
			}
			return ratio;
		}
		
		private function complete():void {
			if (_repeat>1 || _repeat==-1) {
				if (_reflect) {
					var i:int=props.length, start:*;
					while( --i > -1 ) {
						start = props[i].start;
						props[i].start = props[i].end;
						props[i].end = start;
					}
				}
				position = 0;
				reset(this);
				if(_repeat!=-1) _repeat--;
			} else {
				if (_dispose) killTween();
				if(id) id = remove( this );
				if (_onComplete != null) _onComplete.apply(null, _onCompleteParams);
				if (hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
			}	
		}
		
		
		/**
		 * UTILITIES
		 */
		private function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return -c * (t /= d) * (t - 2) + b; }
		public function cap(str:String):String { return str.substr(0, 1).toUpperCase() +  str.substr(1, str.length); }
		 
		private function filter( filter:String, props:Object ):BitmapFilter {
			var i:int= target.filters.length, classe:Class = getDefinitionByName('flash.filters::'+filter) as Class;
			while( --i > -1 ) if (target.filters[i] is classe) return target.filters[i];
			var f:BitmapFilter = new (classe)();
			for ( var p:String in props ) f[p] = 0;
			return f;
		}
		
		private function bezier(b:Number, e:Array):Array {
			var through:Boolean = false, segments:Array=[];
			if (e[0] is Array) { through = true; e = e[0]; }
			e.unshift(b);
			
			var p:Number, p1:Number, p2:Number = e[0], last:int = e.length-1, i:int = 1, auto:Number = NaN;
			while (i<last) {
				p = p2;
				p1 = e[i];
				p2 = e[++i];
				if (through) {
					if (!segments.length) { auto = (p2-p)/4; segments[segments.length] = new BezierSegment(p,p1-auto,p1);}
					segments[segments.length] = new BezierSegment(p1,p1+auto,p2);
					auto = p2-(p1+auto);
				} else {
					if (i!=last) p2=(p1+p2)/2;
					segments[segments.length] = new BezierSegment(p,p1,p2);
				}
			}
			return segments;
		}
		
		/**
		 * TICKER
		 */
		static private function add( tween:Normal ):int {
			tweens[length++] = tween;
			start( tween );
			return length;
		}
		
		static private function remove( tween:Normal ):int {
			loop:for (var i:int=0;i<length;i++) {
				var t:Normal = tweens[i];
				if (t == tween) {
					tweens.splice(i, 1);
					break loop;
				}
			}
			length--;
			return 0;
		}
		
		static private function reset(tween:Normal):void { tween.startTime = getTimer()*.001; }
		static private function stop():void { ticker.removeEventListener(Event.ENTER_FRAME, tick ) };
		static private function start( tween:Normal ):void {
			tween.startTime = getTimer()*.001;
			if (!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true ); 
		}
		
		static private function tick(evt:Event):void {
			if ( length > 0 ) {
				for (var i:int=0;i<length;i++) {
					var t:Normal = tweens[i];
					t.update( getTimer()*.001 );
				}
			}
			else  stop();
		}
	}
}