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
		private var _filetype                       :String;
		private var _path                           :String;
		private var _data                           :*;
		private var _type                           :String;
		
		public function FileService():void { }
		
		public function check( filename:String ):void
		{
			_type = 'check';
			_filename = filename;
		}
		public function dir( path:String ):void
		{
			_type = 'dir';
			_path = path;
		}
		public function upload( filename:String, path:String ):void
		{
			_type = 'upload';
			_filename = filename;
			_path = path;
		}
		public function saveXml( filename:String, data:XML ):void
		{
			_type = 'saveXml';
			_filename = filename;
			_data = data;
		}
		public function saveLocal( filename:String, filetype:String, data:* ):void
		{
			_type = 'saveLocal';
			_filename = filename;
			_filetype = filetype;
			_data = data;
		}
		public function saveServer( filename:String, data:* ):void
		{
			_type = 'saveServer';
			_filename = filename;
			_data = data;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			switch( _type )
			{
				case 'dir' :
					connexion.call( 'File.'+_type, responder, _path);
					break;
				case 'check' :
					connexion.call( 'File.'+_type, responder, _filename );
					break;
				case 'upload' :
					connexion.call( 'File.'+_type, responder, _filename, _path );
					break;
				case 'saveXml' :
					connexion.call( 'File.'+_type, responder, _filename, _data);
					break;
				case 'saveLocal' :
					connexion.call( 'File.'+_type, responder, _filename, _filetype, _data );
					break;
				case 'saveServer' :
					connexion.call( 'File.'+_type, responder, _filename, _data );
					break;	
			}	
		}
	}
	
}