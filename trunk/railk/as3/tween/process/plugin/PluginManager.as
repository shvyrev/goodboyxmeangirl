package railk.as3.tween.process.plugin {
	
	import flash.filters.ColorMatrixFilter;
	import railk.as3.tween.process.plugin.bezier.IBezier;
	import railk.as3.tween.process.plugin.filters.IFilters;
	import railk.as3.tween.process.plugin.color.IColor;
	import railk.as3.tween.process.plugin.color.ITint;
	import railk.as3.tween.process.plugin.sound.ISound;
	import railk.as3.tween.process.plugin.text.IText;
	
	public class PluginManager implements IPlugin {
		
		private var bezier                     	 :IBezier;
		private var glow                    	 :IFilters;
		private var dropShadow                	 :IFilters;
		private var blur                    	 :IFilters;
		private var bevel                    	 :IFilters;
		private var color	                	 :IColor;
		private var tint	                	 :ITint;
		private var sound                     	 :ISound;
		private var text                     	 :IText;
		
		public function enable( plugins:Array ):void {
			for ( var i:int; i < plugins.length; i++ ) {
				switch( plugins[i].getType() ) {
					case 'glow' : glow = plugins[i] as IFilters; break;
					case 'dropShadow' : dropShadow = plugins[i] as IFilters; break;
					case 'blur' : blur = plugins[i] as IFilters; break;
					case 'bevel' : bevel = plugins[i] as IFilters; break;
					case 'color' : color = plugins[i] as IColor; break;
					case 'tint' : tint = plugins[i] as ITint; break;
					case 'bezier' : bezier = plugins[i] as IBezier; break;
					case 'sound' : sound = plugins[i] as ISound; break;
					case 'text' : text = plugins[i] as IText; break;
				}
			}
		}	
		
		public function update( target:Object, propName:String, prop:*, value:Number ):void {
			if ( propName == 'glow' ) glow.create( target, prop, value );
			else if ( propName == 'dropShadow' ) dropShadow.create( target, prop, value ); 
			else if ( propName == 'blur' ) blur.create( target, prop, value );
			else if ( propName == 'bevel' ) bevel.create( target, prop, value );
			else if ( propName == 'colorize' ) adjust(target,color.setColor( prop,value ));
			else if ( propName == 'brightness' ) adjust(target,color.setBrightness( prop*value ));
			else if ( propName == 'threshold' ) adjust(target,color.setThreshold( prop*value ));
			else if ( propName == 'contrast' ) adjust(target,color.setContrast( prop*value ));
			else if ( propName == 'hue' ) adjust(target,color.setHue( prop*value ));
			else if ( propName == 'saturation' ) adjust(target, color.setSaturation( prop * value ));
			else if ( propName == 'color' ) tint.setTint( target, prop, value );
			else if ( propName == 'volume' ) sound.volume( target, value );
			else if ( propName == 'pan' ) sound.pan( target, value );
			else if (propName == 'text_color' ) text.changeColor( target,prop,value);
			else if (propName == 'text' );
			/*else if (propName == 'bezier' ); */
		}
		
		private function adjust( target:Object, matrix:Array ):void {
			var targetFilters:Array = target.filters;
			for ( var i:int = 0; i < targetFilters.length; i++ ) {
				if ( targetFilters[i] is ColorMatrixFilter ) { 
					targetFilters.splice(i, 1);
					break; 
				}
			}
			targetFilters.push( new ColorMatrixFilter( matrix ) );
			target.filters = targetFilters;
		}
	}
}