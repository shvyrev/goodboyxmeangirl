package railk.as3.tween.process.plugin.filters {
	
	import flash.filters.DropShadowFilter;
	import railk.as3.tween.process.plugin.helpers.ColorHelper;
	public class DropShadowFilterPlugin implements IFilters {
		
		public function DropShadowFilterPlugin() { }
		public function getType():String { return 'dropShadow'; }
		public function create( target:Object, vars:Object, progress:Number ):void {
			var prevFilter:DropShadowFilter; 
			var targetFilters:Array = target.filters;
			for ( var i:int = 0; i < targetFilters.length; i++ ) {
				if ( targetFilters[i] is DropShadowFilter ) { 
					prevFilter = targetFilters[i];
					targetFilters.splice(i, 1);
					break; 
				}
			}
			if ( prevFilter ) targetFilters.push( makeFilter( prevFilter, vars, progress ) );
			else  targetFilters.push( makeFilter( new DropShadowFilter(4,4,0x000000, 1, 4, 4, 1, 1, false, false,false), vars, progress ) );
			target.filters = targetFilters;
		}
		
		private function makeFilter( initProps:DropShadowFilter, endProps:Object, value:Number ):DropShadowFilter {
			return new DropShadowFilter( 	initProps.distance + ((endProps.distance || 0) - initProps.distance) *value,
											initProps.angle + ( ((endProps.angle == null) ? 45 : endProps.angle)- initProps.angle) *value,
											ColorHelper.mix(initProps.color,endProps.color,value), 
											initProps.alpha + ((endProps.alpha || 1) - initProps.alpha) *value, 
											initProps.blurX + ((endProps.blurX || 4) - initProps.blurX) *value, 
											initProps.blurY + ((endProps.blurY || 4) - initProps.blurY) *value, 
											initProps.strength + (((endProps.strength == null) ? 1 : endProps.strength) - initProps.strength) *value,
											initProps.quality + ((endProps.quality || 1) - initProps.quality) *value, 
											Boolean(endProps.inner),
											Boolean(endProps.knockout),
											Boolean(endProps.hideObject));
		}
	}
}