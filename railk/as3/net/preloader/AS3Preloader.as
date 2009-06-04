﻿/**
* 
* AS3Preloader for FD project
* 
* @author RICHARD RODNEY
* 
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
	import railk.as3.display.DSprite;
	import railk.as3.ui.loading.*;
	import railk.as3.display.graphicShape.*;

	
	public class AS3Preloader extends MovieClip
	{
		private var container  :DSprite;
		private var foreground :DSprite;
		private var background :DSprite;
		private var masker     :DSprite;
		private var loading    :RectLoading
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AS3Preloader():void {
			super();
			init();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function init():void {
			TopLevel.root = root;
			TopLevel.stage = stage;
			
			//--stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.ACTIVATE, manageEvent, false, 0, true );
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			
			//--create loading bar
			container = new DSprite();
			this.addChild( container );
			
				background =  createBackground();
				container.addChild( background );
				
				loading = createLoading();
				container.addChild( loading );
				loading.x2 = Math.round(container.width*.5);
				loading.y2 = Math.round(container.height*.5);
				
				masker = createMask();
				container.addChild( masker );
				masker.x2 = Math.round(container.width*.5);
				masker.y2 = Math.round(container.height*.5);
				loading.mask = masker;
				
				foreground = createForeground();
				container.addChild( foreground );
				foreground.x2 = Math.round(container.width*.5);
				foreground.y2 = Math.round(container.height*.5);
			
			container.x2 = stage.stageWidth*.5;
			container.y2 = stage.stageHeight*.5;	
			
			if ( currentFrame == totalFrames ){
				loading.percent = 100;
				launch();
			} else {
				loaderInfo.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
				addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 		CREATE BG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		protected function createBackground():DSprite {
			return new DSprite();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					CREATE FOREGROUND
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		protected function createForeground():DSprite {
			return new DSprite();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					CREATE FOREGROUND
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		protected function createMask():DSprite {
			var s:DSprite= new DSprite();
			
				var m:RectangleShape = new RectangleShape(0xFF0000,0,0,200,6);
				s.addChild( m );
			
			return s;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   CREATE LOADING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		protected function createLoading():* {
			var loadBar:RectLoading = new RectLoading(0xFFFFFF,0x111111,0,0,6,200);			
			return loadBar;
		}	
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function destroy():void {
			stop();
			loaderInfo.removeEventListener( ProgressEvent.PROGRESS, manageEvent);
			stage.removeEventListener( Event.RESIZE, manageEvent );
			stage.removeEventListener( Event.ACTIVATE, manageEvent );
			container.removeChild( loading );
			removeChild( container );
		}
		
		
		private function loop(evt:Event):void {
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, loop);
				launch();
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   LAUNCH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function launch():void {
			destroy();
			trace("                                    Preloader done");
			trace("---------------------------------------------------------------------------------------");
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass());
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case Event.RESIZE : case Event.ACTIVATE:
					container.x2 = Math.round(stage.stageWidth*.5);
					container.y2 = Math.round(stage.stageHeight*.5);
					break;
				
				case ProgressEvent.PROGRESS :
					var percent:Number = Math.round((evt.bytesLoaded / evt.bytesTotal )*100 );
					loading.percent = percent;
					break;
				
				case Event.COMPLETE :
					launch();
					break;
			}
		}
	}
}