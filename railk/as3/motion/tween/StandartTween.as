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
		
		override public function pause():void {
			engine.remove( tween );
			if ( delay - elapsedTime <= 0) delay -= elapsedTime;
			else {
				duration -= elapsedTime-delay;
				delay = 0;
			}
			overlap();
		}
		
		override public function overlap():void {
			var i:int = 0;
			while ( i < this.props.length) {
				this.props[i][2] = props[i][1];
				i++;
			}
		}
		
		override protected function stripProps(props:Object):void {
			var p:String, cf:Boolean=false, colorFilters:Object={};
			for ( p in props ) {
				switch( p ) {
					case 'bezier': this.props.push([p,null,null,props[p]]); break;
					case 'volume': this.props.push([p,null,_target.soundTransform.volume,props[p]]); break;
					case 'pan': this.props.push([p,null,_target.soundTransform.pan,props[p]]); break;
					case 'text': this.props.push([p,null,_target.text,props[p]]); break;
					case 'textColor': this.props.push([p, null, _target.textColor, props[p]]); break;
					case 'color': this.props.push([p,null,_target.transform.colorTransform,props[p]]); break;
					case 'hexColor': this.props.push([p,null,_target,props[p]]); break;
					case 'glow': case 'blur': case 'bevel': case 'dropShadow':  this.props.push([p, null, filter(p), props[p]]); break;
					case 'tint': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': colorFilters[p] = [p, null, _target.filters, props[p]]; cf=true; break;
					default : this.props.push( (( autoRotateHash.hasOwnProperty(p) )?[p, null, _target[p] % 360 + ((Math.abs(_target[p] % 360 - props[p] % 360)<180)?0:(_target[p]%360>props[p]%360)?-360:360), props[p]%360]:[p,null,_target[p],props[p]]) ); break;
				}
			}
			if(cf) this.props.push(['cf',colorFilters]);
		}
		
		override public function updateProperties(ratio:Number):void {
			var i:int = 0, value:Number;
			if ( ratio != 0 && target!=null ){
				while ( i < props.length ) {
					switch( props[i][0] ) {
						case 'bezier': props[i] = getDefinitionByName(mods.bezier).update( _target, props[i], ratio ); break;
						case 'volume': case 'pan': props[i] = getDefinitionByName(mods.sound).update( _target, props[i], ratio ); break;
						case 'text': case 'textColor': props[i] = getDefinitionByName(mods.text).update( _target, props[i], ratio ); break;
						case 'color': props[i] = getDefinitionByName(mods.color).update( _target, props[i], ratio ); break;
						case 'hexColor': props[i] = getDefinitionByName(mods.hexColor).update( _target, props[i], ratio ); break;
						case 'glow': case 'blur': case 'bevel': case 'dropShadow': props[i] = getDefinitionByName(mods.filter).update( _target, props[i], ratio ); break;
						case 'cf': props[i][1] = getDefinitionByName(mods.colorFilter).update( _target, props[i][1], ratio ); break;
						default :
							value = props[i][2] + (props[i][3] - props[i][2]) * ratio;
							_target[props[i][0]] = props[i][1] = (rounded)?Math.round(value):value;
							break;
					}
					i++;
				}
				if (onUpdate != null) onUpdate.apply(null, onUpdateParams);
				if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function filter( type:String ):BitmapFilter {
			var f:Array = _target.filters, i:int = 0, count:int = f.length, result:BitmapFilter;
			l:for ( i = 0; i < count; i++) {
				if (f[i].toString()=='[object '+type.charAt(0).toUpperCase()+type.substr(1,type.length)+'Filter]') { result=f[i]; break l; }
			}
			return result;
		}
	}
	
}