/**
* 
* File check class coupled with filecheck.php
* 
* @author Default
*/


package railk.as3.data.checker {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.checker.FileCheckEvent;
	
	
	
	public class FileCheck extends EventDispatcher {
		
		// _______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                               :EventDispatcher;
		
		// _______________________________________________________________________________________ CONSTANTES
		private static const checkUrl                     		:String = "php/fileCheck.php";
		
		// _________________________________________________________________________________ VARIABLES LOADER
		private static var loader                         		:URLLoader;
		private static var req                            		:URLRequest;
		private static var rep                            		:String;
		private static var file                           		:String;
		
		// __________________________________________________________________________________ VARIABLES EVENT
		private static var eEvent                               :FileCheckEvent;
		
		
		
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
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	__file__    the file to check if it exist
		 */
		public static function check( __file__:String ):void {
			
			//--vars
			file = __file__;
			
			//--loader
			loader = new URLLoader();
			req= new URLRequest( checkUrl );
			req.data = __file__;
			req.method = URLRequestMethod.POST;
			req.contentType = "text";
			loader.load( req );
			
			/////////////////////////////////////
			initListeners()
			////////////////////////////////////
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   INIT LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function initListeners():void {
			loader.addEventListener(Event.COMPLETE, manageEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, manageEvent);
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						DEL LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function delListeners():void {
			loader.addEventListener(Event.COMPLETE, manageEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, manageEvent);
		}
		
		
		private static function dispose():void {
			delListeners();
			loader = null;
			req = null;
			rep = null;
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:* ):void {
			//--vars
			var args:Object;
			
			//--
			switch( evt.type ) {
				
				case Event.COMPLETE :
					rep = evt.currentTarget.data;

					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"fichier "+ file +" present", rep:rep };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new FileCheckEvent( FileCheckEvent.ONFILECHECKRESPONSE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
						
					////////////////////////////////////
					dispose();
					////////////////////////////////////
					
					break;
					
				case IOErrorEvent.IO_ERROR :
					
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"IOerror" };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new FileCheckEvent( FileCheckEvent.ONFILECHECKERROR, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
					
					////////////////////////////////////
					dispose();
					////////////////////////////////////
					
					break;
			}
		}
	}
	
}