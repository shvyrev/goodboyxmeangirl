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
	
	
	public class FlowService implements IService
	{
		private var _vars                            :Array;
		
		public function FlowService( ...args ):void {
			_vars = args;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			connexion.call( 'Flow.execute', responder, _vars );
		}
	}
	
}