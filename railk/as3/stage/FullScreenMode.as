/**
* 
* Fullscreen
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage 
{	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class FullScreenMode extends EventDispatcher 
	{
		private static var _stage:Stage;
		
		/**
		 * INIT
		 */		
		public static function init( stage:Stage ):void {
			_stage = stage;
		}
		
		public static function click():void {
			if (!_stage) return;
			if ( _stage.hasOwnProperty("displayState") ) {
				if( _stage.displayState != StageDisplayState.FULL_SCREEN ) _stage.displayState = StageDisplayState.FULL_SCREEN;
				else _stage.displayState = StageDisplayState.NORMAL;
			}
		}
	}
}