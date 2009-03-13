/**
 * 
 * Standart Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * TODO/ISSUE : make reflect work with colorFilters, Bezier and Filters;
 * 
 */

package railk.as3.motion.tween
{
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.filters.BitmapFilter;
	import railk.as3.motion.IRTween
	import railk.as3.motion.utils.TweenProxy;
	
	public class StandartTween extends LiteTween implements IRTween
	{
		public var data:*;
		public var repeat:int=0;
		public var reflect:Boolean;
		
		private var _proxy:Object;
		private var mods:Object = {	color:'railk.as3.motion.modules::ColorModule', 
									hexColor:'railk.as3.motion.modules::HexColorModule', 
									sound:'railk.as3.motion.modules::SoundModule',
									filter:'railk.as3.motion.modules::FilterModule',
									colorFilter:'railk.as3.motion.modules::ColorFilterModule',
									text:'railk.as3.motion.modules::TextModule',
									bezier:'railk.as3.motion.modules::BezierModule'};
		
		
		public function StandartTween( target:Object=null, duration:Number=NaN, props:Object=null, options:Object=null ) { super(target, duration, props, options); }
		
		public function setProps( os:Object ):void { for ( var o:String in os ) setProp( o, os[o] ); }
		
		public function setProp(name:String, value:*):void {
			var i:int = 0, o:Object = { };
			engine.reset(this);
			if ( this.hasOwnProperty(name) ) this[name]=value;
			else {
				while ( i < props.length ) {
					if (props[i][0] == name) { 
						props[i][3] = value; 
						props[i][2] = props[i][1];
						return; 
					}
					i++;
				}
				o[name]=value; stripProps(o);
			}
		}
		
		public function getProp(name:String):* {
			var i:int = 0;
			if ( this.hasOwnProperty(name) ) return this[name];
			else {
				while ( i < props.length ) {
					if (props[i][0] == name) return props[i][1];
					i++;
				}
			}
		}
		
		public function delProp(name:String):* {
			var i:int = 0;
			while ( i < props.length ) {
				if (props[i][0] == name) props.splice(i,1);
				i++;
			}
		}
		
		override protected function stripProps(ps:Object):void {
			var p:String, cf:Boolean=false, colorFilters:Object={};
			for ( p in ps ) {
				switch( p ) {
					case 'bezier': this.props.push([p,null,null,ps[p],'bezier']); break;
					case 'volume': this.props.push([p,null,target.soundTransform.volume,ps[p],'sound']); break;
					case 'pan': this.props.push([p,null,target.soundTransform.pan,ps[p],'sound']); break;
					case 'text': this.props.push([p,null,target.text,props[p],'text']); break;
					case 'textColor': this.props.push([p, null, target.textColor, ps[p],'text']); break;
					case 'color': this.props.push([p,null,target.transform.colorTransform,ps[p],'color']); break;
					case 'hexColor': this.props.push([p,null,target,ps[p],'hexColor']); break;
					case 'glow': case 'blur': case 'bevel': case 'dropShadow':  this.props.push([p, null, filter(p), ps[p],'filter']); break;
					case 'tint': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': colorFilters[p] = [p, null, target.filters, ps[p]]; cf=true; break;
					default : this.props.push( (( autoRotateH.hasOwnProperty(p) )?[p, null, target[p] % 360 + ((Math.abs(target[p] % 360 - ps[p] % 360)<180)?0:(target[p]%360>ps[p]%360)?-360:360), ps[p]%360]:[p,null,target[p],ps[p]]) ); break;
				}
			}
			if (cf) this.props.push(['cf', null, null, colorFilters, 'colorFilter']);
		}
		
		override protected function updateProperties(ratio:Number):Number {
			var i:int = 0, value:Number;
			if ( ratio!=0 && target!=null ) {
				while ( i < props.length ) {
					switch( props[i][4] ) {
						case 'sound': case 'text': case 'color': case 'hexColor': case 'colorFilter': case 'filter': case 'bezier': 
							props[i] = getDefinitionByName(mods[props[i][4]]).update( target, props[i], ratio ); 
							break;
						default :
							value = props[i][2]+(props[i][3] - props[i][2])*ratio;
							target[props[i][0]] = props[i][1] = (rounded)?Math.round(value):value;
							if( autoAlpha && props[i][0]=='alpha' && value==0 ) target.visible = false;
							break;
					}
					i++;
				}
				if (onUpdate != null) onUpdate.apply(null, onUpdateParams);
				if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			}
			return ratio;
		}
		
		override protected function complete():void {
			if (repeat>1 || repeat==-1) {
				if (reflect) {
					var i:int=0;
					while ( i < props.length) {
						var start:*= props[i][2], end:*= props[i][3];
						props[i][2] = end;
						props[i][3] = start;
						i++;
					}
				}
				engine.reset(this);
				if(repeat!=-1) repeat--;
			} 
			else super.complete();
		}
		
		private function filter( type:String ):BitmapFilter {
			var f:Array = target.filters, i:int = 0, count:int = f.length, result:BitmapFilter;
			l:for ( i = 0; i < count; i++) { if (f[i].toString()=='[object '+type.charAt(0).toUpperCase()+type.substr(1,type.length)+'Filter]') { result=f[i]; break l; } }
			return result;
		}
		
		override public function get proxy():* { return (_proxy)?_proxy:new TweenProxy(this); }
	}
}