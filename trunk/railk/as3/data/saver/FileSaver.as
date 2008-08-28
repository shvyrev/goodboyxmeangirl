/**
* 
* update and save data files
* 
* @author Richard Rodney.
* @version 0.1
*/

package railk.as3.data.saver {
	
	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.net.navigateToURL;
	
	// _______________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.saver.FileSaverEvent;	
	
	

	public class FileSaver extends EventDispatcher {
		
		
		//____________________________________________________________________________________ VARIABLES STATIQUES
		static private const saveFileLocal                :String = "php/saveFileLocal.php";
		static private const saveFileServer               :String = "php/saveFileServer.php";
		static private const checkFileUrl                 :String = "php/fileCheck.php";
		
		//____________________________________________________________________________________ VARIABLES RECUPERE
		private var _data                                 :ByteArray;
		private var _type                                 :String;
		private var _path                                 :String;
		private var _nom                                  :String;
		private var _fileType                             :String;
		
		//____________________________________________________________________________________ VARIABLES LOADER
		private var loader                                :URLLoader;
		private var req                                   :URLRequest;
		private var header                                :URLRequestHeader;
		private var rep                                   :String;
		private var vars                                  :URLVariables;
		
		//____________________________________________________________________________________ VARIABLES EVENEMENT
		private var eEvent                                :FileSaverEvent;
		private var message                               :String='';
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function FileSaver( name:String="undefined" ):void {
			trace( "fileSaver for "+ name +" file launch" );
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
		public function create( type:String, path:String, nom:String, fileType:String, data:ByteArray, update:Boolean = false ):void 
		{
			_type = type,
			_path = path
			_nom = nom;
			_fileType = fileType;
			_data = data;
			//check file if it exist
			if (update) {
				checkFile();
			}
			else {
				saveFile();
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   CHECK IF FILE EXIST
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function checkFile():void {
			loader = new URLLoader();
			req= new URLRequest( checkFileUrl );
			req.data = _path+"/"+_nom+"."+_fileType;
			req.method = URLRequestMethod.POST;
			req.contentType = 'text';
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, checkComplete, false, 0, true );
			loader.addEventListener(IOErrorEvent.IO_ERROR, checkError, false, 0, true );
			
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"checkingfile " + _nom };
			eEvent = new FileSaverEvent( FileSaverEvent.ONCHECKBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}

		private function checkComplete( evt:Event ):void 
		{
			rep = evt.currentTarget.data;
			///////////////////////////////////////////////////////////////
			var args:Object = { info:"checkfilecomplete " + rep };
			eEvent = new FileSaverEvent( FileSaverEvent.ONCHECKBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
			if ( rep == "true" ){
				message = 'overwrite'
			}
			else if ( rep == "false" ){
				message = '';
			}
			
			/////////////////////////////
			saveFile();
			////////////////////////////
			
			loader.removeEventListener(Event.COMPLETE, checkComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, checkError );
		}

		private function checkError( evt:IOErrorEvent ):void 
		{	
			loader.removeEventListener(Event.COMPLETE, checkComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, checkError );
			///////////////////////////////////////////////////////////////
			var args:Object = { info:evt };
			eEvent = new FileSaverEvent( FileSaverEvent.ONCHECKIOERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	  SAVE THE CREATED OR UPDATED FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function saveFile():void 
		{	
			loader = new URLLoader();
			if( _type == 'local' ){
				req = new URLRequest( saveFileLocal+"?nom="+_nom+"."+_fileType+"&filetype="+_fileType );
				header = new URLRequestHeader("Content-type", "application/octet-stream");
				req.requestHeaders.push( header );
				req.method = URLRequestMethod.POST;
				req.data = _data;
				navigateToURL( req );
			}
			else if ( _type == 'server' ){
				req = new URLRequest( saveFileServer + "?path=" + _path + "/" + _nom + "." + _fileType );
				header = new URLRequestHeader("Content-type", "application/octet-stream");
				req.requestHeaders.push( header );
				req.method = URLRequestMethod.POST;
				req.data = _data;
				loader.load( req );
				loader.addEventListener(Event.COMPLETE, saveComplete, false, 0, true );
				loader.addEventListener(IOErrorEvent.IO_ERROR, saveError, false, 0, true );
			}
			
			var args:Object;
			/////////////////////////////////////////////////////////////
			if ( message == '' ) args = { info:"saving file begin" };
			else if (message =='overwrite' ) args = { info:"overwrite file begin" };
			eEvent = new FileSaverEvent( FileSaverEvent.ONSAVEBEGIN, args );
			dispatchEvent( eEvent );
			/////////////////////////////////////////////////////////////
		}


		private function saveComplete( evt:Event ):void 
		{
			var rep = evt.currentTarget.data;
			var args:Object;
			
			loader.removeEventListener(Event.COMPLETE, saveComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, saveError );
			///////////////////////////////////////////////////////////////
			if ( message == '' ) args = { info:"saving file complete"+rep };
			else if (message =='overwrite' ) args = { info:"overwrite file complete"+rep };
			eEvent = new FileSaverEvent( FileSaverEvent.ONSAVECOMLETE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}

		private function saveError( evt:IOErrorEvent ):void 
		{
			var args:Object;
			
			loader.removeEventListener(Event.COMPLETE, saveComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, saveError );
			///////////////////////////////////////////////////////////////
			if ( message == '' ) args = { info:"save error" + evt.toString() };
			else if (message =='overwrite' ) args = { info:"overWrite error" + evt.toString() };
			eEvent = new FileSaverEvent( FileSaverEvent.ONSAVEIOERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		} 	
	}	
}