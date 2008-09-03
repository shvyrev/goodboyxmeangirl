package railk.as3.tween.process.plugin {
	
	import railk.as3.tween.process.plugin.sequence.ISequence;
	import railk.as3.tween.process.plugin.bezier.IBezier;
	import railk.as3.tween.process.plugin.filters.IFilters;
	import railk.as3.tween.process.plugin.color.IColor;
	import railk.as3.tween.process.plugin.sound.ISound;
	import railk.as3.tween.process.plugin.text.IText;
	
	public class PluginManager implements IPlugin {
		
		private var sequence                   	 :ISequence;
		private var bezier                     	 :IBezier;
		private var glow                    	 :IFilters;
		private var dropShadow                	 :IFilters;
		private var blur                    	 :IFilters;
		private var bevel                    	 :IFilters;
		private var color	                	 :IColor;
		private var sound                     	 :ISound;
		private var text                     	 :IText;
		
		public function enable( plugins:Array ):void {
			for ( var i:int; i < plugins.length; i++ )
			{
				var c:Class;
				switch( plugins[i].getType() ) {
					case 'sequence' : sequence = plugins[i] as ISequence; break;
					case 'glow' : glow = plugins[i] as IFilters; break;
					case 'dropShadow' : dropShadow = plugins[i] as IFilters; break;
					case 'blur' : blur = plugins[i] as IFilters; break;
					case 'bevel' : bevel = plugins[i] as IFilters; break;
					case 'color' : color = plugins[i] as IColor; break;
					case 'bezier' : bezier = plugins[i] as IBezier; break;
					case 'sound' : sound = plugins[i] as ISound; break;
					case 'text' : text = plugins[i] as IText; break;
				}
			}
		}	
		
		public function update( target:Object, propName:String, prop:Object, value:Number ):void {
			if ( propName == 'glow' ) glow.create( target, prop, value );
			else if ( propName == 'dropShadow' ) dropShadow.create( target, prop, value ); 
			else if ( propName == 'blur' ) blur.create( target, prop, value );
			else if ( propName == 'bevel' ) bevel.create( target, prop, value );
			/*else if ( propName == 'brightness' ) color.setBrightness( target, prop, value );
			else if ( propName == 'contrast' ) color.setContrast( target, prop, value );
			else if ( propName == 'color' ) color.setColorize( target, prop, value );
			else if ( propName == 'hue' ) color.setHue( target, prop, value );
			else if ( propName == 'saturation' ) color.setSaturation( target, prop, value );
			else if ( propName == 'threshold' ) color.setThreshold( target, prop, value );
			else if ( n == 'bezier' );
			else if ( n == 'volume' );
			else if ( n == 'pan' );
			else if ( n == 'text' ); */
		}
		
		public function getSequence():ISequence { return sequence; } 
	}
}