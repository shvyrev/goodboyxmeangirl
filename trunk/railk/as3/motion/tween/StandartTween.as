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
	public class StandartTween extends LiteTween implements IRTween
	{
		static public const YOYO:String = 'yoyo';
		static public const LOOP:String = 'loop';
		static public const REPLAY:String = 'replay';
		static public const NONE:String = 'none';
		
		private var mods:Object={color:'railk.as3.motion.modules::ColorModule',sound:'railk.as3.motion.modules::SoundModule',filter:'railk.as3.motion.modules::FilterModule',text:'railk.as3.motion.modules::TextModule'};
		public var repeat:String = NONE;
		
		
		static public function to( target:Object, duration:Number, props:Object, options:Object = null ):StandartTween { return new StandartTween( target, duration, props, options); }
		public function StandartTween( target:Object, duration:Number, props:Object, options:Object = null ) { super(target, duration, props, options); }
		
		override public function pause():void
		{
			engine.remove( tween );
			if ( delay - elapsedTime <= 0) delay -= elapsedTime;
			else {
				duration -= elapsedTime-delay;
				delay = 0;
			}
			overlap();
		}
		
		override public function overlap():void
		{
			var i:int = 0;
			while ( i < this.props.length) {
				this.props[i][2] = props[i][1];
				i++;
			}
		}
		
		override protected function stripProps(props:Object):void 
		{
			var p:String;
			for ( p in props ) {
				switch( p ) {
					case 'volume': this.props.push([p,null,_target.soundTransform.volume,props[p]]); break;
					case 'pan': this.props.push([p,null,_target.soundTransform.pan,props[p]]); break;
					case 'text': this.props.push([p,null,_target.text,props[p]]); break;
					case 'textColor': this.props.push([p, null, _target.textColor, props[p]]); break;
					case 'color': this.props.push([p,null,_target.transform.colorTransform,props[p]]); break;
					case 'colorize': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': case 'glow': case 'blur': case 'bevel': case 'dropShadow': this.props.push([p,null,_target.filters,props[p]]); break;
					default : this.props.push( (( autoRotateHash.hasOwnProperty(p) )?[p, null, _target[p] % 360 + ((Math.abs(_target[p] % 360 - props[p] % 360)<180)?0:(_target[p]%360>props[p]%360)?-360:360), props[p]%360]:[p,null,_target[p],props[p]]) ); break;
				}
			}
		}
		
		override public function updateProperties(ratio:Number):void 
		{
			var i:int = 0, value:Number
			if ( ratio != 0 && target!=null ){
				while ( i < props.length ) {
					switch( props[i][0] ) {
						case 'volume': case 'pan': props[i] = getDefinitionByName(mods.sound).update( _target, props[i], ratio ); break;
						case 'text': case 'textColor': props[i] = getDefinitionByName(mods.text).update( _target, props[i], ratio ); break;
						case 'color': props[i] = getDefinitionByName(mods.color).update( _target, props[i], ratio ); break;
						case 'colorize': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': case 'glow': case 'blur': case 'bevel': case 'dropShadow': props[i] = getDefinitionByName(mods.filter).update( _target, props[i], ratio ); break;
						default :
							value = props[i][2] + (props[i][3] - props[i][2]) * ratio;
							_target[props[i][0]] = props[i][1] = (rounded)?int(value):value;
							break;
					}
					i++;
				}
				if (onUpdate != null) onUpdate.apply(null, onUpdateParams);
				if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
	
}