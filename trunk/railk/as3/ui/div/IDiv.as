﻿/**
 * Div
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	public interface IDiv
	{	
		function bind():void;
		function unbind():void;
		function addArc(div:IDiv):void;
		function removeArc(div:IDiv):Boolean;
		function update(from:IDiv):void;
		function setFocus():void;
		function get state():DivState;
		function set state(value:DivState):void;
		function get float():String;
		function set align(value:String):void;
		function get align():String;
		function set float(value:String):void;
		function get position():String;
		function set position(value:String):void;
		function get margins():Object;
		function set margins(value:Object):void;
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		function get data():*;
		function set data(value:*):void;
	}
}