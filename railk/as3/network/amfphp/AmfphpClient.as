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
	import railk.as3.stage.StageManager;
	
	
	public class  AmfphpClient extends EventDispatcher
	{
		// ______________________________________________________________________________ VARIABLES CONNEXION
		public static var rootPath                           :String;
		public var currentService                            :String;
		public var currentRequester                          :String;
		public var persistent                                :Boolean;
		private var server                                   :String;
		private var path                                     :String;
		private var connexion                                :NetConnection;
		private var responder                                :Responder;
		private var connected                                :Boolean = false;
		
		// __________________________________________________________________________________ VARIABLES EVENT
		private  var eEvent                                   :AmfphpClientEvent;
				
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	CONNECT TO AMFPHP
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		 * 
		 * @param	server 'http://'SERVER'/'PATH'/gateway.php'
		 */
		public function AmfphpClient( server:String, path:String, persistent:Boolean=false, servicePath:String = '' ):void 
		{	
			this.server = server;
			this.path = path;
			this.persistent = persistent;
			
			open();
			//--rootPath
			rootPath = servicePath;
			var a:Array = path.split('/');
			for (var i:int = 0; i <a.length ; i++) 
			{
				rootPath += '../';
			}
			rootPath += StageManager.folder;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	  OPEN CONNECTION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function open():void
		{
			connexion = new NetConnection();
			connexion.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0 , true );
			connexion.connect( 'http://'+server+'/'+path+'/gateway.php' );
			responder = new Responder( onResult, onError );
			connected = true;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	 CLOSE CONNECTION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function close():void
		{
			connexion.close();
			connected = false;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	   CALL A SERVICE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		 * 
		 * @param	service 	service to be used
		 * @param	requester   requester of the call
		 */
		public function call( service:*, requester:String='' ):void 
		{ 
			currentRequester = requester;
			currentService = service.name;
			service.exec( connexion, responder );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   RESULT OF THE SERVICE CALL
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function onResult( response:Object ):void 
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
		private function onError( response:Object ):void 
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
		private function onNetStatus( evt:NetStatusEvent ):void 
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
		public function get state():Boolean { return connected; }
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   		TO STRING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		override public function toString():String
		{
			var str:String = (connected)? 'connected' :'non_connected';
			return '[ AMFPHP CLIENT > '+str+' ]'
		}
	}
}	