﻿/**
 * oAuth Data
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.oauth
{	
	public class Consumer
	{
		public var key:String;
		public var secret:String;
		public function Consumer(key:String='',secret:String='') {
			this.key = key;
			this.secret = secret;
		}
		
		public function get empty():Boolean {
			return (!key && !secret)?true:false;
		}
	}
}