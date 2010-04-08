/*** *  MVC IFacade* * @author Richard Rodney* @version 0.1*/package railk.as3.pattern.mvc.interfaces{	import flash.events.IEventDispatcher;	public interface IFacade extends IEventDispatcher	{		function get container():*;		function get MID():String;		function set MID(value:String):void;		function registerContainer( container:* ):void;		function addChild( child:* ):*;		function addChildAt( child:*,index:int ):*;		function removeChild( child:* ):*;		function removeChildAt( index:int ):*;		function registerModel( modelClass:Class ):void;		function registerController( controllerClass:Class ):void;		function registerView( view:*, name:String='', component:*=null, data:*=null ):void;		function getView( name:String ):IView;		function removeView( name:String ):void;		function registerCommand( commandClass:Class, name:String='' ):void;		function executeCommand( name:String, action:String, ...args ):void;		function removeCommand( name:String ):void;		function registerProxy( proxyClass:Class, name:String='' ):void;		function getProxy( name:String ):IProxy;		function removeProxy( name:String ):void;		function sendNotification( note:String, info:String='', data:Object= null ):void ;	}}