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
		static private var enabled:Boolean;
		
		/**
		 * START
		 */
		static public function init(info:String, enable:Boolean=true ):void {
			enabled = true; 
			log(info);
		}
		
		/**
		 * MESSAGE
		 */
		static public function log( ...info ):void { if ( enabled) print( inline(info),'log' ); }
		static public function warn( ...info ):void { if ( enabled) print( inline(info),'warn' ); }
		static public function error( ...info ):void { if ( enabled) print( inline(info),'error' ); }
		
		/**
		 * UTILITIES
		 */
		static private function inline(info:Array):String { return String(info).replace(',', ' '); }
		
		static private function print(mess:String,type:String):void {
			trace( mess );
			if (ExternalInterface.available) ExternalInterface.call('console.'+type, '['+type.toUpperCase()+'] '+mess);
		}
	}
}