﻿/**
* Service for amfphp
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.amfphp.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class FlowService implements IService
	{
		private var _method                          :String;
		private var _vars                            :Array;
		
		public function FlowService( method:String, ...args ) {
			_vars = args;
			_method = method;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			connexion.call( 'Flow.execute', responder, _method, _vars );
		}
		
		public function get name():String { return 'flow'; }
	}
	
}