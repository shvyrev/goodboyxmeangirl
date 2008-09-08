package railk.as3.tween.process.plugin.filters {
	import flash.filters.BevelFilter;
	public class BevelFilterPlugin implements IFilters {
		public function BevelFilterPlugin() { }
		public function getType():String { return 'filters'; } 
		public function getSubType():String { return 'bevel'; } 
		public function apply( target:Object, vars:Object, progress:Number ):void {
			var defaultFilter:BevelFilter = new BevelFilter(); 
			var targetFilters:Array = target.filters;
			for ( var i:int = 0; i < targetFilters.length; i++ ) {
				if ( targetFilters[i] is BevelFilter ) { 
					prevFilter = targetFilters[i];
					targetFilters.splice(i, 1);
					break; 
				}
			}
			if ( prevFilter ) targetFilters.push( makeFilter( prevFilter, vars, progress ) );
			else  targetFilters.push( makeFilter( new BevelFilter(4,45,0xFFFFFF,1,0x000000,1,4,4,1,1,'inner',false), vars, progress ) );
			target.filters = targetFilters;
		}
		private function makeFilter( initProps:BevelFilter, endProps:Object, value:Number ):BevelFilter {
			return new BevelFilter( 	initProps.distance + ((endProps.distance || 0) - initProps.distance) *value,
										initProps.angle + (((endProps.angle == null) ? 45 : endProps.angle) - initProps.angle) *value,
										initProps.highlightColor + (((endProps.highlightColor == null) ? 0xFFFFFF : endProps.highlightColor) - initProps.highlightColor) *value,
										initProps.highlightAlpha + (((endProps.highlightAlpha == null) ? 1 : endProps.highlightAlpha) - initProps.highlightAlpha) *value,
										initProps.shadowColor + (((endProps.shadowColor == null) ? 0xFFFFFF : endProps.shadowColor) - initProps.shadowColor) *value,
										initProps.shadowAlpha + (((endProps.shadowAlpha == null) ? 1 : endProps.shadowAlpha) - initProps.shadowAlpha) *value,
										initProps.blurX + ((endProps.blurX || 4) - initProps.blurX) *value, 
										initProps.blurY + ((endProps.blurY || 4) - initProps.blurY) * value, 
										initProps.strength + (((endProps.strength == null) ? 1 : endProps.strength) - initProps.strength) *value,
										initProps.quality + ((endProps.quality || 1) - initProps.quality) * value,
										endProps.type || 'inner',
										Boolean(endProps.knockout));
		}
	}
}