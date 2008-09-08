package railk.as3.tween.process.plugin.sequence {
	import railk.as3.tween.process.Process;
	public interface ISequence {
		function getType():String;
		function add( n:String, t:Process, g:String='', a:Function=null ):void;
		function remove( name:String ):void; 
		function removeAll():void;
		function play():void;
		function pause():void;
	}
}