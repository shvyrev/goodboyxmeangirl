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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  		  INIT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�		
		public static function init( stage:Stage ):void 
		{
			_stage = stage;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					 			ACTION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private static var action:Function = function ()
		{
			if( _stage.hasOwnProperty("displayState") )
			{
				if( _stage.displayState != StageDisplayState.FULL_SCREEN ) _stage.displayState = StageDisplayState.FULL_SCREEN;
				else _stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																					 DECORATE A BUTTON
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function decorate( button:* ):void
		{
			button.visible = _stage.hasOwnProperty("displayState");
			button.addEventListener( MouseEvent.CLICK, action, false, 0, true );
			button.buttonMode = true;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	  FUNCTION FOR EXTERNAL ACTIVATION
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public static function getFunction():Function{ return action; }
	}
}