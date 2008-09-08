package railk.as3.tween.process.plugin.text {
	import flash.text.TextField;
	public interface  IText
	{
		function getType():String;
		function changeColor( target:Object, color:uint, n:Number ):void;
		function changeText( target:Object, value:String, n:Number ):void;
	}
}