/**
* Fullscreen
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage 
{	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.link.*;
	
	public class FullScreenMode
	{
		private var linkManager:ILinkManager;
		private var link:ILink;
		private var linkOff:ILink;
		private var stage:Stage;
		private var action:Function;
		private var state:String = 'normal';
		
		public static function getInstance():FullScreenMode {
			return Singleton.getInstance(FullScreenMode);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function FullScreenMode() { Singleton.assertSingle(FullScreenMode); }
		
		/**
		 * INIT
		 */		
		public function init(linkManager:ILinkManager, stage:Stage,on:Object,off:Object, action:Function = null, colors:Object = null):void {
			if (!stage) return;
			this.linkManager = linkManager;
			this.action = action;
			this.stage = stage;
			if ( stage.hasOwnProperty("displayState") ) {
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, manageEvent, false, 0, true);
				linkManager.addGroup("fullscreenmode");
				if (on == off) link = linkManager.add("fullscreenmode", on, execute, 'fullscreenmode','fullscreenmode', colors);
				else {
					link = linkManager.add("fullscreenmodeON", on, activate, 'fullscreenmodeON','fullscreenmode',colors);
					linkOff = linkManager.add("fullscreenmodeOFF", off, desactivate, 'fullscreenmodeOFF', 'fullscreenmode', colors);
					linkOff.doAction();
				}
			}
		}
		
		public function dispose():void {
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, manageEvent);
		}
		
		private function execute(type:*, requester:*, data:*):void {
			switch(type) {
				case "do" : stage.displayState = state = StageDisplayState.FULL_SCREEN; break;
				case "undo" : stage.displayState = state = StageDisplayState.NORMAL; break;
				default:break;
			}
			if(action!=null) action.apply(null,[type,requester,data]);
		}

		
		private function activate(type:*, requester:*, data:*):void {
			switch(type) {
				case "do" : stage.displayState = state = StageDisplayState.FULL_SCREEN; break;
				default:break;
			}
			if(action!=null) action.apply(null,[type,requester,data]);
		}
		
		private function desactivate(type:*, requester:*, data:*):void {
			switch(type) {
				case "do" :  stage.displayState = state = StageDisplayState.NORMAL;break;
				default:break;
			}
			if(action!=null) action.apply(null,[type,requester,data]);
		}
		
		private function manageEvent(e:FullScreenEvent):void {
			if (linkOff) 
			{	
				if (state != stage.displayState && state == StageDisplayState.FULL_SCREEN) {
					linkOff.action();
					linkManager.navigationChange('fullscreenmodeOFF');
				}
			} else {
				if (state != stage.displayState) link.action();
			}
		}
	}
}