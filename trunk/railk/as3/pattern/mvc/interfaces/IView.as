/*** *  Iview* * @author Richard Rodney* @version 0.1*/package railk.as3.pattern.mvc.interfaces{		import railk.as3.pattern.mvc.observer.Notification;	public interface IView 	{		function handleNotification(evt:Notification):void		function show():void;		function hide():void;		function dispose():void;		function get component():*;		function set component(value:*):void;		function get name():String;	}}