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
	import railk.as3.crypto.Base64;
	import railk.as3.net.amfphp.service.IService;
	import railk.as3.utils.ObjectDumper;
	
	
	public class  AmfphpClient extends EventDispatcher
	{
		public var currentService   :String;
		public var currentRequester :String;
		public var credentials      :Object;
		private var mode            :String;
		private var server          :String;
		private var path            :String;
		private var connexion       :NetConnection;
		private var responder       :Responder;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	server 'http://'SERVER'/'PATH'/'
		 */
		public function AmfphpClient( server:String, path:String, ssl:Boolean = false ) {	
			this.server = server;
			this.path = path;
			this.mode = (ssl)?'https':'http';
			open();
		}
		
		/**
		 * MANAGE CONNECTION
		 */
		public function open():void {
			connexion = new NetConnection();
			connexion.connect( mode+'://'+server+'/'+path+'/' );
			connexion.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0 , true );
			responder = new Responder( onResult, onError );
		}
		
		public function close():void {
			connexion.close();
		}
		
		/**
		 * CALL TO A SERVICE
		 * 
		 * @param	service 	service to be used
		 * @param	requester   requester of the call
		 */
		public function call( service:IService, requester:String='' ):void { 
			currentRequester = requester;
			currentService = service.name;
			service.exec( connexion, responder );
		}
		
		public function directCall( service:String, ...args ):void { 
			connexion.call(service, responder, args);
		}
		
		
		/**
		 * CALL MANAGEMENT
		 */
		private function onResult( response:Object ):void {
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_RESULT, { info:"service call success", requester:currentRequester, service:currentService, data:response } ) );
		}
		
		private function onError( response:Object ):void {
			var result:String = '';
			for ( var prop:String in response ) { result += prop+' : '+String( response[prop] )+'\n'; }			
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_ERROR, { info:"service call error", requester:currentRequester, service:currentService, data:result } ) );
		}
		
		private function onNetStatus( evt:NetStatusEvent ):void {
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_CONNEXION_ERROR, { info:"connexion error\n"+ ObjectDumper.dump(evt.info) } ) );
		}
		
		/**
		 * credentials
		 */
		public function addCredentials(userid:String,password:String):void {	
			connexion.addHeader('Credentials', false, {userid:Base64.encode(userid),password:Base64.encode(password)} );
		}	
		 
		public function removeCredentials():void {
			open();
		}
		
		/**
		 * TOSTRING
		 */
		override public function toString():String {
			return '[ AMFPHP CLIENT > mode:'+mode+' ]'
		}
	}
}	