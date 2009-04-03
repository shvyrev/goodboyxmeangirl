/**
* 
* AMFPHP client
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.net.amfphp 
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	
	import railk.as3.utils.ObjectDumper;
	import railk.as3.stage.StageManager;
	
	
	public class  AmfphpClient extends EventDispatcher
	{
		public static var rootPath                           :String;
		public var currentService                            :String;
		public var currentRequester                          :String;
		public var persistent                                :Boolean;
		private var mode                                     :String;
		private var server                                   :String;
		private var path                                     :String;
		private var connexion                                :NetConnection;
		private var responder                                :Responder;
		private var connected                                :Boolean;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	CONNECT TO AMFPHP
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	server 'http://'SERVER'/'PATH'/gateway.php'
		 */
		public function AmfphpClient( server:String, path:String, persistent:Boolean=false, servicePath:String = '', ssl:Boolean=false )
		{	
			this.server = server;
			this.path = path;
			this.persistent = persistent;
			this.mode = (ssl)?'https':'http';
			
			open();
			//--rootPath
			rootPath = servicePath;
			var a:Array = path.split('/');
			for (var i:int = 0; i <a.length ; i++) {
				rootPath += '../';
			}
			rootPath += StageManager.folder;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	  OPEN CONNECTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function open():void {
			connexion = new NetConnection();
			connexion.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0 , true );
			connexion.connect( mode+'://'+server+'/'+path+'/gateway.php' );
			responder = new Responder( onResult, onError );
			connected = true;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	 CLOSE CONNECTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function close():void {
			connexion.close();
			connected = false;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	   CALL A SERVICE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	service 	service to be used
		 * @param	requester   requester of the call
		 */
		public function call( service:*, requester:String='' ):void { 
			currentRequester = requester;
			currentService = service.name;
			service.exec( connexion, responder );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   RESULT OF THE SERVICE CALL
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function onResult( response:Object ):void {
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_RESULT, { info:"service call success", requester:currentRequester, service:currentService, data:response } ) );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   			   ERROR HANDLING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function onError( response:Object ):void {
			var result:String = '';
			for ( var prop in response ) { result += String( prop )+'\n'; }			
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_ERROR, { info:"service call error", requester:currentRequester, service:currentService, data:result } ) );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   			   ERROR HANDLING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function onNetStatus( evt:NetStatusEvent ):void {
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_CONNEXION_ERROR, { info:"connexion error\n"+ ObjectDumper.dump(evt.info) } ) );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   			    GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get state():Boolean { return connected; }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   			   		TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String {
			var str:String = (connected)? 'connected' :'non_connected';
			return '[ AMFPHP CLIENT > '+str+' ]'
		}
	}
}	