/**
 * 
 * RTween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.utils.getDefinitionByName;
	import railk.as3.motion.utils.Prop;
	
	public class RTween extends RTweeny
	{
		/**
		 * for special actions like colorTransform, color etc please enable the correspondant modules
		 */
		static public function enable( ...modules ):Boolean { return true; }
		
		/**
		 * actions
		 */
		static public function to( target:Object=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ):RTween { return new RTween(target, duration, props, options, position); }
		
		/**
		 * Class
		 */
		public var data:*;
		public var repeat:int=0;
		public var reflect:Boolean;
		
		private var mods:Object = {	color:'railk.as3.motion.modules::ColorModule', 
									hexColor:'railk.as3.motion.modules::HexColorModule', 
									sound:'railk.as3.motion.modules::SoundModule',
									filter:'railk.as3.motion.modules::FilterModule',
									colorFilter:'railk.as3.motion.modules::ColorFilterModule',
									text:'railk.as3.motion.modules::TextModule',
									bezier:'railk.as3.motion.modules::BezierModule'};
		 
		 
		public function RTween( target:Object=null, duration:Number=NaN, props:Object=null, options:Object=null, position:Number=0 ) { super(target,duration,props,options,position); }
			
		public function setProps( os:Object ):void { for ( var o:String in os ) setProp( o, os[o] ); }
		
		public function setProp(name:String, value:*):void {
			var o:Object={}, i:int=props.length;
			if ( this.hasOwnProperty(name) ) this[name]=value;
			else {
				while( --i > -1 ){
					var p:Prop= props[i];
					if (p.type == name) { 
						p.end = value; 
						p.start = p.current;
						return; 
					}
				}
				o[name]=value; stripProps(o);
			}
			position = 0;
			engine.reset(this);
		}
		
		public function getProp(name:String):* {
			var i:int=props.length;
			if ( this.hasOwnProperty(name) ) return this[name];
			else while( --i > -1 ) if (props[i].type == name) return props[i].current;
		}
		
		public function delProp(name:String):* {
			var i:int = props.length;
			while( --i > -1 ) if (props[i].type == name) props.splice(i,1);
		}
		
		override protected function stripProps(ps:Object):void {
			var cf:Boolean=false, colorFilters:Object={};
			for ( var p:String in ps ) {
				switch( p ) {
					case 'bezier': props[props.length] = new Prop(p,p,null,ps[p]); break;
					case 'volume': case 'pan': props[props.length] = new Prop('sound',p,target.soundTransform[p],ps[p]); break;
					case 'text': case 'textColor': props[props.length] = new Prop('text',p,target[p],ps[p]); break;
					case 'color': props[props.length] = new Prop(p,p,target.transform.colorTransform,ps[p]); break;
					case 'hexColor': props[props.length] = new Prop(p,p,target,ps[p]); break;
					case 'glow': case 'blur': case 'bevel': case 'dropShadow':  props[props.length] = new Prop('filter',p,filter(p),ps[p]); break;
					case 'tint': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': colorFilters[p] = [p,null,target.filters,ps[p]]; cf=true; break;
					default : props[props.length] = new Prop(p,p,target[p], ps[p],autoRotateH.hasOwnProperty(p)); break;
				}
			}
			if (cf) props[props.length] = new Prop('colorFilter','', null, colorFilters);
		}
		
		override protected function updateProperties(ratio:Number):Number {
			var i:int=props.length;
			if ( target ) {
				while( --i > -1 ) {
					var p:Prop=props[i];
					switch( p.type ) {
						case 'sound': case 'text': case 'color': case 'hexColor': case 'colorFilter': case 'filter': case 'bezier': 
							props[i] = getDefinitionByName(mods[p.type]).update( target, p, ratio ); 
							break;
						default :
							var value:Number = value = Number(p.start)+Number(p.end-p.start)*ratio+ 1e-18-1e-18;
							target[p.type] = p.current = (rounded)?Math.round(value):value;
							if ( autoVisible && p.type == 'alpha' ) target.visible = value > 0;
							break;
					}
				}
				if (onUpdate != null) onUpdate.apply(null, onUpdateParams);
				if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			}
			return ratio;
		}
		
		override protected function complete():void {
			if (repeat>1 || repeat==-1) {
				if (reflect) {
					var i:int=props.length, start:*;
					while( --i > -1 ) {
						start = props[i].start;
						props[i].start = props[i].end;
						props[i].end = start;
					}
				}
				position = 0;
				engine.reset(this);
				if(repeat!=-1) repeat--;
			}
			else super.complete();
		}
		
		private function filter( type:String ):BitmapFilter {
			var f:Array = target.filters, i:int=f.length, result:BitmapFilter;
			l:while( --i > -1 ) { if (f[i].toString()=='[object '+type.charAt(0).toUpperCase()+type.substr(1,type.length)+'Filter]') { result=f[i]; break l; } }
			return result;
		}
	}
}