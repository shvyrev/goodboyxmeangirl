/**
* Service for amfphp
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.amfphp.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	import railk.as3.net.amfphp.AmfphpClient;
	
	public class FileService implements IService
	{
		private var path                            :String
		private var _filename                       :String;
		private var _loadType                       :String;
		private var _filetype                       :String;
		private var _path                           :String;
		private var _data                           :*;
		private var _type                           :String;
		private var _url                            :Boolean;
		
		public function FileService() { 
			path = AmfphpClient.rootPath; 
		}
		
		public function check( filename:String ):FileService {
			_type = 'check';
			if (isUrl(filename)) {
				_filename = unescape(filename);
				_url = true;
			}
			else _filename = path + filename;
			return this;
		}
		
		public function load( filename:String, loadType:String ):FileService {
			_type = 'load';
			if (isUrl(filename)) _filename = unescape(filename);
			else _filename = path + filename;
			_loadType = loadType;
			return this;
		}
		public function dir( path:String ):FileService
		{
			_type = 'dir';
			if (isUrl(path)) return null;
			else _path = this.path+path;
			return this;
		}
		
		public function saveXml( filename:String, data:String ):FileService {
			_type = 'saveXml';
			if (isUrl(filename)) _filename = unescape(filename);
			else _filename = path+filename
			_data = data;
			return this;
		}
		
		public function saveFile( filename:String, data:* ):FileService {
			_type = 'saveFile';
			if (isUrl(filename)) _filename = unescape(filename);
			else _filename = path+filename
			_data = data;
			return this;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			switch( _type ) {
				case 'dir' : connexion.call( 'File.'+_type, responder, _path); break;
				case 'check' : connexion.call( 'File.'+_type, responder, _filename, _url ); break;
				case 'load' : connexion.call( 'File.'+_type, responder, _filename, _loadType ); break;
				case 'upload' : connexion.call( 'File.'+_type, responder, _filename, _path ); break;
				case 'saveXml' : connexion.call( 'File.'+_type, responder, _filename, _data); break;
				case 'saveFile' : connexion.call( 'File.'+_type, responder, _filename, _data ); break;	
			}	
		}
		
		private function isUrl(filename:String):Boolean {
            filename = filename.toLowerCase();
            var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/; 
            var result:Object = pattern.exec(filename);
            if(result == null) return false;
            return true;
		}
		
		public function get name():String { return _type; }
	}
}