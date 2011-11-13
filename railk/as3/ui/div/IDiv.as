/**
 * Div
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	import railk.as3.display.IDisplayObject;
	import flash.events.Event;
	public interface IDiv extends IDisplayObject
	{	
		function init(float:String = 'none', align:String = 'none', position:String = 'relative', constraint:String = 'none'):IDiv;
		function bind():void;
		function unbind():void;
		function addDiv(div:IDiv):IDiv;
		function insertDivBefore(div:IDiv, next:IDiv):IDiv;
		function insertDivAfter(div:IDiv, prev:IDiv):IDiv;
		function delDiv(div:IDiv):void;
		function getDiv(name:String):IDiv;
		function delAllDiv():void;
		function updateDiv():void;
		function resizeDiv():void;
		function setCoordinate(x:Number, y:Number):void;
		function get numDiv():int;
		function get name():String;
		function set name(value:String):void;
		function get prev():IDiv;
		function set prev(value:IDiv):void;
		function get next():IDiv;
		function set next(value:IDiv):void;
		function get master():IDiv;
		function set master(value:IDiv):void;
		function get float():String;
		function set float(value:String):void;
		function set align(value:String):void;
		function get align():String;
		function get position():String;
		function set position(value:String):void;
		function get constraint():String;
		function set constraint(value:String):void;
		function get state():DivState;
		function set state(value:DivState):void;
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
	}
}