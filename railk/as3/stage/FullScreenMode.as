/**
* 
* Fullscreen
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage {
	
	
	// ___________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	
	public class FullScreenMode extends Sprite {
		
		//__________________________________________________________________________________________ VARIABLES
		private static var _stage                                        :Stage;
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�		
		public static function Activate( button:Sprite, stage:Stage ):void {
			//--vars
			_stage = stage;
			
			//--si le player accepte le mode fullscreen le bouton devient visible et inversement
			button.visible = stage.hasOwnProperty("displayState");
			
			//--ajout des evenement au bouton
			button.addEventListener( MouseEvent.CLICK, onClick ,false,0,true );
			button.buttonMode = true;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	                GESTION FULLSCREEN
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private static function onClick( evt:MouseEvent ):void{
			
			if( _stage.hasOwnProperty("displayState") )
			{
				if( _stage.displayState != StageDisplayState.FULL_SCREEN ){
					_stage.displayState = StageDisplayState.FULL_SCREEN;
				}	
				else{
					_stage.displayState = StageDisplayState.NORMAL;
				}	
			}
			
		}
		
	}
}