package railk.as3.tween.process.plugin {
	public interface IPlugin {
		function setTarget(target:Object):void;
		function init(tweens:Array,prop:Object,alpha:Number,reverse:Boolean):Array;
		function update( factor:Number):void;
	}
}