/**
 * 
 * RTween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{	
	public interface IRTween
	{
		function start():void;
		function pause():void;
		function overlap():void;
		function update( time:Number ):void;
		function dispose():void;
		function get id():int;
		function get target():Object;
		function get head():Boolean;
		function set head(value:Boolean):void;
		function get tail():Boolean;
		function set tail(value:Boolean):void; 
		function get next():IRTween;
		function set next(value:IRTween):void; 
		function get prev():IRTween;
		function set prev(value:IRTween):void;
		function get startTime():Number;
		function set startTime(value:Number):void; 
	}
}	