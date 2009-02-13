/**
* 
* update and save data files
* 
* @author Richard Rodney.
* @version 0.2
*/

package railk.as3.net.saver.file {
	
	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	// _______________________________________________________________________________________ IMPORT RAILK
	import railk.as3.net.amfphp.*;
	import railk.as3.net.amfphp.service.FileService;
	
	
	public class FileSaver extends EventDispatcher {
		
		//____________________________________________________________________________________ VARIABLES RECUPERE
		private var _name                                 :String;
		private var _data                                 :ByteArray;
		private var _type                                 :String;
		private var _path                                 :String;
		private var _url                                  :String;
		private var _fileName                             :String;
		private var _fileType                             :String;
		
		//______________________________________________________________________________________________ VARIABLES
		private var amf                                   :AmfphpClient;
		private var downloader                            :FileReference;
		private var requester                             :String = 'fileSaver';
		
		//____________________________________________________________________________________ VARIABLES EVENEMENT
		private var eEvent                                :FileSaverEvent;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function FileSaver( name:String = 'undefined', server:String = '', path:String = '' )
		{
			_name = name;
			amf = new AmfphpClient( server, path, false,'../' );
			downloader = new FileReference();
			
			////////////////////////////////////
			initListeners()
			////////////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				GESTION DES LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void {
			amf.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		private function delListeners():void {
			amf.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						        CREATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	type
		 * @param	path      dossier de sauvegarde
		 * @param	nom
		 * @param	fileType
		 * @param	data
		 * @param	update
		 */
		public function save( url:String, path:String, fileName:String, fileType:String, data:ByteArray ):void 
		{
			_url = url;
			_path = path
			_fileName = fileName;
			_fileType = fileType;
			_data = data;
			
			/////////////////////////////////
			saveFile();
			/////////////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	  						 SAVE FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function saveFile():void 
		{	
			amf.call( new FileService().saveFile( _path + "/" + _fileName + "." + _fileType, _data ), requester );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	  						 SAVE FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * only work with Http or Https protocol
		 */
		public function downloadFile():void 
		{	
			downloader.download( new URLRequest ( _url+'/'+_path + "/" + _fileName + "." + _fileType ) );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        	   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void 
		{
			delListeners();
			amf.close();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent(evt:AmfphpClientEvent ):void 
		{
			var args:Object;
			if ( evt.requester == requester)
			{
				switch( evt.type )
				{
					case AmfphpClientEvent.ON_RESULT :
						///////////////////////////////////////////////////////////////
						args = { info:"file "+ _fileName +"saved" };
						eEvent = new FileSaverEvent( FileSaverEvent.ON_SAVE_COMLETE, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						dispose();
						break;
						
					case AmfphpClientEvent.ON_ERROR :
						///////////////////////////////////////////////////////////////
						args = { info:"problem with "+ _fileName +" file" };
						eEvent = new FileSaverEvent( FileSaverEvent.ON_ERROR, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						dispose();
						break;
				}
			}	
		}
	}	
}