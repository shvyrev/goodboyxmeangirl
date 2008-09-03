package railk.as3.tween.process.plugin.filters {
	
	import flash.filters.BlurFilter;
	public class BlurFilterPlugin implements IFilters {
		
		public function BlurFilterPlugin() { }
		public function getType():String { return 'blur'; } 
		public function create( target:Object, vars:Object, progress:Number ):void {
			var prevFilter:BlurFilter; 
			var targetFilters:Array = target.filters;
			for ( var i:int = 0; i < targetFilters.length; i++ ) {
				if ( targetFilters[i] is BlurFilter ) { 
					prevFilter = targetFilters[i];
					targetFilters.splice(i, 1);
					break; 
				}
			}
			if ( prevFilter ) targetFilters.push( makeFilter( prevFilter, vars, progress ) );
			else  targetFilters.push( makeFilter( new BlurFilter(4,4,1), vars, progress ) );
			target.filters = targetFilters;
		}
		
		private function makeFilter( initProps:BlurFilter, endProps:Object, value:Number ):BlurFilter {
			return new BlurFilter( 	initProps.blurX + ((endProps.blurX || 4) - initProps.blurX) *value, 
									initProps.blurY + ((endProps.blurY || 4) - initProps.blurY) *value, 
									initProps.quality + ((endProps.quality || 1) - initProps.quality) * value);
		}
	}
}