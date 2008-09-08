package railk.as3.tween.process.plugin.filters {
	
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilter;
	import railk.as3.tween.process.plugin.helpers.ColorHelper;
	public class GlowFilterPlugin implements IFilters {
		
		public function GlowFilterPlugin() { }
		public function getType():String { return 'filters'; } 
		public function getSubType():String { return 'glow'; } 
		public function apply( target:Object, vars:Object, progress:Number ):void {
			var prevFilter:GlowFilter; 
			var targetFilters:Array = target.filters;
			for ( var i:int = 0; i < targetFilters.length; i++ ) {
				if ( targetFilters[i] is GlowFilter ) { 
					prevFilter = targetFilters[i];
					targetFilters.splice(i, 1);
					break; 
				}
			}
			if ( prevFilter ) targetFilters.push( makeFilter( prevFilter, vars, progress ) );
			else  targetFilters.push( makeFilter( new GlowFilter(0x000000, 1, 10, 10, 2, 1, false, false), vars, progress ) );
			target.filters = targetFilters;
		}
		
		private function makeFilter( initProps:GlowFilter, endProps:Object, value:Number ):GlowFilter {
			return new GlowFilter( 	ColorHelper.mix(initProps.color,endProps.color,value), 
									initProps.alpha + ((endProps.alpha || 1) - initProps.alpha) *value, 
									initProps.blurX + ((endProps.blurX || 10) - initProps.blurX) *value, 
									initProps.blurY + ((endProps.blurY || 10) - initProps.blurY) *value, 
									initProps.strength + (((endProps.strength == null) ? 2 : endProps.strength) - initProps.strength) *value,
									initProps.quality + ((endProps.quality || 2) - initProps.quality) *value, 
									Boolean(endProps.inner),
									Boolean(endProps.knockout));
		}
	}
	
}