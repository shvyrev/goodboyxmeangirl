/**
* 
* Stage Manager
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.stage {
	
	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.Key;
	import railk.as3.stage.StageManagerEvent;	
	
	
	public class StageManager {
		
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                      :EventDispatcher;
		
		// ______________________________________________________________________________ VARIABLES STATIQUES
		public static var GlobalVars                   :Object = {};
		public static var H                            :Number;
		public static var W                            :Number;
		
		// ____________________________________________________________________________________________ STAGE
		public static var _stage                      :Stage;	
		
		// ______________________________________________________________________________ VARAIBLE MOUSE IDLE
		private static var lastMove                    :Number;
		private static var timeOut                     :Number;
		private static var isIdle                      :Number;
		private static var isActive                    :Number;
		
		// _______________________________________________________________________________ VARIABLE EVENEMENT
		private static var eEvent                      :StageManagerEvent;

		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
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
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  		 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	stage
		 * @param	frameRate
		 * @param	align
		 * @param	quality
		 */
		public static function init( stage:Stage, ctMenu=false, frameRate:int=40, align:String='TL', quality:String="high" ):void{
			//trace
			trace("                                   Stage initialise");
			trace("---------------------------------------------------------------------------------------");
						
			
			//initialisation variable mouse idle .2*60*1000 = 30 seconds
			timeOut = .2*15*1000;
			
			//initialisation de la surface 
			stage.align = align;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = quality;
			stage.frameRate = frameRate;
			stage.showDefaultContextMenu = ctMenu;
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			stage.addEventListener( Event.MOUSE_LEAVE, manageEvent, false, 0, true );
			
			//initialisation des listener clavier
			Key.initialize(stage);
			
			//taille de la surface
			H = stage.stageHeight;
			W = stage.stageWidth;
			
			//--
			_stage = stage;
			
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		GESTION ACTIVITE DE LA SOURIS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		* 
		* @param	t
		* @return
		*/
		public static function checkMouseOn( t:Number=0 ):void{
			if( t != 0 ){
				timeOut =  t;
			}
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
		
		//
		private static function moved( evt:MouseEvent ):void {
			//lorsque que l'on bouge on dispose du temps courant
			lastMove = getTimer();
		}
		
		private static function idled ( evt:Event ):void {
			//init
			var args:Object = new Object();
			//si le temps courant est inferieur au temps de mouvement de la souris + le time out
			if ( (lastMove+timeOut) < getTimer() ) {
				if( isIdle == 0 ){
					//on passe isactive a 0 pour pouvoir envoyer un message
					isActive = 0;
					
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"mouse Idle"};
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new StageManagerEvent( StageManagerEvent.ONMOUSEIDLE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					
				}
				//on incremente isIdle pour n'envoyer le message q'une seule fois
				isIdle += 1;
				
			//si la souris rebouge	
			} else if ( _stage.mouseX || _stage.mouseY == true ) {
				if( isActive == 0 ){
					//on passe isactive a 0 pour pouvoir envoyer un message
					isIdle = 0;	
					
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"mouse Active"};
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new StageManagerEvent( StageManagerEvent.ONMOUSEACTIVE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					
				}
				//on incremente isActive pour n'envoyer le message q'une seule fois
				isActive += 1;
				
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:Event ):void {
			var args:Object;
			switch( evt.type ) {
		
				case Event.RESIZE :
					//taille de la surface
					H = _stage.stageHeight;
					W = _stage.stageWidth;
					
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"surface modifiee "+H+" "+W };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new StageManagerEvent( StageManagerEvent.ONSTAGERESIZE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
				
				case Event.MOUSE_LEAVE :
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"la souris a quitte la surface" };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new StageManagerEvent( StageManagerEvent.ONMOUSELEAVE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
			}
			
		}
		
		
	}
}