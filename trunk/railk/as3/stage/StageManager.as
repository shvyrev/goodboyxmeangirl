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
		public static var _stage                       :Stage;
		public static var folder                       :String;
		
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
		public static function init( stage:Stage, ctMenu = false, frameRate:int = 40, align:String = 'TL', quality:String = "high" ):void
		{
			trace("                                   Stage initialise");
			trace("---------------------------------------------------------------------------------------");
			
			//initialisation variable mouse idle .2*60*1000 = 30 seconds
			timeOut = .2*15*1000;
			_stage = stage;
			
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
			
			//folder
			folder = getAppFolder( stage.loaderInfo.loaderURL );
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		  GET THE APPFOLDER FROM ROOT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getAppFolder( value:String ):String 
		{
			var regLocal:RegExp = new RegExp("file:///[A-Z][|]/", "");
			var regLocalExtended:RegExp = new RegExp("file:///[A-Z][|]/[0-9A-Za-z%_./]*/www/", "");
			var regServer:RegExp = new RegExp("http://[A-Za-z0-9.]*/", "");
			folder = unescape( value );
			
			if ( folder.search(regLocal) != -1) folder = folder.replace( regLocalExtended, '');
			else if ( folder.search(regServer) != -1) folder = folder.replace( regServer, '');
			folder = folder.replace(folder.split('/')[folder.split('/').length - 1], "");
			
			return folder;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		GESTION ACTIVITE DE LA SOURIS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function checkMouseOn( t:Number=0 ):void{
			if( t != 0 ){ timeOut =  t; }
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
					///////////////////////////////////////////////////////////////
					args = { info:"mouse Idle"};
					eEvent = new StageManagerEvent( StageManagerEvent.ONMOUSEIDLE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
				}
				//on incremente isIdle pour n'envoyer le message q'une seule fois
				isIdle += 1;
			} 
			else if ( _stage.mouseX || _stage.mouseY == true ) 
			{
				if( isActive == 0 ){
					//on passe isactive a 0 pour pouvoir envoyer un message
					isIdle = 0;	
					///////////////////////////////////////////////////////////////
					args = { info:"mouse Active"};
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
		private static function manageEvent( evt:Event ):void 
		{
			var args:Object;
			switch( evt.type ) 
			{
				case Event.RESIZE :
					H = _stage.stageHeight;
					W = _stage.stageWidth;
					///////////////////////////////////////////////////////////////
					args = { info:"surface modifiee "+H+" "+W };
					eEvent = new StageManagerEvent( StageManagerEvent.ONSTAGERESIZE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
				
				case Event.MOUSE_LEAVE :
					///////////////////////////////////////////////////////////////
					args = { info:"la souris a quitte la surface" };
					eEvent = new StageManagerEvent( StageManagerEvent.ONMOUSELEAVE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					break;
			}
		}
	}
}