package railk.as3.tween.process.plugin {
	import flash.filters.*;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import railk.as3.tween.process.plugin.color.Tint;
	import railk.as3.tween.process.plugin.filters.Filters;
	import railk.as3.tween.process.plugin.color.*;
	import railk.as3.tween.process.plugin.IPlugin;
	import railk.as3.tween.process.plugin.sound.Sound;
	import railk.as3.tween.process.plugin.text.Text;
	import railk.as3.utils.ObjectDumper;
	
	public class PluginManager implements IPlugin {
		private static var _idMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var _clrsa:Array =[];
		protected var _matrix:Array;
		protected var _endMatrix:Array;
		protected var _cmf:ColorMatrixFilter;
		protected var _hf:Boolean = false;
		protected var _filters:Array=[];
		protected var _plugins:Array=[];
		protected var _target:Object;
		protected var _hasPlugin:Boolean = false;
		protected var _hasFilter:Boolean = false;
		protected var _tweens:Array;
		protected var _f:Filters
		
		public function PluginManager():void {}
		public function setTarget( target:Object ):void { _target = target; }
		public function init(tweens:Array,prop:Object,alpha:Number,reverse:Boolean):Array {
			_matrix = _idMatrix.slice();
			_tweens = tweens;
			
			var i:int, fv:Object;
			_f = new Filters( _target, _tweens, _clrsa );
			if (prop.blur != null) {
				_f.add("blur", prop.blur,  ["blurX", "blurY", "quality"]);
			}
			if (prop.glow != null) {
				_f.add("glow", prop.glow,  ["alpha", "blurX", "blurY", "color", "quality", "strength", "inner", "knockout"]);
			}
			if (prop.colorMatrix != null) {
				fv = prop.colorMatrix;
				var cmf:Object = _f.add("colorMatrix", fv, [] );
				_cmf = cmf.filter;
				_matrix = ColorMatrixFilter(_cmf).matrix;
				if (fv.matrix != null && fv.matrix is Array) {
					_endMatrix = fv.matrix;
				} else {
					if (fv.relative == true) {
						_endMatrix = _matrix.slice();
					} else {
						_endMatrix = _idMatrix.slice();
					}
					_endMatrix = (new Brightness()).apply(_endMatrix, fv.brightness);
					_endMatrix = (new Contrast()).apply(_endMatrix, fv.contrast);
					_endMatrix = (new Hue()).apply(_endMatrix, fv.hue);
					_endMatrix = (new Saturation()).apply(_endMatrix, fv.saturation);
					_endMatrix = (new Threshold()).apply(_endMatrix, fv.threshold);
					if (!isNaN(fv.colorize)) {
						_endMatrix =(new Colorize()).apply(_endMatrix, fv.colorize, 1);
					}
				}
				for (i = 0; i < _endMatrix.length; i++) {
					if (_matrix[i] != _endMatrix[i] && _matrix[i] != undefined) {
						_tweens[tweens.length] = {o:_matrix, p:i.toString(), s:_matrix[i], c:_endMatrix[i] - _matrix[i] };
					}
				}
			}
			if (prop.dropShadow != null) {
				_f.add("dropShadow", prop.dropShadow, ["alpha", "angle", "blurX", "blurY", "color", "distance", "quality", "strength", "inner", "knockout", "hideObject"]);
			}
			if (prop.bevel != null) {
				_f.add("bevel", prop.bevel, ["angle", "blurX", "blurY", "distance", "highlightAlpha", "highlightColor", "quality", "shadowAlpha", "shadowColor", "strength"]);
			}
			if (prop.color != null) {
				var clr:ColorTransform = _target.transform.colorTransform;
				var endClr:ColorTransform = new ColorTransform();
				if (!isNaN(alpha)) {
					endClr.alphaMultiplier = alpha;
				} else {
					endClr.alphaMultiplier = _target.alpha;
				}
				if ((prop.color != null && prop.color != "") || prop.color == 0) {
					endClr.color = prop.color;
				}
				addPlugin("tint", (new Tint()).apply, {progress:0}, {progress:1}, {target:_target, color:clr, endColor:endClr});
			}
			if (prop.volume != null) {
				trace(prop.volume);
				addPlugin("volume", (new Sound()).volume, {progress:0}, {volume:prop.volume}, {target:_target});
			}
			if (prop.pan != null) {
				addPlugin("pan", (new Sound()).pan, {progress:0}, {progress:1}, {target:_target});
			}
			if (prop.text != null) {
				addPlugin("text", (new Text()).changeText, {progress:0}, {progress:1}, {target:_target, text:prop.text});
			}
			if (prop.text_color != null) {
				addPlugin("text_color", (new Text()).changeColor, {progress:0}, {progress:1}, {target:_target, color:prop.text_color});
			}
			if (reverse) {
				var tp:Object;
				for (i = _clrsa.length - 1; i > -1; i--) {
					tp = _clrsa[i];
					tp.sr += tp.cr;
					tp.cr *= -1;
					tp.sg += tp.cg;
					tp.cg *= -1;
					tp.sb += tp.cb;
					tp.cb *= -1;
					tp.f[tp.p] = (tp.sr << 16 | tp.sg << 8 | tp.sb);
				}
			}
			return _tweens;
		}
		
		protected function addPlugin(name:String, proxy:Function, target:Object, props:Object, info:Object = null):void{
			var sub:Object = {name:name, proxy:proxy, target:target, info:info};
			_plugins[_plugins.length] = sub;
			for (var p:String in props) {
				if (typeof(props[p]) == "number") {
					_tweens[_tweens.length] = {o:target, p:p, s:target[p], c:props[p] - target[p], sub:sub, name:name};
				} else {
					_tweens[_tweens.length] = {o:target, p:p, s:target[p], c:Number(props[p]), sub:sub, name:name};
				}
			}
			_hasPlugin = true;
		}
		
		public function update(factor:Number):void {
			if (_f.hasFilter) {
				var r:Number, g:Number, b:Number, j:int, tp:Object, i:int;
				for (i = _clrsa.length - 1; i > -1; i--) {
					tp = _clrsa[i];
					r = tp.sr + (factor * tp.cr);
					g = tp.sg + (factor * tp.cg);
					b = tp.sb + (factor * tp.cb);
					tp.f[tp.p] = (r << 16 | g << 8 | b);
				}
				if (_cmf != null) {
					ColorMatrixFilter(_cmf).matrix = _matrix;
				}
				var f:Array = _target.filters;
				for (i = 0; i < _f.filters.length; i++) {
					for (j = f.length - 1; j > -1; j--) {
						if (f[j] is _f.filters[i].type) {
							f.splice(j, 1, _f.filters[i].filter);
							break;
						}
					}
				}	
				_target.filters = f;
			}	
			if (_hasPlugin) {
				for (i = _plugins.length - 1; i > -1; i--) {
					_plugins[i].proxy(_plugins[i]);
				}
			}
		}		
	}	
}