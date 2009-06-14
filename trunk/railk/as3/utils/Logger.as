/**
* Logger
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils 
{
	import flash.external.ExternalInterface;
	public class Logger 
	{
		public static const WARNING                               :String = 'warning';
		public static const ERROR                                 :String = 'error';
		public static const MESSAGE                               :String = 'message';
		public static const ALL                                   :String = 'all';
		public static const NONE                                  :String = 'none';
		
		private static var loggerType                             :String;
		private static var loggerChannel                          :String;
		
		/**
		 * INIT
		 * 
		 * @param	type
		 * @param	channel
		 */
		public static function init( type:String, channel:String = '' ):void { loggerType = type; loggerChannel = channel; }
		
		/**
		 * PRINT ON FLASH AND FIREBUG 
		 * 
		 * @param	info
		 * @param	type
		 * @param	caller
		 */
		public static function print( info:String, type:String='all', caller:String = null ):void {
			var _caller:String = ((caller != null ) ? caller.toUpperCase() : 'NONAME');
			var mess:String;
			if ( (loggerChannel == '' || loggerChannel == caller) && (loggerType == type || loggerType == Logger.ALL) ) mess = '[ LOG FROM ' + _caller +' => ' + info + ' ]';
			if(ExternalInterface.available) ExternalInterface.call('console.log',mess)
			trace( mess );
		}
		
		/**
		 * GETTER/SETTER
		 */
		public static function set type( type:String ):void { loggerType = type; }
		public static function get type():String { return loggerType; }	
	}
}