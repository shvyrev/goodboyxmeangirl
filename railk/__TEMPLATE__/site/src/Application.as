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
	import railk.as3.TopLevel;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.stage.FullScreenMode;
	import railk.as3.utils.Logger;
	import railk.as3.ui.link.LinkManager;
	import railk.as3.tween.process.*;
	
	// _________________________________________________________________________________ IMPORT MACMOUSEWHEEL
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	
	
	public class Application extends Sprite {
		
		// _______________________________________________________________________________________ CONSTANTES
		private static var __PATH__            :String;

		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Application():void {
			
			//--flashVars
			__PATH__ = TopLevel.root.loaderInfo.parameters.path;
			__PATH__ = ( __PATH__ ) ? __PATH__ : '';
			
			//--stage
			StageManager.init( TopLevel.stage );
			StageManager.addEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent, false, 0, true );
			StageManager.GlobalVars.title = 'title';
			
			//--fullscreenMode
			FullScreenMode.init( TopLevel.stage );
			
			//--Mac Mouse Wheel
			MacMouseWheel.setup( TopLevel.stage );
			
			//--Process
			Process.enablePlugin( ProcessPlugins );
			
			//--logger
			Logger.init( Logger.MESSAGE );
			
			//--LinkManager
			LinkManager.init('title');
			
			//--create the Application
			create();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   CREATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void {
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			
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