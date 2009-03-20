/**
 * 
 * RTween Bézier Module
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.modules{
	import flash.geom.Point;
	import railk.as3.motion.utils.Prop;
	public class BezierModule {
		static private var curve:Array;
		static private var distance:Number = 0;
		static private var radsDegree:Number = 57.3248407;
		
		
		static public function update( target:Object, props:Prop, ratio:Number):Prop {
			var autoRotate:Boolean = (props.end.autoRotate)?props.end.autoRotate:false;
			var through:Boolean = (props.end.through)?props.end.through:false; 
			updatePosition(through,props.end.points);
			move(target, ratio, autoRotate );
			return props;
		}

		static public function move(target:Object, n:Number, autoRotate:Boolean):void {
			var posDist:Number = n*distance, dist:Number=0, arcDist:Number, index:int, segments:int = curve.length-3;
			
			for(index = 0;index <= segments; index += 2) {
				arcDist = arcLength(curve[index], curve[index + 1], curve[index + 2]);
				if(dist + arcDist > posDist) break;
				dist += arcDist;
			}
			
			index = (index > segments) ? segments:index;
			var inc:Number = (posDist == distance) ? 1:(posDist - dist) / arcDist;
			var sPt:Point = curve[index], cPt:Point = curve[index + 1], ePt:Point = curve[index + 2];
			var pt:Point = new Point(quadratic(inc, sPt.x, cPt.x, ePt.x), quadratic(inc, sPt.y, cPt.y, ePt.y));
			target.x = pt.x;
			target.y = pt.y;
			if(autoRotate) target.rotation = angle(inc, sPt, cPt, ePt) * radsDegree;
		}

		static private function updatePosition(through:Boolean, p:Array):void {
			if(p.length <= 2) return;
			var i:int, len:int;
			curve = [];
			
			if(through) {
				var pt:Point = p[int(0)], cPt:Point;
				curve.push(pt);
				cPt = index(2,p).subtract(pt);
				cPt.x *= .25;
				cPt.y *= .25;
				cPt = index(1,p).subtract(cPt);
				pt = index(1,p);
				curve.push(cPt);
				curve.push(pt);
				
				len = p.length - 1;
				for(i = 1;i < len; i++) {
					cPt = index(i,p).add(index(i,p).subtract(cPt));
					pt = index(i+1,p);
					curve.push(cPt);
					curve.push(pt);
				}
			} else {
				len = 3 + int((p.length - 3)*.5) * 2;
				for( i = 0;i < len;i++) { curve.push(index(i,p)); }
			}
			updateDistance();
		}
		
		static private function index(index:int,p:Array):Point {
			return p[index];
		}

		static private function updateDistance():void {
			distance = 0;
			for(var i:int = 0;i <= curve.length - 3; i += 2) { distance += arcLength(curve[i], curve[i + 1], curve[i + 2]); }
		}

		static private function arcLength(pt1:Point,pt2:Point,pt3:Point):Number {
			var a1:Number = angleBetween(pt1, pt2);
			var a2:Number = angleBetween(pt2, pt3);
			if(a1 == a2 || (a2 == a1 + Math.PI)) return distanceBetween(pt1, pt3);
			var vmDivisor:Number = (pt2.y - .5 * pt3.y - .5 * pt1.y);
			var vm:Number = 0;
			if(vmDivisor != 0) vm = -(pt2.x - .5 * pt3.x - .5 * pt1.x) / vmDivisor;
			var vtDivisor:Number = (vm * (pt1.x - 2 * pt2.x + pt3.x) - (pt1.y - 2 * pt2.y + pt3.y));
			var vt:Number = 0;
			if(vtDivisor != 0) vt = (-vm * (pt2.x - pt1.x) + (pt2.y - pt1.y)) / vtDivisor;
			
			var va:Number = angle(vt, pt1, pt2, pt3);
			var ra:Number = projectDistance(pt1, pt2);
			var rb:Number = projectDistance(pt2, pt3);
			var alfa:Number = va - radAngle(pt1, pt2);
			var beta:Number = radAngle(pt2, pt3) - va;
			var rax:Number = ra * Math.cos(alfa);
			var ray:Number = ra * Math.sin(alfa);
			var rbx:Number = rb * Math.cos(beta);
			var rby:Number = rb * Math.sin(beta);
			var l1:Number = .5 * parabolaArcLength(ray, 2 * Math.abs(rax));
			var l2:Number = .5 * parabolaArcLength(rby, 2 * Math.abs(rbx));
			
			return (rax < 0 || rbx < 0) ? Math.abs(l2 - l1):l1 + l2;
		}

		static private function angleBetween(p1:Point, p2:Point):Number {
			var x:Number = p2.x - p1.x, y:Number = p2.y - p1.y;
			return Math.atan2(y, x);
		}

		static private function distanceBetween(p1:Point, p2:Point):Number {
			var x:Number = p2.x - p1.x, y:Number = p2.y - p1.y;
			return Math.sqrt((x * x) + (y * y));
		}

		static private function segment(pt1:Point,pt2:Point,pt3:Point,t1:Number,t2:Number):Object {
			var b1:Point = new Point(), b2:Point = new Point(), b3:Point = new Point();
			b1.x = quadratic(t1, pt1.x, pt2.x, pt3.x);
			b1.y = quadratic(t1, pt1.y, pt2.y, pt3.y);
			b3.x = quadratic(t2, pt1.x, pt2.x, pt3.x);
			b3.y = quadratic(t2, pt1.y, pt2.y, pt3.y);
			b2.x = control(t1, t2, pt1.x, pt2.x, pt3.x);
			b2.y = control(t1, t2, pt1.y, pt2.y, pt3.y);
			return {b1:b1, b2:b2, b3:b3};
		}

		static private  function control(t1:Number,t2:Number,a:Number,b:Number,c:Number):Number {
			return a + (t1 + t2) * (b - a) + t1 * t2 * (c - 2 * b + a);
		}

		static private function radAngle(p1:Point,p2:Point):Number {
			return Math.atan2(p2.y - p1.y, p2.x - p1.x);
		}

		static private function projectDistance(p1:Point,p2:Point):Number {
			return Math.sqrt(p2.x * p2.x + p1.x * p1.x - 2 * p1.x * p2.x + p2.y * p2.y + p1.y * p1.y - 2 * p1.y * p2.y);
		}

		static private function parabolaArcLength(a:Number,b:Number):Number {
			if(a == 0) return 0;
			return .5 * Math.sqrt(b * b + 16 * a * a) + ((b * b) / (8 * a)) * Math.log((4 * a + Math.sqrt(b * b + 16 * a * a)) / b);
		}

		static private function angle(t:Number, pt1:Point, pt2:Point, pt3:Point):Number {
			return (Math.atan2(derivative(t, pt1.y, pt2.y, pt3.y), derivative(t, pt1.x, pt2.x, pt3.x)));
		}

		static private function quadratic(t:Number,a:Number,b:Number,c:Number):Number {
			return a + t * (2 * (1 - t) * (b - a) + t * (c - a));
		}

		static private function derivative(t:Number, a:Number, b:Number, c:Number):Number {
			return 2 * a * (t - 1) + 2 * b * (1 - 2 * t) + 2 * c * t;
		}
	}
}