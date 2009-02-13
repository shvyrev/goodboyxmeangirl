/**
* Logger
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	
	public class Logger 
	{
		//________________________________________________________________________________________ CONSTANTES
		public static const WARNING                               :String = 'warning';
		public static const ERROR                                 :String = 'error';
		public static const MESSAGE                               :String = 'message';
		public static const ALL                                   :String = 'all';
		public static const NONE                                  :String = 'none';
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var loggerType                             :String;
		private static var loggerChannel                          :String;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( type:String, channel:String = '' ):void { loggerType = type; loggerChannel = channel; }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				TRACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function print( info:String, type:String, caller:String = null ):void {
			var _caller:String = (caller != null ) ? caller.toUpperCase() : 'NONAME'
			if ( loggerChannel == '' && (loggerType == type || loggerType == Logger.ALL) ) trace( '[ LOG FROM ' + _caller +' => ' + info + ' ]');
			else if( loggerChannel == caller && (loggerType == type || loggerType == Logger.ALL) ) trace( '[ LOG FROM ' + _caller +' => ' + info + ' ]');
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function set type( type:String ):void { loggerType = type; }
		
		public static function get type():String { return loggerType; }	
	}
}