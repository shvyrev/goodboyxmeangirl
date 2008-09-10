package railk.as3.tween.process.plugin.filters {
	public interface IFilters {
		function add(name:String, fv:Object, props:Array):Object;
		function get filters():Array;
		function get tweens():Array;
	}
}