/**
* Service for amfphp
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.network.amfphp.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class DatabaseService implements IService
	{
		private var _method                          :String;
		private var _vars                            :Array;
		
		public function DatabaseService( method:String, ...args ) 
		{
			_vars = args;
			_method = method;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			connexion.call( 'Database.execute', responder, _method, _vars );
		}
		
		public function get name():String { return 'database'; }
	}
	
}