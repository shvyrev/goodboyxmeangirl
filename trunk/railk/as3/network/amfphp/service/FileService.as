/**
* Service for amfphp
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.network.amfphp.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class FileService implements IService
	{
		private var _filename                       :String;
		private var _loadType                       :String;
		private var _filetype                       :String;
		private var _path                           :String;
		private var _data                           :*;
		private var _type                           :String;
		
		public function FileService():void { }
		
		public function check( filename:String ):FileService
		{
			_type = 'check';
			_filename = filename;
			return this;
		}
		public function load( filename:String, loadType:String ):FileService
		{
			_type = 'load';
			_filename = filename;
			_loadType = loadType;
			return this;
		}
		public function dir( path:String ):FileService
		{
			_type = 'dir';
			_path = path;
			return this;
		}
		public function upload( filename:String, path:String ):FileService
		{
			_type = 'upload';
			_filename = filename;
			_path = path;
			return this;
		}
		public function saveXml( filename:String, data:XML ):FileService
		{
			_type = 'saveXml';
			_filename = filename;
			_data = data;
			return this;
		}
		public function saveLocal( filename:String, filetype:String, data:* ):FileService
		{
			_type = 'saveLocal';
			_filename = filename;
			_filetype = filetype;
			_data = data;
			return this;
		}
		public function saveFile( filename:String, data:* ):FileService
		{
			_type = 'saveServer';
			_filename = filename;
			_data = data;
			return this;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void 
		{
			switch( _type )
			{
				case 'dir' :
					connexion.call( 'File.'+_type, responder, _path);
					break;
				case 'check' :
					connexion.call( 'File.'+_type, responder, _filename );
					break;
				case 'load' :
					connexion.call( 'File.'+_type, responder, _filename, _loadType );
					break;
				case 'upload' :
					connexion.call( 'File.'+_type, responder, _filename, _path );
					break;
				case 'saveXml' :
					connexion.call( 'File.'+_type, responder, _filename, _data);
					break;
				case 'saveFile' :
					connexion.call( 'File.'+_type, responder, _filename, _data );
					break;	
			}	
		}
		
		public function get name():String { return _type; }
	}
	
}