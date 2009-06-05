﻿/**
* 
* main Template
* 
* @author RICHARD RODNEY
*/

package 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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
			var loader:URLLoader = new URLLoader( new URLRequest(TopLevel.root.loaderInfo.parameters.structure));
			loader.addEventListener(Event.COMPLETE,  function() {
				struct = new Structure( new XML(loader.data) );
				struct.view('index');
				loader = null;
			}, false, 0, true);
		}	
	}
}