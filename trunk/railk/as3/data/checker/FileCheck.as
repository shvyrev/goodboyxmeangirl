/**
* 
* File check class coupled with filecheck.php
* 
* @author Default
*/

package railk.as3.data.checker {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.checker.FileCheckEvent;
	import railk.as3.network.amfphp.*;
	import railk.as3.network.amfphp.service.FileService;
	
	
	
	public class FileCheck extends EventDispatcher {
		
		// _______________________________________________________________________________VARIABLES PROTEGEES
		protected static var disp                               :EventDispatcher;
	
		private static var _file                                :String;
		private static var requester                            :String = 'fileCheck';
		
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
		 * @param	file    the file to check if it exist
		 */
		public static function check( file:String, server:String='', path:String='' ):void 
		{	
			AmfphpClient.init( server, path );
			_file = file;
			
			////////////////////////////////////
			initListeners();
			AmfphpClient.call( new FileService().check( _file ), requester );
			////////////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				GESTION DES LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function initListeners():void {
			AmfphpClient.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			AmfphpClient.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		private static function delListeners():void {
			AmfphpClient.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			AmfphpClient.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function dispose():void {
			delListeners();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:AmfphpClientEvent ):void 
		{
			if ( evt.requester == requester )
			{
				var args:Object;
				switch( evt.type ) 
				{	
					case AmfphpClientEvent.ON_RESULT :
						///////////////////////////////////////////////////////////////
						args = { info:"fichier "+ _file +" present", data:evt.data };
						eEvent = new FileCheckEvent( FileCheckEvent.ON_FILE_CHECK_COMPLETE, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						dispose();
						break;
						
					case AmfphpClientEvent.ON_ERROR :
						///////////////////////////////////////////////////////////////
						args = { info:"check error" };
						eEvent = new FileCheckEvent( FileCheckEvent.ON_FILE_CHECK_ERROR, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						dispose();
						break;
				}
			}	
		}
	}
	
}