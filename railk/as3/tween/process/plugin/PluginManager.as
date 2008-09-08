package railk.as3.tween.process.plugin {
	import flash.filters.*;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import railk.as3.tween.process.plugin.IPlugin;
	
	public class PluginManager implements IPlugin {
		private static var _idMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private static var _lumR:Number = 0.212671;
		private static var _lumG:Number = 0.715160;
		private static var _lumB:Number = 0.072169;
		private static var _clrsa:Array =[];
		protected var _matrix:Array;
		protected var _endMatrix:Array;
		protected var _cmf:ColorMatrixFilter;
		protected var _hf:Boolean = false;
		protected var _filters:Array = [];
		protected var _plugins:Array = [];
		protected var _target:Object;
		protected var _hasPlugin:Boolean = false;
		protected var _hasFilter:Boolean = false;
		
		public function PluginManager():void {}
		public function setTarget( target:Object ):void { _target = target; }
		public function init(tweens:Array,prop:Object,alpha:Number,reverse:Boolean):Array {
			_filters = [];
			_matrix = _idMatrix.slice();
			
			var i:int, fv:Object;
			if (prop.blur != null) {
				fv = prop.blur
				tweens = tweens.concat( addFilter("blurFilter", fv, BlurFilter, ["blurX", "blurY", "quality"], new BlurFilter(0, 0, fv.quality || 2)).content );
			}
			if (prop.glow != null) {
				fv = prop.glow;
				tweens = tweens.concat( addFilter("glowFilter", fv, GlowFilter, ["alpha", "blurX", "blurY", "color", "quality", "strength", "inner", "knockout"], new GlowFilter(0xFFFFFF, 0, 0, 0, fv.strength || 1, fv.quality || 2, fv.inner, fv.knockout)).content );
			}
			if (prop.colorMatrix != null) {
				fv = prop.colorMatrix;
				var cmf:Object = addFilter("colorMatrixFilter", fv, ColorMatrixFilter, [], new ColorMatrixFilter(_matrix));
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
					_endMatrix = setBrightness(_endMatrix, fv.brightness);
					_endMatrix = setContrast(_endMatrix, fv.contrast);
					_endMatrix = setHue(_endMatrix, fv.hue);
					_endMatrix = setSaturation(_endMatrix, fv.saturation);
					_endMatrix = setThreshold(_endMatrix, fv.threshold);
					if (!isNaN(fv.colorize)) {
						_endMatrix = colorize(_endMatrix, fv.colorize, 1);
					}
				}
				for (i = 0; i < _endMatrix.length; i++) {
					if (_matrix[i] != _endMatrix[i] && _matrix[i] != undefined) {
						tweens[tweens.length] = {o:_matrix, p:i.toString(), s:_matrix[i], c:_endMatrix[i] - _matrix[i], name:"colorMatrixFilter"};
					}
				}
			}
			if (prop.dropShadow != null) {
				fv = prop.dropShadow;
				tweens = tweens.concat( addFilter("dropShadowFilter", fv, DropShadowFilter, ["alpha", "angle", "blurX", "blurY", "color", "distance", "quality", "strength", "inner", "knockout", "hideObject"], new DropShadowFilter(0, 45, 0x000000, 0, 0, 0, 1, fv.quality || 2, fv.inner, fv.knockout, fv.hideObject)).content );
			}
			if (prop.bevel != null) {
				fv = prop.bevel;
				tweens = tweens.concat( addFilter("bevelFilter", fv, BevelFilter, ["angle", "blurX", "blurY", "distance", "highlightAlpha", "highlightColor", "quality", "shadowAlpha", "shadowColor", "strength"], new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, fv.quality || 2)).content );
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
				tweens = tweens.concat( addPlugin("tint", tint, {progress:0}, {progress:1}, {target:_target, color:clr, endColor:endClr}));
			}
			if (prop.volume != null) {
				
			}
			if (prop.pan != null) {
				
			}
			if (prop.text != null) {
				
			}
			if (prop.text_color != null) {
				
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
			return tweens;
		}
		
		private function addFilter(name:String, fv:Object, filterType:Class, props:Array, defaultFilter:BitmapFilter):Object {
			var a:Array;
			var f:Object = {type:filterType, name:name}, fltrs:Array = _target.filters, i:int, prop:String, valChange:Number, begin:Object, end:Object;
			for (i = 0; i < fltrs.length; i++) {
				if (fltrs[i] is filterType) {
					f.filter = fltrs[i];
					break;
				}
			}
			if (f.filter == undefined) {
				f.filter = defaultFilter;
				fltrs[fltrs.length] = f.filter;
				_target.filters = fltrs;
			}
			for (i = 0; i < props.length; i++) {
				prop = props[i];
				if (fv[prop] != undefined) {
					if (prop == "color" || prop == "highlightColor" || prop == "shadowColor") {
						begin = HEXtoRGB(f.filter[prop]);
						end = HEXtoRGB(fv[prop]);
						_clrsa[_clrsa.length] = {f:f.filter, p:prop, sr:begin.rb, cr:end.rb - begin.rb, sg:begin.gb, cg:end.gb - begin.gb, sb:begin.bb, cb:end.bb - begin.bb};
					} else if (prop == "quality" || prop == "inner" || prop == "knockout" || prop == "hideObject") {
						f.filter[prop] = fv[prop];
					} else {
						if (typeof(fv[prop]) == "number") {
							valChange = fv[prop] - f.filter[prop];
						} else {
							valChange = Number(fv[prop]);
						}
						a[a.length] = {o:f.filter, p:prop, s:f.filter[prop], c:valChange, name:name};
					}
				}
			}
			_filters[_filters.length] = f;
			f.content = a;
			_hasFilter = true;
			return f;
		}
		
		protected function addPlugin(name:String, proxy:Function, target:Object, props:Object, info:Object = null):Array{
			var a:Array= new Array();
			var sub:Object = {name:name, proxy:proxy, target:target, info:info};
			_plugins[_plugins.length] = sub;
			for (var p:String in props) {
				if (typeof(props[p]) == "number") {
					a[a.length] = {o:target, p:p, s:target[p], c:props[p] - target[p], sub:sub, name:name};
				} else {
					a[a.length] = {o:target, p:p, s:target[p], c:Number(props[p]), sub:sub, name:name};
				}
			}
			_hasPlugin = true;
			return a;
		}
		
		public function update(factor:Number):void {
			if (_hasFilter) {
				var r:Number, g:Number, b:Number, j:int, tp:Object, i:int;
				for (i = _clrsa.length - 1; i > -1; i--) {
					tp = _clrsa[i];
					r = tp.sr + (factor * tp.cr);
					g = tp.sg + (factor * tp.cg);
					b = tp.sb + (factor * tp.cb);
					tp.f[tp.p] = (r << 16 | g << 8 | b); //Translates RGB to HEX
				}
				if (_cmf != null) {
					ColorMatrixFilter(_cmf).matrix = _matrix;
				}
				var f:Array = _target.filters;
				for (i = 0; i < _filters.length; i++) {
					for (j = f.length - 1; j > -1; j--) {
						if (f[j] is _filters[i].type) {
							f.splice(j, 1, _filters[i].filter);
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

		public static function HEXtoRGB(n:Number):Object {
			return {rb:n >> 16, gb:(n >> 8) & 0xff, bb:n & 0xff};
		}
		
//---- COLOR MATRIX FILTER FUNCTIONS -----------------------------------------------------------------------------------------------------------------------

		public static function tint(o:Object):void {
			var n:Number = o.target.progress, r:Number = 1 - n, sc:Object = o.info.color, ec:Object = o.info.endColor;
			o.info.target.transform.colorTransform = new ColorTransform(sc.redMultiplier * r + ec.redMultiplier * n,
																		  sc.greenMultiplier * r + ec.greenMultiplier * n,
																		  sc.blueMultiplier * r + ec.blueMultiplier * n,
																		  sc.alphaMultiplier * r + ec.alphaMultiplier * n,
																		  sc.redOffset * r + ec.redOffset * n,
																		  sc.greenOffset * r + ec.greenOffset * n,
																		  sc.blueOffset * r + ec.blueOffset * n,
																		  sc.alphaOffset * r + ec.alphaOffset * n);
		}
		
		public static function colorize(m:Array, color:Number, amount:Number = 1):Array {
			if (isNaN(color)) {
				return m;
			} else if (isNaN(amount)) {
				amount = 1;
			}
			var r:Number = ((color >> 16) & 0xff) / 255;
			var g:Number = ((color >> 8)  & 0xff) / 255;
			var b:Number = (color         & 0xff) / 255;
			var inv:Number = 1 - amount;
			var temp:Array =  [inv + amount * r * _lumR, amount * r * _lumG,       amount * r * _lumB,       0, 0,
							  amount * g * _lumR,        inv + amount * g * _lumG, amount * g * _lumB,       0, 0,
							  amount * b * _lumR,        amount * b * _lumG,       inv + amount * b * _lumB, 0, 0,
							  0, 				          0, 					     0, 					    1, 0];		
			return applyMatrix(temp, m);
		}
		
		public static function setThreshold(m:Array, n:Number):Array {
			if (isNaN(n)) {
				return m;
			}
			var temp:Array = [_lumR * 256, _lumG * 256, _lumB * 256, 0,  -256 * n, 
						_lumR * 256, _lumG * 256, _lumB * 256, 0,  -256 * n, 
						_lumR * 256, _lumG * 256, _lumB * 256, 0,  -256 * n, 
						0,           0,           0,           1,  0]; 
			return applyMatrix(temp, m);
		}
		
		public static function setHue(m:Array, n:Number):Array {
			if (isNaN(n)) {
				return m;
				trace( 'nohue' );
			}
			n *= Math.PI / 180;
			var c:Number = Math.cos(n);
			var s:Number = Math.sin(n);
			var temp:Array = [(_lumR + (c * (1 - _lumR))) + (s * (-_lumR)), (_lumG + (c * (-_lumG))) + (s * (-_lumG)), (_lumB + (c * (-_lumB))) + (s * (1 - _lumB)), 0, 0, (_lumR + (c * (-_lumR))) + (s * 0.143), (_lumG + (c * (1 - _lumG))) + (s * 0.14), (_lumB + (c * (-_lumB))) + (s * -0.283), 0, 0, (_lumR + (c * (-_lumR))) + (s * (-(1 - _lumR))), (_lumG + (c * (-_lumG))) + (s * _lumG), (_lumB + (c * (1 - _lumB))) + (s * _lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			return applyMatrix(temp, m);
		}
		
		public static function setBrightness(m:Array, n:Number):Array {
			if (isNaN(n)) {
				return m;
			}
			n = (n * 100) - 100;
			return applyMatrix([1,0,0,0,n,
								0,1,0,0,n,
								0,0,1,0,n,
								0,0,0,1,0,
								0,0,0,0,1], m);
		}
		
		public static function setSaturation(m:Array, n:Number):Array {
			if (isNaN(n)) {
				return m;
			}
			var inv:Number = 1 - n;
			var r:Number = inv * _lumR;
			var g:Number = inv * _lumG;
			var b:Number = inv * _lumB;
			var temp:Array = [r + n, g     , b     , 0, 0,
							  r     , g + n, b     , 0, 0,
							  r     , g     , b + n, 0, 0,
							  0     , 0     , 0     , 1, 0];
			return applyMatrix(temp, m);
		}
		
		public static function setContrast(m:Array, n:Number):Array {
			if (isNaN(n)) {
				return m;
			}
			n += 0.01;
			var temp:Array =  [n,0,0,0,128 * (1 - n),
							   0,n,0,0,128 * (1 - n),
							   0,0,n,0,128 * (1 - n),
							   0,0,0,1,0];
			return applyMatrix(temp, m);
		}
		
		public static function applyMatrix(m:Array, m2:Array):Array {
			if (!(m is Array) || !(m2 is Array)) {
				return m2;
			}
			var temp:Array = [];
			var i:int = 0;
			var z:int = 0;
			var y:int, x:int;
			for (y = 0; y < 4; y++) {
				for (x = 0; x < 5; x++) {
					if (x == 4) {
						z = m[i + 4];
					} else {
						z = 0;
					}
					temp[i + x] = m[i]   * m2[x]      + 
								  m[i+1] * m2[x + 5]  + 
								  m[i+2] * m2[x + 10] + 
								  m[i+3] * m2[x + 15] +
								  z;
				}
				i += 5;
			}
			return temp;
		}
	}	
}