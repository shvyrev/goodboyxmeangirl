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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	CONNECT TO AMFPHP
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
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
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	  OPEN CONNECTION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function open():void {
			connexion = new NetConnection();
			connexion.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0 , true );
			connexion.connect( mode+'://'+server+'/'+path+'/gateway.php' );
			responder = new Responder( onResult, onError );
			connected = true;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	 CLOSE CONNECTION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function close():void {
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
		public function call( service:*, requester:String='' ):void { 
			currentRequester = requester;
			currentService = service.name;
			service.exec( connexion, responder );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   RESULT OF THE SERVICE CALL
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function onResult( response:Object ):void {
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_RESULT, { info:"service call success", requester:currentRequester, service:currentService, data:response } ) );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   ERROR HANDLING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function onError( response:Object ):void {
			var result:String = '';
			for ( var prop in response ) { result += String( prop )+'\n'; }			
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_ERROR, { info:"service call error", requester:currentRequester, service:currentService, data:result } ) );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   ERROR HANDLING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function onNetStatus( evt:NetStatusEvent ):void {
			dispatchEvent( new AmfphpClientEvent( AmfphpClientEvent.ON_CONNEXION_ERROR, { info:"connexion error\n"+ ObjectDumper.dump(evt.info) } ) );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			    GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function get state():Boolean { return connected; }
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   			   		TO STRING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		override public function toString():String {
			var str:String = (connected)? 'connected' :'non_connected';
			return '[ AMFPHP CLIENT > '+str+' ]'
		}
	}
}	