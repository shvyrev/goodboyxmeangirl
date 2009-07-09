/**
* 
* Stage Manager
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.stage 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;		
	
	public class StageManager 
	{
		protected static var disp     :EventDispatcher;
		
		public static var width       :Number;
		public static var height      :Number;
		private static var lastMove   :Number;
		private static var timeOut    :Number;
		private static var isIdle     :Number;
		private static var isActive   :Number;
		private static var _stage     :Stage;
		private static var _framerate :int;
		
		
		/**
		 * GESTION DES LISTENERS DE CLASS
		 */
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		/**
		 * INIT
		 * 
		 * @param	stage
		 * @param	frameRate
		 * @param	align
		 * @param	quality
		 */
		public static function init( stage:Stage, cxMenu:Boolean = false, frameRate:int = 40, align:String = 'TL', quality:String = "high" ):void {
			//initialisation variable mouse idle .2*60*1000 = 30 seconds
			timeOut = .2*15*1000;
			
			//initialisation de la surface
			_stage = stage;
			_framerate = frameRate;
			stage.align = align;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = quality;
			stage.frameRate = frameRate;
			stage.showDefaultContextMenu = cxMenu;
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			stage.addEventListener( Event.MOUSE_LEAVE, manageEvent, false, 0, true );
			
			//taille de la surface
			height = stage.stageHeight;
			width = stage.stageWidth;	
		}
		
		/**
		 * MOUSE ACTIVITIES
		 */
		public static function checkMouseOn( t:Number=0 ):void {
			if( t != 0 ) timeOut =  t;
			isIdle = 0;
			isActive = 0;
			_stage.addEventListener(Event.ENTER_FRAME, idled ,false,0,true );
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, moved ,false,0,true );
		}
		
		public static function checkMouseOff():void{
			isIdle = 0;
			isActive = 0;
			_stage.removeEventListener(Event.ENTER_FRAME, idled );
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, moved );
		}
		
		private static function moved( evt:MouseEvent ):void { lastMove = getTimer(); }
		
		private static function idled ( evt:Event ):void 
		{
			var args:Object = new Object();
			if ( (lastMove+timeOut) < getTimer() ) {
				if( isIdle == 0 ){
					isActive = 0;
					dispatchEvent( new StageManagerEvent( StageManagerEvent.ONMOUSEIDLE, { info:"mouse Idle"} ) );
				}
				//on incremente isIdle pour n'envoyer le message q'une seule fois
				isIdle += 1;
			} else if ( _stage.mouseX || _stage.mouseY == true ) {
				if( isActive == 0 ){
					//on passe isactive a 0 pour pouvoir envoyer un message
					isIdle = 0;	
					dispatchEvent( new StageManagerEvent( StageManagerEvent.ONMOUSEACTIVE, { info:"mouse Active"} ));
				}
				//on incremente isActive pour n'envoyer le message q'une seule fois
				isActive += 1;
			}
		}
		
		/**
		 * FRAMRATE ADAPTER
		 */
		public static function minRate():void { _stage.frameRate = 5 };
		public static function maxRate():void { _stage.frameRate = _framerate };
		
		/**
		 * MANAGE EVENT
		 */
		private static function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case Event.RESIZE : dispatchEvent( new StageManagerEvent( StageManagerEvent.ONSTAGERESIZE, { info:"surface modifiee "+_stage.stageHeight+" "+_stage.stageWidth } ) ); break;
				case Event.MOUSE_LEAVE : 
					dispatchEvent( new StageManagerEvent( StageManagerEvent.ONMOUSELEAVE, { info:"la souris a quitte la surface" } ) );
					_stage.addEventListener(MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true);
					minRate();
					break;
				case MouseEvent.MOUSE_MOVE : 
					dispatchEvent( new StageManagerEvent( StageManagerEvent.ONMOUSEBACK, { info:"la souris est de retour" } ) );
					_stage.removeEventListener(MouseEvent.MOUSE_MOVE, manageEvent);
					maxRate();
					break;
			}
		}
	}
}