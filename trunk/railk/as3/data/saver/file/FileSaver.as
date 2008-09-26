/**
* 
* update and save data files
* 
* @author Richard Rodney.
* @version 0.2
*/

package railk.as3.data.saver.file {
	
	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	// _______________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.saver.FileSaverEvent;
	import railk.as3.network.amfphp.*;
	import railk.as3.network.amfphp.service.FileService;
	import railk.as3.utils.Logger;
	
	
	public class FileSaver extends EventDispatcher {
		
		//____________________________________________________________________________________ VARIABLES RECUPERE
		private var _name                                 :String;
		private var _data                                 :ByteArray;
		private var _type                                 :String;
		private var _path                                 :String;
		private var _fileName                             :String;
		private var _fileType                             :String;
		
		//______________________________________________________________________________________________ VARIABLES
		private var downloader                            :FileReference;
		private var requester                             :String = 'fileSaver';
		
		//____________________________________________________________________________________ VARIABLES EVENEMENT
		private var eEvent                                :FileSaverEvent;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						  CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function FileSaver( name:String = 'undefined', server:String = '', path:String = '' )
		{
			_name = name;
			Logger.print( "FileSaver for " + name +" file launch", Logger.MESSAGE, 'FILESAVER' );
			AmfphpClient.init( server, path );
			downloader = new FileReference();
			
			////////////////////////////////////
			initListeners()
			////////////////////////////////////
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				GESTION DES LISTENERS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function initListeners():void {
			AmfphpClient.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			AmfphpClient.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		private static function delListeners():void {
			AmfphpClient.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			AmfphpClient.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																						        CREATE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		/**
		 * 
		 * @param	type
		 * @param	path      dossier de sauvegarde
		 * @param	nom
		 * @param	fileType
		 * @param	data
		 * @param	update
		 */
		public function create( path:String, fileName:String, fileType:String, data:ByteArray ):void 
		{
			_path = path
			_fileName = fileName;
			_fileType = fileType;
			_data = data;
			
			/////////////////////////////////
			saveFile();
			/////////////////////////////////
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	  						 SAVE FILE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function saveFile():void 
		{	
			AmfphpClient.call( new FileService().saveFile( _path + "/" + _nom + "." + _fileType, _data );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																	  						 SAVE FILE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function downloadFile():void 
		{	
			downloader.download( new URLRequest ( _path + "/" + _nom + "." + _fileType ) );
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		// 																				        	   DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function dispose():void 
		{
			delListeners()
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private function manageEvent(evt:AmfphpClientEvent ):void 
		{
			var args:Object;
			if ( evt.requester == requester)
			{
				switch( evt.type )
				{
					case AmfphpClientEvent.ON_RESULT :
						///////////////////////////////////////////////////////////////
						args = { info:"file "+ _nom +"saved" };
						eEvent = new FileSaverEvent( FileSaverEvent.ON_SAVE_COMLETE, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						dispose();
						break;
						
					case AmfphpClientEvent.ON_ERROR :
						///////////////////////////////////////////////////////////////
						args = { info:"problem with "+ _nom +" file" };
						eEvent = new FileSaverEvent( FileSaverEvent.ON_ERROR, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						break;
				}
			}	
		}
	}	
}