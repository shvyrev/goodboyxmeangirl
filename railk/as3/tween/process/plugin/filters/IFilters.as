package railk.as3.tween.process.plugin.filters {
	public interface IFilters {
		function apply( target:Object, vars:Object, progress:Number ):void;
		function getType():String;
		function getSubType():String;
	}
}