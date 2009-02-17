/*** *  MVC IFacade* * @author Richard Rodney* @version 0.1*/package railk.as3.pattern.mvc.interfaces{	public interface IFacade 	{		function init( modelClass:Class, controllerClass:Class ):void		function registerView( name:String, viewClass:Class ):void;		function getView( name:String, view:IView ):IView;		function removeView( name:String ):void;		function registerCommand( type:String, commandClass:Class, actions:Array ):void;		function executeCommand( type:String, action:String ):void;		function removeCommand( type:String ):void;		function hasCommand( type:String ):void;		function registerProxy( proxyClass:Class ):void;		function removeProxy( name:String ):void;		function hasProxy( name:String ):Boolean;		function start():void;	}}