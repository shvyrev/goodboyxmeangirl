public static function bezierProxy($o:Object):void {
			var factor:Number = $o.target.t, props:Object = $o.info.props, tg:Object = $o.info.target, i:int, p:String, b:Object, t:Number, segments:uint;
			if (factor == 1) { //to make sure the end values are EXACTLY what they need to be.
				for (p in props) {
					i = props[p].length - 1;
					tg[p] = props[p][i].e;
				}
			} else {
				for (p in props) {
					segments = props[p].length;
					if (factor < 0) {
						i = 0;
					} else if (factor >= 1) {
						i = segments - 1;
					} else {
						i = int(segments * factor);
					}
					t = (factor - (i * (1 / segments))) * segments;
					b = props[p][i];
					tg[p] = b.s + t * (2 * (1 - t) * (b.cp - b.s) + t * (b.e - b.s));
				}
			}
		}
		
		public static function bezierProxy2($o:Object):void { //Only for orientToBezier tweens. Separated it for speed.
			bezierProxy($o);
			var future:Object = {};
			var tg:Object = $o.info.target;
			$o.info.target = future;
			$o.target.t += 0.01;
			bezierProxy($o);
			var otb:Array = $o.info.orientToBezier;
			var a:Number, dx:Number, dy:Number, cotb:Array, toAdd:Number;
			for (var i:uint = 0; i < otb.length; i++) {
				cotb = otb[i]; //current orientToBezier Array
				toAdd = cotb[3] || 0;
				dx = future[cotb[0]] - tg[cotb[0]];
				dy = future[cotb[1]] - tg[cotb[1]];
				tg[cotb[2]] = Math.atan2(dy, dx) * _RAD2DEG + toAdd;
			}
			$o.info.target = tg;
			$o.target.t -= 0.01;
		}
		
		public static function parseBeziers($props:Object, $through:Boolean = false):Object { //$props object should contain a property for each one you'd like bezier paths for. Each property should contain a single array with the numeric point values (i.e. props.x = [12,50,80] and props.y = [50,97,158]). It'll return a new object with an array of values for each property, containing a "s" (start), "cp" (control point), and "e" (end) property. (i.e. returnObject.x = [{s:12, cp:32, e:50}, {s:50, cp:65, e:80}])
			var i:int, a:Array, b:Object, p:String;
			var all:Object = {};
			if ($through) {
				for (p in $props) {
					a = $props[p];
					all[p] = b = [];
					if (a.length > 2) {
						b[b.length] = {s:a[0], cp:a[1] - ((a[2] - a[0]) / 4), e:a[1]};
						for (i = 1; i < a.length - 1; i++) {
							b[b.length] = {s:a[i], cp:a[i] + (a[i] - b[i - 1].cp), e:a[i + 1]};
						}
					} else {
						b[b.length] = {s:a[0], cp:(a[0] + a[1]) / 2, e:a[1]};
					}
				}
			} else {
				for (p in $props) {
					a = $props[p];
					all[p] = b = [];
					if (a.length > 3) {
						b[b.length] = {s:a[0], cp:a[1], e:(a[1] + a[2]) / 2};
						for (i = 2; i < a.length - 2; i++) {
							b.push({s:b[i - 2].e, cp:a[i], e:(a[i] + a[i + 1]) / 2});
						}
						b[b.length] = {s:b[b.length - 1].e, cp:a[a.length - 2], e:a[a.length - 1]};
					} else if (a.length == 3) {
						b[b.length] = {s:a[0], cp:a[1], e:a[2]};
					} else if (a.length == 2) {
						b[b.length] = {s:a[0], cp:(a[0] + a[1]) / 2, e:a[1]};
					}
				}
			}
			return all;
		}
		
		
		var bProxy:Function = bezierProxy; 
			if (this.vars.orientToBezier == true) {
				this.vars.orientToBezier = [["x", "y", "rotation", 0]];
				bProxy = bezierProxy2;
			} else if (this.vars.orientToBezier is Array) {
				bProxy = bezierProxy2;
			}
			if (this.vars.bezier != undefined && (this.vars.bezier is Array)) {
				props = {};
				b = this.vars.bezier;
				for (i = 0; i < b.length; i++) {
					for (p in b[i]) {
						if (props[p] == undefined) {
							props[p] = [this.target[p]];
						}
						if (typeof(b[i][p]) == "number") {
							props[p].push(b[i][p]);
						} else {
							props[p].push(this.target[p] + Number(b[i][p])); //relative value
						}
					}
				}
				for (p in props) {
					if (typeof(this.vars[p]) == "number") {
						props[p].push(this.vars[p]);
					} else {
						props[p].push(this.target[p] + Number(this.vars[p])); //relative value
					}
					delete this.vars[p]; //to prevent TweenLite from doing normal tweens on these Bezier values.
				}
				addSubTween("bezier", bProxy, {t:0}, {t:1}, {props:parseBeziers(props, false), target:this.target, orientToBezier:this.vars.orientToBezier});
			}
			if (this.vars.bezierThrough != undefined && (this.vars.bezierThrough is Array)) {
				props = {};
				b = this.vars.bezierThrough;
				for (i = 0; i < b.length; i++) {
					for (p in b[i]) {
						if (props[p] == undefined) {
							props[p] = [this.target[p]]; //starting point
						}
						if (typeof(b[i][p]) == "number") {
							props[p].push(b[i][p]);
						} else {
							props[p].push(this.target[p] + Number(b[i][p])); //relative value
						}
					}
				}
				for (p in props) {
					if (typeof(this.vars[p]) == "number") {
						props[p].push(this.vars[p]);
					} else {
						props[p].push(this.target[p] + Number(this.vars[p])); //relative value
					}
					delete this.vars[p]; //to prevent TweenLite from doing normal tweens on these Bezier values.
				}
				addSubTween("bezierThrough", bProxy, {t:0}, {t:1}, {props:parseBeziers(props, true), target:this.target, orientToBezier:this.vars.orientToBezier});
				
			}