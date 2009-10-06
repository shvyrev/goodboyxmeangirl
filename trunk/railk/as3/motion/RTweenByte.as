/**
 * Micro Tween /autorotate /sound /color /text /textColor /begin /update /complete (1,57k)
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
		 * 
		 * @param	t 	target
		 * @param	dr	duration
		 * @param	ps	props {}
		 * @param	d	delay
		 * @param	e	ease
		 * @param	b	begin function
		 * @param	u	update function
		 * @param	c	complete function
		 * @return
		 */
		static public function to( t:*,dr:*,ps:*,d:*=0,e:*=null,b:*=null,u:*=null,c:*=null ):RTweenByte { return new RTweenByte(t,dr,ps,d,e,b,u,c); }

		/**
		 * Class
		 */
		private var stm:*=getTimer()*.001;
		public var t:*;
		public var dr:*;
		public var ps:*=[];
		public var d:*;
		public var e:*;
		public var u:*;
		public var c:*;
		
		public function RTweenByte(_t:*,_dr:*,_ps:*,_d:*=0,_e:*=null,_b:*=null,_u:*=null,_c:*=null) {
			t = _t;
			dr = _dr;
			d = _d;
			e = (_e!=null)?_e:de;
			u = _u;
			c = _c;
			if (_b) _b.apply();
			for ( var p:* in _ps ) {
				if (p.search('rotation')!=-1){ t[p]=t[p]%360+((Math.abs(t[p]%360-_ps[p]%360)<180)?0:(t[p]%360>_ps[p]%360)?-360:360); _ps[p]=_ps[p]%360;}	
				ps[ps.length] = [p,((t.hasOwnProperty(p))?t[p]:((p=='color')?t.transform.colorTransform.color:((p=='volume')?t.soundTransform.volume:t))),_ps[p]];
			}
			t.addEventListener('enterFrame', tk );
		}
		
		public function dsp():void {
			t.removeEventListener('enterFrame', tk );
			ps = c = null;
		}
		
		private function tk(ev:*):void {
			var tm:Number = (getTimer()*.001-stm)-d;
			if ( up(((tm>=dr)?1:((tm<=0)?0:e(tm,0,1,dr))))==1 ){
				if(c) c.apply();
				dsp();
			}
		}

		private function up( r:* ):* {
			if (u) u.apply();
			var i:int=ps.length;
			while( --i > -1 ) {
				var p:*= ps[i];
				if(p[0]=='volume') t.soundTransform=new SoundTransform(p[2]-(1-r),t.soundTransform.pan)
				else if(p[0]=='text') t.text = txt(r,p[1],p[2]);
				else if(p[0]=='textColor') t.textColor = clr(r,p[1],p[2]);
				else if (p[0] == 'color') { var c:* = new ColorTransform(); c.color=clr(r,p[1],p[2]); t.transform.colorTransform=c; }
				else t[p[0]] = p[1]+(p[2]-p[1])*r+1e-18-1e-18;
			}
			return r;
		}
		
		private function txt(r:*, b:String, e:String):* {
			var i:int, mxL:*= ((b.length > e.length)?b.length:e.length), x:*= 1/mxL, ind:*= int(r/x), curL:*= [], nxtL:*= [], reg:*= new RegExp(',', 'g');
			for (i=0;i<e.length;++i) nxtL.push(e.charAt(i));
			for (i=0;i<b.length;++i) curL.push(b.charAt(i));
			for (i=0; i < ind;++i) curL[i] = (nxtL[i])?nxtL[i]:'';
			return curL.toString().replace(reg, '');
		}
		
		private function clr(r:*,b:*,e:*):* {
			var q:Number=1-r;
			return  (((b>>24)&0xFF)*q+((e>>24)&0xFF)*r)<<24|(((b>>16)&0xFF)*q+((e>>16)&0xFF)*r)<<16|(((b>>8)&0xFF)*q+((e>>8)&0xFF)*r)<<8|(b&0xFF)*q+(e&0xFF)*r;
		}
		
		private function de(t:*,b:*,c:*,d:*):* { return c*t/d+b; }
	}
}