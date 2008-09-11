package railk.as3.tween.process {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import railk.as3.tween.process.utils.*;
	import railk.as3.tween.process.plugin.sequence.ISequence;
	import railk.as3.tween.process.plugin.IPlugin;

	
	public class Process extends EventDispatcher {
		public static var defaultEase:Function = Process.easeOut;
		protected static var _tweens:Dictionary = new Dictionary();
		protected static var _curTime:uint;
		private static var _timer:Timer = new Timer(2000);
		private static var _tickerOn:Boolean;
		private static var _listening:Boolean;
		private static var _shape:Shape = new Shape();
		private static var _sequence:ISequence;
		private static var _pluginClass:Class;
		private static var _pluginMode:String;
	
		public var duration:Number;
		public var props:Object;
		public var delay:Number;
		public var startTime:int;
		public var initTime:int;
		public var target:Object;
		public var _plugins:IPlugin;
		
		public var ease:Function;
		public var autoPlay:Boolean = false;
		public var autoHide:Number;
		public var reverse:Boolean = false;
		public var smartRotation:Boolean = false;
		public var rounded:Boolean = false;
		public var timeScale:Number = 1;
		public var onUpdate:Function;
		public var onComplete:Function;
		
		protected var _active:Boolean;
		protected var _items:Array=[];
		protected var _PP:Array;
		protected var _lastPP:ProgressPoint;
		protected var _proxy:TargetProxy;
		protected var _hasUp:Boolean;
		protected var _hpl:Boolean=false;
		protected var _isDO:Boolean;
		protected var _propsSet:Boolean;
		protected var cmProps:Object = { colorize:NaN, brightness:NaN, hue:NaN, saturation:NaN, threshold:NaN, greyscale:NaN, contrast:NaN };
		protected var sProps:Object = { glow:null, dropShadow:null, bevel:null, blur:null, sequence:null, volume:null, pan:null, text:null, bezier:null, color:null, colorMatrix:null, text:null, text_color:null };
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Process(target:Object, duration:Number, props:Object, options:Object=null) {
			if (!target) return;
			if (!options) options = {};
			this.target = target;
			_tweens[target] = new Dictionary(true);
			_tweens[target][this] = this;
			this.props = props;
			this.duration = duration ? duration : 0.001;
			this.delay = options.delay ? options.delay : 0;
			_active = (duration == 0 && delay == 0);
			_isDO = (target is DisplayObject);
			_PP = [];
			_propsSet = false;
			if(_pluginClass) _plugins = new _pluginClass();
			getTicker();
			setOptions(options);
			if (!_listening && !_active) {
				_timer.addEventListener("timer", killGarbage);
            	_timer.start();
				_listening = true;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  OPTIONS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function enablePlugin(pm:Class):void { _pluginClass = pm; }
		public static function set sequence( s:ISequence ):void { _sequence = s; }
		
		public function setOptions( options:Object ):void {
			if (!options) return;
			for (var n:String in options) {
				if ( n == 'onUpdate') _hasUp = true;
				if ( n == 'autoHide') {  
					if (!isNaN(Number(options[n]))) {
						options[n] = Number(options[n]);
						props.visible = (props.alpha > 0);
					}
				}
				this[n] = options[n]; 
			}
			if ((reverse && !autoPlay ) || _active) setProps();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   PROPERTIES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setProps():void {
			if (_active) update(startTime + 1);
			else update(startTime);
			
			for (var p:String in props) {
				if ( !(sProps.hasOwnProperty(p) || cmProps.hasOwnProperty(p)) ) {
					if (props[p] is Number) {
						if ( smartRotation && ( p == 'rotation' || p == 'rotation2') ) props[p] = rotation( p );
						if ( rounded ) props[p] = int(props[p]);
						_items[_items.length] = { target:target, prop:p, init:target[p], change:props[p] - target[p]};
					}
					else _items[_items.length] = { target:target, prop:p, init:target[p], change:Number(props[p])};
				} else {	
					if ( cmProps.hasOwnProperty(p) ) {  cmProps[p] = props[p]; sProps.colorMatrix = cmProps; }
					if ( sProps.hasOwnProperty(p) ) sProps[p] = props[p];
					_hpl = true;
				}	
			}
							
			if (reverse) {
				var tp:Object;
				for (var i:int = _items.length - 1; i > -1; i--) {
					tp = _items[i];
					tp.s += tp.c;
					tp.c *= -1;
				}
			}
			if (_hpl) {
				_plugins.setTarget( target );
				_plugins.init(_items, sProps, (props.alpha) ? props.alpha : undefined,  reverse);
			}
			if (props.visible && _isDO) target.visible = true;
			if (props.onUpdate != null) _hasUp = true;
			_propsSet = true;
		}
		
		public function setProp(n:String, v:*):void {
			for ( var i:int = 0; i < _items.length; i++ ) {
				if (_items[i].p == n ) _items[i].c = v;
				else _items[_items.length] = { target:target, prop:n, init:target[n], change:v };
			}
			props[n] = v;
		}
		public function getProp(n:String):Number { return props[n]; }
		public function deleteProp(n:String):Boolean { return delete props[n]; }
		
		public static function to(target:Object, duration:Number, props:Object, options:Object = null):Process {
			return new Process(target, duration, props, options); 
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   UPDATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getTicker():void {
			if (!_tickerOn) {
				_curTime = getTimer();
				_shape.addEventListener(Event.ENTER_FRAME, tick);
				_tickerOn = true;
			}
			initTime = _curTime;
			startTime = initTime + (delay * 1000);
		}
		
		public function update(t:uint):void {
			var time:Number = (t - startTime) / 1000, factor:Number, item:Object, i:int;
			if (time >= duration) {
				time = duration;
				factor = 1;
			}
			else {
				var f:Function = (ease == null) ? defaultEase : ease;
				factor = f(time, 0, 1, duration);
			}
			for (i = _items.length - 1; i > -1; i--) {
				item = _items[i];
				item.target[item.prop] = item.init + (factor * item.change);
			}
			if( _hpl) _plugins.update(factor);
			checkProgressPoint(t);
			if (_hasUp) props.onUpdate.apply(null);
			if (time == duration) complete();
		}
		
		public static function tick(e:Event = null):void {
			var t:uint = _curTime = getTimer();
			if (_listening) {
				var a:Dictionary = _tweens, p:Object, tween:Object;
				for each (p in a) {
					for (tween in p) {
						if (p[tween] != undefined && p[tween].active) p[tween].update(t); 
					} 
				}
			}
		}
		
		public function complete():void {
			if (props.visible != undefined && _isDO) {
				if (!isNaN(autoHide) && target.alpha == 0) target.visible = false;
				else if (reverse != true) target.visible = props.visible;
			}
			removeTween(this);
			if (onComplete != null) onComplete.apply(null);
		}
		
		public static function removeTween(t:Process = null):void {
			if (t != null && _tweens[t.target] != undefined) {
				_tweens[t.target][t] = null;
				delete _tweens[t.target][t];
			}
		}
		
		public static function killGarbage(e:TimerEvent):void {
			var tg_cnt:uint = 0, found:Boolean, p:Object, twp:Object, tw:Object;
			for (p in _tweens) {
				found = false;
				for (twp in _tweens[p]) {
					found = true;
					break;
				}
				if (!found) delete _tweens[p];
				else tg_cnt++;
			}
			if (tg_cnt == 0) {
				_timer.removeEventListener("timer", killGarbage);
				_timer.stop();
				_listening = false;
				_tickerOn = false;
				_shape.removeEventListener( Event.ENTER_FRAME, tick);
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  UTILITY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return -c * (t /= d) * (t - 2) + b; }
		
		protected function rotation( prop:String ):Number {
			var tr:Number = props[prop] %360;
			var r:Number = props[prop] = target[prop] % 360;
			var abs:Number = tr-r;
			if (abs < 0)  abs = -abs;
			tr += (abs < 180) ? 0 : (tr>r) ? -360 : 360;
			return tr;
		}
		
		public function addProgressPoint(pos:Number,data:*):void {
			removeProgressPoint(data);
			_PP.push(new ProgressPoint(pos, data));
			_PP.sortOn("pos",Array.NUMERIC);
		}
		
		public function removeProgressPoint(data:*):void {
			for (var i:int=_PP.length-1; i>=0; i--) { if (_PP[i].data == data) { _PP.splice(i,1); break; } }
		}	
			
		protected function checkProgressPoint(t:Number):void {
			var obj:ProgressPoint = null;
			for (var i:uint=0; i<_PP.length; i++) {
				if (_PP[i].pos > t) break;
				obj = _PP[i] as ProgressPoint;
			}
			if (obj != null && obj != _lastPP) {
				_lastPP = obj;
				dispatchEvent(new ProcessEvent(ProcessEvent.ON_PROGRESS_POINT,{info:_lastPP.pos, data:_lastPP.data}));
			}
		}
		
		public function get proxy():Object {
			if (_proxy == null) _proxy = new TargetProxy(this);
			return _proxy;
		}
		
		public function get active():Boolean {
			if (_active) return true;
			else if (_curTime >= startTime) {
				_active = true;
				if (!_propsSet) setProps();
				else if (props.visible != undefined && _isDO) target.visible = true;
				if (duration == 0.001) startTime -= 1;
				return true;
			} 
			else return false;
		}
		
		static public function get sequence():ISequence { return _sequence; }
	}
}