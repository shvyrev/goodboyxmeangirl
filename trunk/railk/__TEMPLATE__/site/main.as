/**
* 
* main Template
* 
* @author RICHARD RODNEY
*/

package {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.root.Current;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.stage.FullScreenMode;
	import railk.as3.utils.Logger;
	
	// _________________________________________________________________________________ IMPORT MACMOUSEWHEEL
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	
	// _______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts
	import caurina.transitions.properties.TextShortcuts
	
	
	
	public class main extends Sprite {
		
		// _______________________________________________________________________________________ CONSTANTES
		private static var __PATH__            :String = "";

		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function main():void {
			
			//--flashVars
			__PATH__ = Current.root.loaderInfo.parameters.path;
			if ( __PATH__ == null ) __PATH__ = "";
			
			//--stage
			StageManager.init( Current.stage );
			StageManager.addEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent, false, 0, true );
			StageManager.GlobalVars.title = "Site Web Title";
			
			//--Mac Mouse Wheel
			MacMouseWheel.setup( Current.stage );
			
			//--Tweener
			ColorShortcuts.init();
			DisplayShortcuts.init();
			TextShortcuts.init();
			
			//--logger
			Logger.init( Logger.MESSAGE );

		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				         MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case StageManagerEvent.ONSTAGERESIZE :
					Logger.print( evt.info, Logger.MESSAGE );
					break;
					
				case StageManagerEvent.ONMOUSEIDLE :
					Logger.print( evt.info, Logger.MESSAGE );
					break;	
				
				case StageManagerEvent.ONMOUSEACTIVE :
					Logger.print( evt.info, Logger.MESSAGE );
					break;
					
				case StageManagerEvent.ONMOUSELEAVE :
					Logger.print( evt.info, Logger.MESSAGE );
					break;
			}
		}
		
		
	}
	
}