/**
* 
* Form for comments
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.network.amfphp 
{
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.network.amfphp.AmfphpClientEvent;
	import railk.as3.utils.ObjectDumper;
	
	
	public class  AmfphpClient
	{
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                      				:EventDispatcher;
		
		// ______________________________________________________________________________ VARIABLES CONNEXION
		public static var currentService                            :String;
		public static var currentRequester                          :String;
		private static var connected                                :Boolean = false;
		private static var connexion                                :NetConnection;
		private static var responder                                :Responder;
		
		// __________________________________________________________________________________ VARIABLES EVENT
		private static var eEvent                                   :AmfphpClientEvent;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																	   GESTION DES LISTENERS DE CLASS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	CONNECT TO AMFPHP
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		 * 
		 * @param	server 'http://'SERVER'/'PATH'/gateway.php'
		 */
		public static function init( server:String, path:String ):void 
		{	
			if ( connected == false ) {
				//trace
				trace("                                Amfphp Client initialise");
				trace("---------------------------------------------------------------------------------------");
				
				connexion = new NetConnection();
				connexion.connect( 'http://'+server+'/'+path+'/gateway.php' );
				connexion.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0 , true );
				responder = new Responder( onResult, onError );
				connected = true;
			}	
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	   CALL A SERVICE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		 * 
		 * @param	service 	service to be used
		 * @param	requester   requester of the call
		 */
		public static function call( service:*, requester:String='' ):void 
		{ 
			currentRequester = requester;
			currentService = service.name;
			service.exec( connexion, responder );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   RESULT OF THE SERVICE CALL
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function onResult( response:Object ):void 
		{
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"service call success", requester:currentRequester, service:currentService, data:response };
			eEvent = new AmfphpClientEvent( AmfphpClientEvent.ON_RESULT, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   ERROR HANDLING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function onError( response:Object ):void 
		{
			var result:String = '';
			for ( var prop in response ) { result += String( prop )+'\n'; }			
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"service call error", requester:currentRequester, service:currentService, data:result };
			eEvent = new AmfphpClientEvent( AmfphpClientEvent.ON_ERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   ERROR HANDLING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function onNetStatus( evt:NetStatusEvent ):void 
		{
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"connexion error\n"+ ObjectDumper.dump(evt.info) };
			eEvent = new AmfphpClientEvent( AmfphpClientEvent.ON_CONNEXION_ERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			    GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function get state():Boolean { return connected; }
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   		TO STRING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function toString():String
		{
			return '[ AMFPHP CLIENT > '+(connected)? 'connected' :'non_connected'+' ]'
		}
	}
}	