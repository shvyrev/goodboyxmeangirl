/**
* 
* Fullscreen
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage {
	
	
	// ___________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	
	public class FullScreenMode extends EventDispatcher {
		
		//__________________________________________________________________________________________ VARIABLES
		private static var _stage                                        :Stage;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  		  INIT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————		
		public static function init( stage:Stage ):void 
		{
			_stage = stage;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 			ACTION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private static var action:Function = function ()
		{
			if( _stage.hasOwnProperty("displayState") )
			{
				if( _stage.displayState != StageDisplayState.FULL_SCREEN ) _stage.displayState = StageDisplayState.FULL_SCREEN;
				else _stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 DECORATE A BUTTON
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public static function decorate( button:* ):void
		{
			button.visible = _stage.hasOwnProperty("displayState");
			button.addEventListener( MouseEvent.CLICK, action, false, 0, true );
			button.buttonMode = true;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	  FUNCTION FOR EXTERNAL ACTIVATION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public static function getFunction():Function{ return action; }
	}
}