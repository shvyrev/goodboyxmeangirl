/**
 * 
 * Single Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.tween
{
	import railk.as3.motion.IRTween
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.filters.BitmapFilter;
	
	public class StandartTween extends LiteTween implements IRTween
	{
		static public const YOYO:String = 'yoyo';
		static public const LOOP:String = 'loop';
		static public const REPLAY:String = 'replay';
		static public const NONE:String = 'none';
		
		public var repeat:String = NONE;
		private var mods:Object = {	color:'railk.as3.motion.modules::ColorModule', 
									hexColor:'railk.as3.motion.modules::HexColorModule', 
									sound:'railk.as3.motion.modules::SoundModule',
									filter:'railk.as3.motion.modules::FilterModule',
									colorFilter:'railk.as3.motion.modules::ColorFilterModule',
									text:'railk.as3.motion.modules::TextModule',
									bezier:'railk.as3.motion.modules::BezierModule'};
		
		
		static public function to( target:Object, duration:Number, props:Object, options:Object = null ):StandartTween { return new StandartTween( target, duration, props, options); }
		public function StandartTween( target:Object, duration:Number, props:Object, options:Object = null ) { super(target, duration, props, options); }
		
		override protected function setProperties():void {}
		
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
					default : this.props.push( (( autoRotateHash.hasOwnProperty(p) )?[p, null, target[p] % 360 + ((Math.abs(target[p] % 360 - ps[p] % 360)<180)?0:(target[p]%360>ps[p]%360)?-360:360), ps[p]%360]:[p,null,target[p],ps[p]]) ); break;
				}
			}
			if(cf) this.props.push(['cf',null,null,colorFilters,'colorFilter']);
		}
		
		override protected function updateProperties(ratio:Number):void {
			var i:int = 0, value:Number;
			if ( ratio != 0 && target!=null ){
				while ( i < props.length ) {
					switch( props[i][4] ) {
						case 'sound': case 'text': case 'color': case 'hexColor': case 'colorFilter': case 'filter': case 'bezier': 
							props[i] = getDefinitionByName(mods[props[i][4]]).update( target, props[i], ratio ); 
							break;
						default :
							value = props[i][2] + (props[i][3] - props[i][2])*ratio;
							target[props[i][0]] = props[i][1] = (rounded)?Math.round(value):value;
							break;
					}
					i++;
				}
				if (onUpdate != null) onUpdate.apply(null, onUpdateParams);
				if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function filter( type:String ):BitmapFilter {
			var f:Array = target.filters, i:int = 0, count:int = f.length, result:BitmapFilter;
			l:for ( i = 0; i < count; i++) { if (f[i].toString()=='[object '+type.charAt(0).toUpperCase()+type.substr(1,type.length)+'Filter]') { result=f[i]; break l; } }
			return result;
		}
	}
}