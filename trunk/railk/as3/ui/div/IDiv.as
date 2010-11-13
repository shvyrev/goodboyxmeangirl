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
	import flash.geom.Point;
	public interface IDiv extends IDisplayObject
	{	
		function bind():void;
		function unbind():void;
		function addArc(div:IDiv):void;
		function removeArc(div:IDiv):Boolean;
		function resetArcs():void;
		function resize(evt:Event = null):void;
		function update(from:IDiv):void;
		function addDiv(div:IDiv):IDiv;
		function insertDivBefore(before:*, div:IDiv):IDiv;
		function insertDivAfter(after:*, div:IDiv):IDiv;
		function delDiv(div:*):void;
		function getDiv(name:String):IDiv;
		function delAllDiv():void;
		function get state():DivState;
		function get numDiv():int;
		function get name():String;
		function set name(value:String):void;
		function get prev():IDiv;
		function set prev(value:IDiv):void;
		function get next():IDiv;
		function set next(value:IDiv):void;
		function get master():Object;
		function set master(value:Object):void;
		function get float():String;
		function set float(value:String):void;
		function set align(value:String):void;
		function get align():String;
		function get position():String;
		function set position(value:String):void;
		function get margins():DivMargin;
		function set margins(value:DivMargin):void;
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		function get data():Object;
		function set data(value:Object):void;
		function get constraint():String;
		function set constraint(value:String):void;
		function get padding():Point;
		function set padding(value:Point):void;
	}
}