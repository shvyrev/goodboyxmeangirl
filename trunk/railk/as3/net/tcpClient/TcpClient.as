/**
* 
* Tcp Client
* 
* Connect to c#/java local server
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.tcpClient {

	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.Logger;
	
	
	public class TcpClient extends Sprite 
	{	
		// __________________________________________________________________________________ VARIABLES SOCKET
		private var sc                                 :Socket;
		private var _data                              :String;
		
		// ___________________________________________________________________________________ VARIABLES EVENT
		private var eEvent                             :TcpClientEvent;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function TcpClient() {
			sc = new Socket();
			sc.addEventListener( ProgressEvent.SOCKET_DATA, manageEvent, false, 0, true );
			sc.addEventListener( Event.CONNECT, manageEvent, false, 0, true  );
			sc.addEventListener( Event.CLOSE, manageEvent, false, 0, true  );
			sc.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
			sc.addEventListener( SecurityErrorEvent.SECURITY_ERROR, manageEvent, false, 0, true );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  CONNECT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	adress
		 * @param	port
		 */
		public function connect( adress:String, port:int ):void { sc.connect(  adress, port ); }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	SEND DATA
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function sendData( data:String ):void {
			sc.writeUTFBytes( data );
			sc.flush();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							 GET DATA
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getData( data:String ):void 
		{
			_data = data;
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"data received from server", data:_data };
			eEvent = new TcpClientEvent( TcpClientEvent.ONDATARECEIVED, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					    GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get receivedData():String { return _data; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type )
			{
				case SecurityErrorEvent.SECURITY_ERROR :
					break;
				
				case ProgressEvent.SOCKET_DATA :
					Logger.print( 'data reçu', Logger.MESSAGE );
					sc.writeUTFBytes( 'client deconnecte' );
					var d:String = sc.readUTFBytes( sc.bytesAvailable );
					getData( d );
					break;
				
				case Event.CONNECT :
					Logger.print( 'connecté', Logger.MESSAGE );
					///////////////////////////////////////////////////////////////
					var args:Object = { info:"connected to the server" };
					eEvent = new TcpClientEvent( TcpClientEvent.ONCONNECTED, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
					
				case Event.CLOSE :
					Logger.print( 'deconnecté', Logger.MESSAGE );
					break;
					
				case IOErrorEvent.IO_ERROR :
					Logger.print( 'erreur de connexion ', Logger.ERROR );
					break;
			}
		}
	}	
}