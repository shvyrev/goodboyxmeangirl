/**
* 
* AS3Preloader for FD project
* 
* @author RICHARD RODNEY
* @version 0.2;
*/

package railk.as3.net.preloader 
{
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.getDefinitionByName;
	
	import railk.as3.TopLevel;
	import railk.as3.ui.loading.*;
	
	public class AS3Preloader extends MovieClip
	{
		protected var loading:RectLoading
		
		/**
		 * CONSTRUCTEUR
		 */
		public function AS3Preloader():void {
			super();
			init();
		}
		
		/**
		 * INIT
		 */
		private function init():void {
			TopLevel.root = root;
			TopLevel.stage = stage;
			TopLevel.main = this;
			
			//--stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.ACTIVATE, manageEvent, false, 0, true );
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			
			//--loading
			loading = createLoading();
			addChild( loading );
			loading.x2 = Math.round(stage.stageWidth*.5);
			loading.y2 = Math.round(stage.stageHeight*.5);

			if ( currentFrame == totalFrames ){
				loading.percent = 100;
				main();
			} else {
				loaderInfo.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
				addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		
		/**
		 * CREATE LOADING
		 */
		protected function createLoading():* {
			return  new RectLoading(0xFFFFFF,0x111111,0,0,200,1);			
		}	
		
		/**
		 * LOADING STATE LOOP
		 */
		private function loop(evt:Event):void {
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, loop);
				main();
			}
		}
		
		/**
		 * START MAIN
		 */
		private function main():void {
			dispose();
			trace("                    Preloader done");
			trace("------------------------------------------------------");
			addChild(new (getDefinitionByName("Main") as Class)() );
		}
		
		/**
		 * DISPOSE
		 */
		private function dispose():void {
			stop();
			loaderInfo.removeEventListener( ProgressEvent.PROGRESS, manageEvent);
			stage.removeEventListener( Event.RESIZE, manageEvent );
			stage.removeEventListener( Event.ACTIVATE, manageEvent );
			removeChild( loading );
		}
		
		/**
		 *MANAGE EVENT
		 */
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case Event.RESIZE : case Event.ACTIVATE:
					loading.x2 = Math.round(stage.stageWidth*.5);
					loading.y2 = Math.round(stage.stageHeight*.5);
					break;
				case ProgressEvent.PROGRESS : loading.percent = Math.round((evt.bytesLoaded / evt.bytesTotal )*100 ); break;
				case Event.COMPLETE : main(); break;
			}
		}
	}
}