package railk.as3.tween.process.plugin.filters {
	public interface IFilters {
		function create( target:Object, vars:Object, progress:Number ):void;
		function getType():String;
	}
}