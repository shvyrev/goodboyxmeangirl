package railk.as3.tween.process {
	
	import flash.display.DisplayObject;
	import flash.filters.*;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.media.SoundTransform;
	import railk.as3.tween.process.plugin.IPlugin;
	
	public class ProcessPlugins implements IPlugin {
		private static var _idMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private static var lumR:Number = 0.212671;
		private static var lumG:Number = 0.715160;
		private static var lumB:Number = 0.072169;
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
		
		public function ProcessPlugins():void {}
		public function setTarget( target:Object ):void { _target = target; }
		public function init(tweens:Array,prop:Object,alpha:Number,reverse:Boolean):Array {
			_matrix = _idMatrix.slice();
			_tweens = tweens;
			var i:int, fv:Object;
			if (prop.blur != null) addFilter("blur", prop.blur,  ["blurX", "blurY", "quality"]);
			if (prop.glow != null) addFilter("glow", prop.glow,  ["alpha", "blurX", "blurY", "color", "quality", "strength", "inner", "knockout"]);
			if (prop.dropShadow != null) addFilter("dropShadow", prop.dropShadow, ["alpha", "angle", "blurX", "blurY", "color", "distance", "quality", "strength", "inner", "knockout", "hideObject"]);
			if (prop.bevel != null) addFilter("bevel", prop.bevel, ["angle", "blurX", "blurY", "distance", "highlightAlpha", "highlightColor", "quality", "shadowAlpha", "shadowColor", "strength"]);
			if (prop.colorMatrix != null) {
				fv = prop.colorMatrix;
				var cmf:Object = addFilter("colorMatrix", fv, [] );
				_cmf = cmf.filter;
				_matrix = ColorMatrixFilter(_cmf).matrix;
				if (fv.matrix != null && fv.matrix is Array) _endMatrix = fv.matrix;
				else {
					_endMatrix = _idMatrix.slice();
					_endMatrix = brightness(_endMatrix, fv.brightness);
					_endMatrix = contrast(_endMatrix, fv.contrast);
					_endMatrix = hue(_endMatrix, fv.hue);
					_endMatrix = saturation(_endMatrix, fv.saturation);
					_endMatrix = threshold(_endMatrix, fv.threshold);
					if (!isNaN(fv.colorize)) {
						_endMatrix = colorize(_endMatrix, fv.colorize, 1);
					}
				}
				for (i = 0; i < _endMatrix.length; i++) {
					if (_matrix[i] != _endMatrix[i] && _matrix[i] != undefined) _tweens[tweens.length] = {target:_matrix, prop:i.toString(), init:_matrix[i], change:_endMatrix[i] - _matrix[i] };
				}
			}
			
			if (prop.color != null) addPlugin("tint", tint, { progress:0 }, { progress:1 }, { target:_target, alpha:alpha, color:prop.color } );
			if (prop.volume != null) addPlugin("volume", volume, {progress:0}, {progress:1}, {target:_target,volume:prop.volume});
			if (prop.pan != null) addPlugin("pan", pan, {progress:0}, {progress:1}, {target:_target, pan:prop.pan});
			if (prop.text != null) addPlugin("text", changeText, {progress:0}, {progress:1}, {target:_target, text:prop.text});
			if (prop.text_color != null) addPlugin("text_color", changeColor, {progress:0}, {progress:1}, {target:_target, color:prop.text_color});
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
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  	ADD EXTENSION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		protected function addFilter(name:String, fv:Object, props:Array):Object {
			var df:BitmapFilter;
			var ft:Class;
			switch( name ) {
				case 'blur' : df = new BlurFilter(0, 0, fv.quality || 2); ft = BlurFilter; break;
				case 'glow' : df = new GlowFilter(0xFFFFFF, 0, 0, 0, fv.strength || 1, fv.quality || 2, fv.inner, fv.knockout); ft = GlowFilter; break;
				case 'dropShadow' : df = new DropShadowFilter(0, 45, 0x000000, 0, 0, 0, 1, fv.quality || 2, fv.inner, fv.knockout, fv.hideObject); ft = DropShadowFilter; break;
				case 'bevel' : df = new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, fv.quality || 2); ft = BevelFilter; break;
				case 'colorMatrix' : df = new ColorMatrixFilter(_matrix); ft = ColorMatrixFilter; break;
			}
			
			var f:Object = {type:ft, name:name}, fltrs:Array = _target.filters, i:int, prop:String, valChange:Number, begin:Object, end:Object;
			for (i = 0; i < fltrs.length; i++) {
				if (fltrs[i] is ft) {
					f.filter = fltrs[i];
					break;
				}
			}
			if (f.filter == undefined) {
				f.filter = df;
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
					} 
					else if (prop == "quality" || prop == "inner" || prop == "knockout" || prop == "hideObject") f.filter[prop] = fv[prop];
					else {
						if (typeof(fv[prop]) == "number") valChange = fv[prop] - f.filter[prop];
						else valChange = Number(fv[prop]);
						_tweens[_tweens.length] = {target:f.filter, prop:prop, init:f.filter[prop], change:valChange};
					}
				}
			}
			_hasFilter = true;
			_filters[_filters.length] = f;
			return f;
		}
		
		
		protected function addPlugin(name:String, proxy:Function, target:Object, props:Object, info:Object = null):void{
			var sub:Object = {name:name, proxy:proxy, target:target, info:info};
			_plugins[_plugins.length] = sub;
			for (var p:String in props) {
				if (typeof(props[p]) == "number") _tweens[_tweens.length] = {target:target, prop:p, init:target[p], change:props[p] - target[p]};
				else _tweens[_tweens.length] = {target:target, prop:p, init:target[p], change:Number(props[p]), sub:sub};
			}
			_hasPlugin = true;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  		   UPDATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function update(factor:Number):void {
			if (_hasFilter) {
				var r:Number, g:Number, b:Number, j:int, tp:Object, i:int;
				for (i = _clrsa.length - 1; i > -1; i--) {
					tp = _clrsa[i];
					r = tp.sr + (factor * tp.cr);
					g = tp.sg + (factor * tp.cg);
					b = tp.sb + (factor * tp.cb);
					tp.f[tp.p] = (r << 16 | g << 8 | b);
				}
				if (_cmf != null) ColorMatrixFilter(_cmf).matrix = _matrix;
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
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  	TEXT FUNCTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function changeColor( o:Object):void {
			var start:ColorTransform = new ColorTransform();
			start.color = o.info.target.textColor;
			var end:ColorTransform = new ColorTransform();
			end.color = o.info.color;
			var n:Number = o.target.progress, r:Number = 1 - n;
			var result:ColorTransform = new ColorTransform(start.redMultiplier * r + end.redMultiplier * n,
																		  start.greenMultiplier * r + end.greenMultiplier * n,
																		  start.blueMultiplier * r + end.blueMultiplier * n,
																		  start.alphaMultiplier * r + end.alphaMultiplier * n,
																		  start.redOffset * r + end.redOffset * n,
																		  start.greenOffset * r + end.greenOffset * n,
																		  start.blueOffset * r + end.blueOffset * n,
																		  start.alphaOffset * r + end.alphaOffset * n);
			o.info.target.textColor = result.color;
		}
		
		private function changeText( o:Object):void {
			var maxLetters:int = (o.info.text.length > o.info.target.text.length) ? o.info.text.length : o.info.target.text.length ;
			var x:Number = 1 / maxLetters;
			var currentLetters:Array = new Array();
			var nextLetters:Array = new Array();
			for (var i:int = 0; i <  o.info.text.length; i++) { nextLetters.push(  o.info.text.charAt(i) ); }
			for (i = 0; i <  o.info.target.text.length; i++) { currentLetters.push(  o.info.target.text.charAt(i) ); }
			var index:int = int(Number(o.target.progress) / x);
			for (i = 0; i < index ; i++) 
			{
				currentLetters[i] = (nextLetters[i]) ? nextLetters[i] : '';
			}
			var reg:RegExp = new RegExp(',','g');
			o.info.target.text = currentLetters.toString().replace(reg, '');
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   SOUND FUNCTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function volume( o:Object ):void {
			var value:Number = o.info.volume - ( 1 - o.target.progress );
			o.info.target.soundTransform = new SoundTransform(value, o.info.target.soundTransform.pan);
		}
		
		private function pan( o:Object ):void {
			var value:Number = o.info.pan - ( 1 - o.target.progress );
			o.info.target.soundTransform = new SoundTransform(o.info.target.soundTransform.volume,value);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  	TINT FUNCTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function tint( o:Object):void {
			var clr:ColorTransform = o.info.target.transform.colorTransform;
			var endClr:ColorTransform = new ColorTransform();
			if (!isNaN(o.info.alpha)) endClr.alphaMultiplier = o.info.alpha;
			else endClr.alphaMultiplier = o.info.target.alpha;
			if ((o.info.color != null && o.info.color != "") || o.info.color == 0) endClr.color = o.info.color;
			var n:Number = o.target.progress, r:Number = 1 - n, sc:Object = clr, ec:Object = endClr;
			o.info.target.transform.colorTransform = new ColorTransform(sc.redMultiplier * r + ec.redMultiplier * n,
																		  sc.greenMultiplier * r + ec.greenMultiplier * n,
																		  sc.blueMultiplier * r + ec.blueMultiplier * n,
																		  sc.alphaMultiplier * r + ec.alphaMultiplier * n,
																		  sc.redOffset * r + ec.redOffset * n,
																		  sc.greenOffset * r + ec.greenOffset * n,
																		  sc.blueOffset * r + ec.blueOffset * n,
																		  sc.alphaOffset * r + ec.alphaOffset * n);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  COLORS FUNCTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function HEXtoRGB(n:Number):Object { return {rb:n >> 16, gb:(n >> 8) & 0xff, bb:n & 0xff}; }
		
		public function brightness( m:Array,n:Number):Array {
			if (isNaN(n)) return m;
			n = (n * 100) - 100;
			return applyMatrix([1,0,0,0,n,
								0,1,0,0,n,
								0,0,1,0,n,
								0,0,0,1,0,
								0,0,0,0,1], m);
		}
		
		private function colorize( m:Array, color:Number, amount:Number=NaN):Array {
			if (isNaN(color)) return m;
			else if (isNaN(amount)) amount = 1;
			var r:Number = ((color >> 16) & 0xff) / 255;
			var g:Number = ((color >> 8)  & 0xff) / 255;
			var b:Number = (color         & 0xff) / 255;
			var inv:Number = 1 - amount;
			var temp:Array =  [inv + amount * r * lumR, amount * r * lumG,       amount * r * lumB,       0, 0,
							  amount * g * lumR,        inv + amount * g * lumG, amount * g * lumB,       0, 0,
							  amount * b * lumR,        amount * b * lumG,       inv + amount * b * lumB, 0, 0,
							  0, 				          0, 					     0, 					    1, 0];		
			return applyMatrix(temp, m);
		}
		
		private function contrast( m:Array, n:Number):Array {
			if (isNaN(n)) return m;
			n += 0.01;
			var temp:Array =  [n,0,0,0,128 * (1 - n),
							   0,n,0,0,128 * (1 - n),
							   0,0,n,0,128 * (1 - n),
							   0,0,0,1,0];
			return applyMatrix(temp,m);
		}
		
		private function hue( m:Array , n:Number):Array {
			if (isNaN(n)) return m;
			n *= Math.PI / 180;
			var c:Number = Math.cos(n);
			var s:Number = Math.sin(n);
			var temp:Array = [(lumR + (c * (1 - lumR))) + (s * (-lumR)), (lumG + (c * (-lumG))) + (s * (-lumG)), (lumB + (c * (-lumB))) + (s * (1 - lumB)), 0, 0, (lumR + (c * (-lumR))) + (s * 0.143), (lumG + (c * (1 - lumG))) + (s * 0.14), (lumB + (c * (-lumB))) + (s * -0.283), 0, 0, (lumR + (c * (-lumR))) + (s * (-(1 - lumR))), (lumG + (c * (-lumG))) + (s * lumG), (lumB + (c * (1 - lumB))) + (s * lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			return applyMatrix(temp, m);
		}
		
		private function saturation( m:Array, n:Number):Array {
			if (isNaN(n)) return m;
			var inv:Number = 1 - n;
			var r:Number = inv * lumR;
			var g:Number = inv * lumG;
			var b:Number = inv * lumB;
			var temp:Array = [r + n, g     , b     , 0, 0,
							  r     , g + n, b     , 0, 0,
							  r     , g     , b + n, 0, 0,
							  0     , 0     , 0     , 1, 0];
			return applyMatrix(temp, m);
		}
		
		private function threshold( m:Array, n:Number):Array {
			if (isNaN(n)) return m;
			var temp:Array = [lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						0,           0,           0,           1,  0]; 
			return applyMatrix(temp, m);
		}
		
		private function applyMatrix(m:Array, m2:Array):Array {
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