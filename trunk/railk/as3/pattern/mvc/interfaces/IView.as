/*** *  Iview* * @author Richard Rodney* @version 0.1*/package railk.as3.pattern.mvc.interfaces{		public interface IView 	{		function getName():String;		function get component():Object;		function set component(value:Object):void;		function show():void;		function hide():void;		function dispose():void;	}}