package railk.as3.tween.process.plugin {
	import railk.as3.tween.process.plugin.sequence.ISequence;
	public interface IPlugin {
		function enable( plugins:Array ):void;
		function update( target:Object, propName:String, prop:Object, value:Number ):void;
		function getSequence():ISequence;
	}
}