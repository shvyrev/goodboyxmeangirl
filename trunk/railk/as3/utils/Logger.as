/**
* Logger
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	
	
	public class Logger {
	
		
		//________________________________________________________________________________________ CONSTANTES
		public static const WARNING                               :String = 'warning';
		public static const ERROR                                 :String = 'error';
		public static const MESSAGE                               :String = 'message';
		public static const ALL                                   :String = 'all';
		public static const NONE                                  :String = 'none';
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var loggerType                             :String;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( type:String ):void {
			loggerType = type;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				TRACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function print( info:String, type:String ):void {
			if ( loggerType == type || loggerType == Logger.ALL ){
				trace( info );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function set type( type:String ):void {
			loggerType = type;
		}
		
		public static function get type():String {
			return loggerType;
		}
		
	}
	
}