package railk.as3.tween.process.plugin.filters {
	import flash.filters.*;
	public class Filters {
		private var _idMatrix:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		private var _target:Object;
		private var _clrsa:Array;
		private var _filters:Array =[];
		private var _tweens:Array = [];
		private var _hasFilter:Boolean=false;
		public function Filters(target:Object, tweens:Array, clrsa:Array):void { _target = target; _tweens = tweens; _clrsa = clrsa; }
		public function add(name:String, fv:Object, props:Array):Object {
			var df:BitmapFilter;
			var ft:Class;
			var matrix = _idMatrix.slice()
			switch( name ) {
				case 'blur' : df = new BlurFilter(0, 0, fv.quality || 2); ft = BlurFilter; break;
				case 'glow' : df = new GlowFilter(0xFFFFFF, 0, 0, 0, fv.strength || 1, fv.quality || 2, fv.inner, fv.knockout); ft = GlowFilter; break;
				case 'dropShadow' : df = new DropShadowFilter(0, 45, 0x000000, 0, 0, 0, 1, fv.quality || 2, fv.inner, fv.knockout, fv.hideObject); ft = DropShadowFilter; break;
				case 'bevel' : df = new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, fv.quality || 2); ft = BevelFilter; break;
				case 'colorMatrix' : df = new ColorMatrixFilter(matrix); ft = ColorMatrixFilter; break;
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
					} else if (prop == "quality" || prop == "inner" || prop == "knockout" || prop == "hideObject") {
						f.filter[prop] = fv[prop];
					} else {
						if (typeof(fv[prop]) == "number") {
							valChange = fv[prop] - f.filter[prop];
						} else {
							valChange = Number(fv[prop]);
						}
						_tweens[_tweens.length] = {o:f.filter, p:prop, s:f.filter[prop], c:valChange};
					}
				}
			}
			_hasFilter = true;
			_filters[_filters.length] = f;
			return f;
		}
		
		private function HEXtoRGB(n:Number):Object { return {rb:n >> 16, gb:(n >> 8) & 0xff, bb:n & 0xff}; }
		
		public function get filters():Array { return _filters; }
		public function get tweens():Array { return _tweens; }
		public function get hasFilter():Boolean { return _hasFilter; }
	}
}