package railk.as3.tween.process.plugin.sequence
{
	import railk.as3.tween.process.Process;
	public interface ISequence
	{
		function add( name:String, tween:Process, group:String = '', action:Function = null ):void;
		function insertBefore( who:String, name:String, tween:Process, group:String = '', action:Function = null ):void; 
		function insertAfter( who:String, name:String, tween:Process, group:String = '', action:Function = null ):void;
		function remove( name:String ):void; 
		function removeGroup( group:String ):void; 
		function removeAll():void;
		function play():void;
		function next():void;
		function prev():void;
	}
}