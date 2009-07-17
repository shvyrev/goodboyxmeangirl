﻿/**
* 
* main Template
* 
* @author RICHARD RODNEY
*/

package 
{	
	import flash.display.Sprite;	
	import railk.as3.TopLevel;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.stage.FullScreenMode;
	import railk.as3.ui.SWFWheel;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class Application extends Sprite 
	{
		public function Application() {
			StageManager.init( TopLevel.stage, true );
			StageManager.addEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEIDLE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSEACTIVE, manageEvent, false, 0, true );
			StageManager.addEventListener( StageManagerEvent.ONMOUSELEAVE, manageEvent, false, 0, true );
			
			FullScreenMode.init( TopLevel.stage );
			SWFWheel.initialize( TopLevel.stage );
			
			///////////STARTUP/////////////
			startup();
			///////////////////////////////
			
			/////////////DEBUG/////////////
			var debugger:MonsterDebugger = new MonsterDebugger(this);
			///////////////////////////////
		}
		
		private function startup():void {
			
		}
		
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case StageManagerEvent.ONSTAGERESIZE :break;
				case StageManagerEvent.ONMOUSEIDLE :break;	
				case StageManagerEvent.ONMOUSEACTIVE :break;
				case StageManagerEvent.ONMOUSELEAVE :break;
			}
		}	
	}
}