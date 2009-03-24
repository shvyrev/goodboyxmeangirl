/**
 * 
 * Micro Tween /sound /color /text /textColor
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import flash.utils.getTimer;
	import flash.geom.ColorTransform;
	import flash.media.SoundTransform;
	public class RTweenByte
	{
		/**
		 * actions
		 */
		static public function to( t:*,dr:*,ps:*,d:*=0,e:*=null ):RTweenByte { return new RTweenByte(t,dr,ps,d,e); }

		/**
		 * Class
		 */
		private var stm:*=getTimer()*.001;
		public var t:*;
		public var dr:*;
		public var ps:*=[];
		public var d:*;
		public var e:*;
		
		public function RTweenByte( _t:*, _dr:*, _ps:*, _d:*=0, _e:*=null) {
			t = _t;
			dr = _dr;
			d = _d;
			e = (_e!=null)?_e:de;
			for ( var p in _ps ) ps[ps.length] = [p,t[p],_ps[p]]; 
			t.addEventListener('enterFrame', tk );
		}
		
		private function tk(ev:*):void {
			var tm = (getTimer()*.001-stm)-d;
			if ( u(((tm>=dr)?1:((tm<=0)?0:e(tm,0,1,dr)))) == 1 ){
				t.removeEventListener('enterFrame', tk );
				t = ps = null;
			}
		}

		private function u( r:* ):* {
			var i=ps.length, tr=t.transform.colorTransform, ts=t.soundTransform;
			while( --i > -1 ) {
				var p:*=ps[i];
				if(p[0]=='volume') ts=new SoundTransform(p[2]-(1-r),ts.pan)
				else if(p[0]=='text') t.text = txt(r,p[1],p[2]);
				else if(p[0]=='textColor') t.textColor = clr(r,p[1],p[2]).color;
				else if(p[0]=='color') tr=clr(r,tr,p[2]);
				else if(p[0]=='hexColor') t=mx(r,p[1],p[2]);
				else t[p[0]] = p[1]+(p[2]-p[1])*r+1e-18-1e-18;
				if(p[0]=='alpha') t.visible=false;
				
			}
			return r;
		}
		
		private function clr( r:*,bc:*,ec:*):* {
			var b, e=new ColorTransform(), r=1-r;
			e.color = ec;
			if ( bc is ColorTransform){ b=bc; b.alphaMultiplier = t.a; }
			else { b=new ColorTransform(); b.color=bc; }
			return (new ColorTransform( b.redMultiplier*r+e.redMultiplier*r, b.greenMultiplier*r+e.greenMultiplier*r, b.blueMultiplier*r+e.blueMultiplier*r, b.alphaMultiplier*r+e.alphaMultiplier*r, b.redOffset*r+e.redOffset*r, b.greenOffset*r+e.greenOffset*r, b.blueOffset*r+e.blueOffset*r, b.alphaOffset*r+e.alphaOffset*r ));
		}
		
		private function txt(r:*,b:*,e:*):* {
			var i, mxL=(b.length>e.length)?b.length:e.length, x=1/mxL, ind=int(r/x), curL=[], nxtL=[], reg=new RegExp(',','g');
			for (i=0;i<b.length;++i) nxtL.push(b.charAt(i));
			for (i=0;i<e.length;++i) curL.push(e.charAt(i));
			for (i=0;i<ind;++i) curL[i]=(nxtL[i])?nxtL[i]:'';
			return curL.toString().replace(reg, '');
		}
		
		private function mx(r:*,b:*,e:*):* {
			var q=1-r;
			return  (((b>>24)&0xFF)*q+((e>>24)&0xFF)*r)<<24|(((b>>16)&0xFF)*q+((e>>16)&0xFF)*r)<<16|(((b>>8)&0xFF)*q+((e>>8)&0xFF)*r)<<8|(b&0xFF)*q+(e&0xFF)*r;
		}
		
		private function de(t:*,b:*,c:*,d:*):* { return c*t/d+b; }
	}
}