package railk.as3.tween.process {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import railk.as3.tween.process.utils.*;
	//import railk.as3.tween.process.plugin.sequence.ISequence;
	import railk.as3.tween.process.plugin.IPlugin;

	
	public class Process extends EventDispatcher {
		public static var defaultEase:Function = Process.easeOut;
		protected static var _tweens:Dictionary = new Dictionary();
		protected static var _curTime:uint;
		private static var _tickerOn:Boolean;
		private static var _listening:Boolean;
		private static var _timer:Timer = new Timer(2000);
		private static var _shape:Shape = new Shape();
//		private static var _sequence:ISequence;
		private static var _plugins:IPlugin;
	
		public var duration:Number;
		public var props:Object;
		public var delay:Number;
		public var startTime:int;
		public var initTime:int;
		public var tweenProps:Array;
		public var target:Object;
		
		public var ease:Function;
		public var autoPlay:Boolean = false;
		public var autoHide:Number;
		public var removeTint:Boolean = false;
		public var reverse:Boolean = false;
		public var smartRotation:Boolean = false;
		public var rounded:Boolean = false;
		public var timeScale:Number = 1;
		public var persist:Boolean = false;
		public var onUpdate:Function;
		public var onStart:Function;
		public var onComplete:Function;
		
		protected var _active:Boolean;
		protected var _progressPoints:Array;
		protected var _proxy:TargetProxy;
		protected var _lastProgressPoint:ProgressPoint;
		protected var _hasUpdate:Boolean;
		protected var _hasPlugin:Boolean=false;
		protected var _isDisplayObject:Boolean;
		protected var _propsSet:Boolean;
		protected var specialProps:Object = { glow:null, dropShadow:null, bevel:null, blur:null, sequence:null, volume:null, pan:null, text:null, bezier:null, color:null, colorMatrix:{ colorize:NaN, brightness:NaN, hue:NaN, saturation:NaN, threshold:NaN, greyscale:NaN, contrast:NaN }, text:null, text_color:null };
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Process(target:Object, duration:Number, props:Object, options:Object=null) {
			if (!target) return;
			this.target = target;
			this.props = props;
			this.duration = duration ? duration : 0.001;
			this.delay = options.delay ? options.delay : 0;
			this.tweenProps = [];
			_active = (duration == 0 && this.delay == 0);
			_isDisplayObject = (target is DisplayObject);
			_progressPoints = [];
			_propsSet = false;
			_tweens[target] = new Dictionary(true);
			_tweens[target][this] = this;
			getTicker();
			setOptions(options);
			if (!_listening && !_active) {
				_timer.addEventListener("timer", killGarbage);
            	_timer.start();
				_listening = true;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  OPTIONS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setOptions( options:Object):void {
			if (!options) return;
			for (var n:String in options) {
				if ( n == 'onUpdate') _hasUpdate = true
				if ( n == 'autoHide') {  
					if (!isNaN(Number(options[n]))) {
						options[n] = Number(options[n]);
						this.props.visible = (this.props.alpha > 0);
					}
				}
				this[n] = options[n]; 
			}
			if ((this.reverse == true && this.autoPlay != true) || _active) setProps();
		}
		
		public static function enablePlugin( pluginManager:IPlugin ):void {
			_plugins = pluginManager;
		}
		
		//public static function set sequence( s:ISequence ):void { _sequence = s; }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   PROPERTIES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setProps(hrp:Boolean = false, reservedProps:String = ""):void {
			var props:Object = this.props;
			if (_active) update(this.startTime + 1);
			else update(this.startTime);
			
			for (var p:String in props) {
				if ( !(specialProps.hasOwnProperty(p) || specialProps.colorMatrix.hasOwnProperty(p))  )
				{
					if (props[p] is Number) {
						if ( smartRotation && ( p == 'rotation' || p == 'rotation2') ) props[p] = rotation( p );
						if ( rounded ) props[p] = int(props[p]);
						this.tweenProps[this.tweenProps.length] = { o:this.target, p:p, s:this.target[p], c:props[p] - this.target[p], name:p };
						
					}
					else this.tweenProps[this.tweenProps.length] = { o:this.target, p:p, s:this.target[p], c:Number(props[p]), name:p };
				} else{	
					if ( specialProps.colorMatrix.hasOwnProperty(p) ) specialProps.colorMatrix[p] = props[p];
					if (specialProps.hasOwnProperty(p)) specialProps[p] = props[p];
					_hasPlugin = true;
				}	
			}
			if (_hasPlugin) {
				_plugins.setTarget( this.target );
				this.tweenProps = _plugins.init(this.tweenProps, specialProps,(props.alpha) ? props.alpha : undefined,  reverse);
			}
				
			if (this.reverse) {
				var tp:Object;
				for (var i:int = this.tweenProps.length - 1; i > -1; i--) {
					tp = this.tweenProps[i];
					tp.s += tp.c;
					tp.c *= -1;
				}
			}
			if (props.visible == true && _isDisplayObject) this.target.visible = true;
			if (this.props.onUpdate != null) _hasUpdate = true;
			_propsSet = true;
		}
		
		public function setProp(name:String, value:*):void {
			for ( var i:int = 0; i < this.tweenProps.length; i++ )
			{
				if (this.tweenProps[i].name == name ) this.tweenProps[i].c = value;
				else this.tweenProps[this.tweenProps.length] = { o:this.target, p:name, s:this.target[name], c:value, name:name }
			}
			this.props[name] = value
		}
		
		public function getProp(name:String):Number { return this.props[name]; }
		
		public function deleteProp(name:String):Boolean { return delete this.props[name]; }
		
		public static function to(target:Object, duration:Number, props:Object, options:Object=null):Process { return new Process(target, duration, props, options); }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  TICKER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getTicker():void {
			if (!_tickerOn) {
				_curTime = getTimer();
				_shape.addEventListener(Event.ENTER_FRAME, tick);
				_tickerOn = true;
			}
			this.initTime = _curTime;
			this.startTime = this.initTime + (this.delay * 1000);
		}
		
		public function update(t:uint):void {
			var time:Number = (t - this.startTime) / 1000, factor:Number, prop:Object, i:int;
			if (time >= this.duration) {
				time = this.duration;
				factor = 1;
			}
			else {
				var f:Function = (ease == null) ? defaultEase : ease;
				factor = f(time, 0, 1, this.duration);
			}
			for (i = this.tweenProps.length - 1; i > -1; i--) {
				prop = this.tweenProps[i];
				prop.o[prop.p] = prop.s + (factor * prop.c);
			}
			if( _hasPlugin) _plugins.update(factor);
			checkProgressPoint(t);
			if (_hasUpdate) this.props.onUpdate.apply(null, this.props.onUpdateParams);
			if (time == this.duration) complete(true);
		}
		
		public static function tick(e:Event = null):void {
			var t:uint = _curTime = getTimer();
			if (_listening) {
				var a:Dictionary = _tweens, p:Object, tw:Object;
				for each (p in a) {
					for (tw in p) {
						if (p[tw] != undefined && p[tw].active) {
							p[tw].update(t);
						}
					}
				}
			}
		}
		
		public function complete(skipRender:Boolean = false):void {
			if (!skipRender) {
				if (!_propsSet) setProps();
				this.startTime = _curTime - (this.duration * 1000) / this.timeScale;
				update(_curTime);
				return;
			}
			if (this.props.visible != undefined && _isDisplayObject) {
				if (!isNaN(this.autoHide) && this.target.alpha == 0) this.target.visible = false;
				else if (this.reverse != true) this.target.visible = this.props.visible;
			}
			if (this.persist != true) removeTween(this);
			if (this.onComplete != null) this.onComplete.apply(null, this.props.onCompleteParams);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		UTILS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
			}
		}
		
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return -c * (t /= d) * (t - 2) + b; }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   SMART ROTATION	
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		protected function rotation( prop:String ):Number {
			var tr:Number = props[prop] %360;
			var r:Number = props[prop] = target[prop] % 360;
			var abs:Number = tr-r;
			if (abs < 0)  abs = -abs;
			tr += (abs < 180) ? 0 : (tr>r) ? -360 : 360;
			return tr;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   PROGRESS POINT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addProgressPoint(position:Number,data:*):void {
			removeProgressPoint(data);
			_progressPoints.push(new ProgressPoint(position, data));
			_progressPoints.sortOn("position",Array.NUMERIC);
		}
		
		public function removeProgressPoint(data:*):void {
			for (var i:int=_progressPoints.length-1; i>=0; i--) {
				if (_progressPoints[i].data == data) {
					_progressPoints.splice(i,1);
					break;
				}
			}
		}	
			
		protected function checkProgressPoint(t:Number):void {
			var obj:ProgressPoint = null;
			for (var i:uint=0; i<_progressPoints.length; i++) {
				if (_progressPoints[i].position > t) break;
				obj = _progressPoints[i] as ProgressPoint;
			}
			if (obj != null && obj != _lastProgressPoint) {
				_lastProgressPoint = obj;
				dispatchEvent(new ProcessEvent(ProcessEvent.ON_PROGRESS_POINT,{info:_lastProgressPoint.position, data:_lastProgressPoint.data}));
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get proxy():Object {
			if (_proxy == null) _proxy = new TargetProxy(this);
			return _proxy;
		}
		
		public function get active():Boolean {
			if (_active) return true;
			else if (_curTime >= this.startTime) {
				_active = true;
				if (!_propsSet) setProps();
				else if (this.props.visible != undefined && _isDisplayObject) this.target.visible = true;
				if (this.props.onStart != null) this.props.onStart.apply(null, this.props.onStartParams);
				if (this.duration == 0.001) this.startTime -= 1;
				return true;
			} 
			else return false;
		}
		
		//static public function get sequence():ISequence { return _sequence; }
	}
}