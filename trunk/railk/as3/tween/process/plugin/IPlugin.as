package railk.as3.tween.process.plugin {
	public interface IPlugin {
		function enable( plugins:Array ):void;
		function update( target:Object, propName:String, prop:*, value:Number ):void;
	}
}