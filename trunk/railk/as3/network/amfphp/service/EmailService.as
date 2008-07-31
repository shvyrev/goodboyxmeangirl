/**
* Service for amfphp
* 
* @author Richard Rodney
*/

package railk.as3.network.amfphp.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	
	public class EmailService implements IService
	{
		private var _to                              :String;
		private var _subject                         :String;
		private var _body                            :String;
		
		public function EmailService( to:String, subject:String, body:String ):void {
			_to = to;
			_subject = subject;
			_body = body;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			connexion.call( 'Email.send', responder, _to, _subject, _body );
		}
	}
	
}