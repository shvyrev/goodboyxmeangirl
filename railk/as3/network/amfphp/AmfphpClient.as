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
		private static var connexion                                :NetConnection;
		private static var responder                                :Responder;
		
		// __________________________________________________________________________________ VARIABLES EVENT
		private static var eEvent                                   :AmfphpClientEvent;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	CONNECT TO AMFPHP
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	server 'http://'SERVER'/amfphp/gateway.php'
		 */
		public static function init( server:String ):void 
		{
			//trace
			trace("                                Amfphp Client initialise");
			trace("---------------------------------------------------------------------------------------");
			
			connexion = new NetConnection();
			connexion.connect( 'http://localhost/amfphp/gateway.php' );
			connexion.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0 , true );
			responder = new Responder( onResult, onError );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	   CALL A SERVICE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	service 	name of the service to call -> service.method
		 * @param	...args		arguments to be past in the service call
		 */
		public static function call( service:* ):void {
			service.exec( connexion, responder );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   RESULT OF THE SERVICE CALL
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function onResult( response:Object ):void {
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"service call success", data:response };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new AmfphpClientEvent( AmfphpClientEvent.ON_RESULT, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   			   ERROR HANDLING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function onError( response:Object ):void {
			var result:String = '';
			for ( var prop in response )
			{
				result += String( prop )+'\n';
			}
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"service call error", data:result };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new AmfphpClientEvent( AmfphpClientEvent.ON_ERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   			   ERROR HANDLING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function onNetStatus( evt:NetStatusEvent ):void {
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"connexion error\n"+ ObjectDumper.dump(evt.info) };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new AmfphpClientEvent( AmfphpClientEvent.ON_CONNEXION_ERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
	}
}	