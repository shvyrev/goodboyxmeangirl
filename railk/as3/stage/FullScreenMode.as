/**
* 
* Fullscreen
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage {
	
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	
	public class FullScreenMode extends Sprite {
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�		
		public function FullScreenMode( button:Sprite, stage:Stage ):void {
			
			//si le player accepte le mode fullscreen le bouton devient visible et inversement
			button.visible = stage.hasOwnProperty("displayState");
			
			
			//ajout des evenement au bouton
			button.addEventListener( MouseEvent.CLICK, onClick ,false,0,true );
			button.buttonMode = true;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	                GESTION FULLSCREEN
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function onClick( evt:MouseEvent ):void{
			
			if( stage.hasOwnProperty("displayState") )
			{
				if( stage.displayState != StageDisplayState.FULL_SCREEN ){
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}	
				else{
					stage.displayState = StageDisplayState.NORMAL;
				}	
			}
			
		}
		
	}
}