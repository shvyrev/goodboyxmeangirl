/**
* 
* edit and save xml files
* 
* @author Richard Rodney.
* @version 0.2
* 
* usage : 
*  créer un objet avec type/requester/content { root:"rss", type:"image", attribute:{ nom:String(upload.fileName), url:"../images"+String(upload.fileName)}=null, content:*={type:"", content:""}string,null }
*  le premeier objet de content doit définir de façon unique l'objet.
*  les apellations dans content sont libres.
*/

package railk.as3.data.saver.xml {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	// ___________________________________________________________________________________________ IMPORT ZIP
	import nochump.util.zip.*;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.saver.xml.XmlSaverEvent;
	import railk.as3.network.amfphp.AmfphpClient;
	import railk.as3.network.amfphp.AmfphpClientEvent;
	import railk.as3.network.amfphp.service.FileService;
	import railk.as3.utils.ObjectDumper;
	import railk.as3.data.parser.Parser;
	

	public class XmlSaver extends EventDispatcher {
		
		//__________________________________________________________________________________ VARIABLES SERVICE
		private var service                               :FileService;
		private var requester                             :String = 'xmlSaver';
		
		//_________________________________________________________________________________ VARIABLES RECUPERE
		private var _name                                 :String;
		private var _nodes                                :Array;
		private var _file                                 :String;
		private var _zip                                  :Boolean;
		
		//_____________________________________________________________________________________ VARIABLES FILE
		private var xmlFile                               :XML;
		private var zipFile                               :ZipOutput;
		
		//_______________________________________________________________________________  VARIABLES EVENEMENT
		private var eEvent                                :XmlSaverEvent;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function XmlSaver( name:String = "undefined", server:String = '', path:String = '' ):void 
		{
			_name = name;
			AmfphpClient.init( server, path );
			
			////////////////////////////////////
			initListeners()
			////////////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				GESTION DES LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void {
			AmfphpClient.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			AmfphpClient.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		private function delListeners():void {
			AmfphpClient.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			AmfphpClient.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						        CREATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	update
		 * @param	zip
		 */
		public function create( file:String, nodes:Array, update:Boolean = false, zip:Boolean = false ):void 
		{
			_file = file;
			_nodes = nodes;
			_zip = zip;
			
			if (update) checkFile();
			else createXmlFile();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	CHECK FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function checkFile():void 
		{
			AmfphpClient.call( new FileService().check( _file ), requester );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	 LOAD FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function loadFile():void 
		{
			AmfphpClient.call( new FileService().load( _file, (_zip) ? 'binary' : 'xml' ), requester );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	 SAVE FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function saveFile( xml:XML ):void 
		{
			if (_zip)
			{
				zipFile = new ZipOutput();
				var ze:ZipEntry = new ZipEntry( _file );
				zipFile.putNextEntry(ze);
				var fileData:ByteArray = new ByteArray();
				fileData.writeUTFBytes( "<?xml version='1.0' encoding='utf-8' ?>\n"+xml.toXMLString() );
				zipFile.write(fileData);
				zipFile.closeEntry();
				zipFile.finish();	
				
				var zipName = _file.split('.')[0];
				AmfphpClient.call( new FileService().saveFile( zipName+'.zip', zipFile.byteArray ), requester);
			}
			else 
			{
				AmfphpClient.call( new FileService().saveXml( _file, xml.toXMLString() ), requester);
			}	
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	 PARSE ZIP
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function parseZip( data:ByteArray ):String {
			var loadedData:IDataInput = data ;
			var zipFile:ZipFile = new ZipFile(loadedData);
			var entry:ZipEntry = zipFile.entries[0];
			var data:ByteArray = zipFile.getInput(entry);
			return data.toString();
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
						switch( evt.service )
						{
							case 'check' :
								loadFile();
								///////////////////////////////////////////////////////////////
								args = { info:"problem checking file", data:evt.data };
								eEvent = new XmlSaverEvent( XmlSaverEvent.ON_CHECK_COMLETE, args );
								dispatchEvent( eEvent );
								///////////////////////////////////////////////////////////////
								break;
								
							case 'load' :
								if ( _zip ) xmlFile = new XML( parseZip( evt.data ) );
								else xmlFile = new XML( evt.data );
								
								updateXmlFile();
								///////////////////////////////////////////////////////////////
								args = { info:"load complete" };
								eEvent = new XmlSaverEvent( XmlSaverEvent.ON_LOAD_COMPLETE, args );
								dispatchEvent( eEvent );
								///////////////////////////////////////////////////////////////
								break;
							
							case 'saveXml' :
							case 'saveFile' :
								///////////////////////////////////////////////////////////////
								args = { info:"saving file complete "+evt.data };
								eEvent = new XmlSaverEvent( XmlSaverEvent.ON_SAVE_COMLETE, args );
								dispatchEvent( eEvent );
								///////////////////////////////////////////////////////////////
								break;
						}
						break;
						
					case AmfphpClientEvent.ON_ERROR :
						///////////////////////////////////////////////////////////////
						args = { info:"problem with "+ evt.service +" file" };
						eEvent = new XmlSaverEvent( XmlSaverEvent.ON_ERROR, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						break;
				}
			}	
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        	   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void 
		{
			delListeners()
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						CREATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createXmlFile():void 
		{
			var subtype:String;
			var tmpStr:String;
			XML.ignoreProcessingInstructions = false;
			
			//--root du fichier
			if ( _nodes[0].root == "rss" ) {
				tmpStr = "<rss version='2.0'></rss>";
				xmlFile = new XML( tmpStr );
				xmlFile.appendChild( "<channel></channel>" );
			}
			else if ( _nodes[0].root == "atom" ) {
				tmpStr = "<feed xmlns='http://www.w3.org/2005/Atom'></feed>";
				xmlFile = new XML( tmpStr );
			}
			else{
				tmpStr = "<" + _nodes[0].root + "></" + _nodes[0].root + ">";
				xmlFile = new XML( tmpStr );
			}
			
			
			//--noeuds
			for ( var i:int=0; i<_nodes.length; i++ ) {
				
				tmpStr = "<"+_nodes[i].type;
				
				if( _nodes[i].attribute != null ){
					for ( subtype in _nodes[i].attribute ) {
						tmpStr += " " + subtype + "='" + _nodes[i].attribute[subtype] + "' ";
					}
				}	
				
				
				if ( _nodes[i].content != null && _nodes[i].content is String ) {
					tmpStr += ">" + _nodes[i].content +"</" + _nodes[i].type +">";
				}
				else if ( _nodes[i].content != null && _nodes[i].content is Array ) {
										
					tmpStr += ">";
					for ( var j:int = 0; j <= _nodes[i].content.length-1; j++ ){
						tmpStr += "<"+_nodes[i].content[j].type;
						
						if ( _nodes[i].content[j].attribute != null ) {
							for ( subtype in _nodes[i].content[j].attribute ) {
								tmpStr += " " + subtype + "='" + _nodes[i].content[j].attribute[subtype] + "' ";
							}
						}
						
						tmpStr += ">"+_nodes[i].content[j].content+"</"+_nodes[i].content[j].type+">";
					}	
					tmpStr += "</" + _nodes[i].type +">";
					
				}
				else {
					tmpStr += "/>";
				}
				
				if ( _nodes[0].root == 'rss' ) { xmlFile.children()[0].appendChild( new XML(tmpStr) ); }
				else { xmlFile.appendChild( new XML(tmpStr) ); }	
			}
			
			saveFile( xmlFile );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        UPDATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function updateXmlFile():void 
		{
			var header:XML;
			var tmpStr:String;
			var tmpXml:XML;
			var subtype:String;
			var xmlFileList:XMLList;
			var idList:XMLList;
			var dateList:XMLList;
			var indexList:Object = {};
			var dateElement:String;
			var idElement:String;
			var element:String;
			var updated:Boolean = false;
			var firstEntry:int;
			var appendList:Array = new Array();
			
			//--small parsing
			if ( _nodes[0].root == 'rss' ) {
				tmpStr = "<rss version='2.0'></rss>";
				header = new XML( tmpStr );
				header.appendChild( "<channel></channel>" );
				
				xmlFileList = xmlFile.children().children();
				idList = xmlFile.children().child('item').child('guid');
				dateList = xmlFile.children().child('item').child('pubDate');
				
				idElement = 'guid';
				dateElement = "pubDate";
				element = 'item';
			}
			else if ( _nodes[0].root == 'atom' ) {
				tmpStr = "<feed xmlns='http://www.w3.org/2005/Atom'></feed>";
				header = new XML( tmpStr );
				
				//remove namespace
				xmlFile = removeXmlNamespace( xmlFile.toXMLString() );
				
				xmlFileList = xmlFile.children();
				idList = xmlFile.child('entry').child('id');
				dateList = xmlFile.child('entry').child('updated');
				
				idElement = 'id';
				dateElement = "updated";
				element = 'entry';
				
			}
			else {
				tmpStr = "<" + _nodes[0].root + "></" + _nodes[0].root + ">";
				header = new XML( tmpStr );
				
				
				/*var entry:String = _nodes[0].root;
				xmlFileList = xmlFile.children();
				idList = xmlFile.child(entry).child("id");
				dateList = xmlFile.child(entry).child("date");
				
				idElement = 'id';
				dateElement = "date";
				element = _nodes[0].root;*/
			}
			
			var actualXml:Array = parseToNode( xmlFile );
			for (var i:int = 0; i < actualXml.length; i++) 
			{
				trace( ObjectDumper.dump( actualXml[i] ) );
			}
			/*for (var j:int = 0; j < _nodes.length; j++) 
			{
				for (var i:int = 0; i < actualXml.length; i++) 
				{
					for ( var prop in actualXml[i] )
					{
						for (var k:int = 0; k < _nodes[i].content.length; k++) 
						{
							if ( _nodes[j].content[k].type == prop ) trace( prop );
						}
					}
				}
			}*/
			
			if( updated ) createXmlFile();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	PARSE TO NODE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function parseToNode( xmlFile:XML ):Array
		{
			var result:Array = new Array();
			var nbNodes:Number = getNbChildrens( xmlFile );			
			for ( var i:int = 0; i<nbNodes; i++ ) {
				result[i] = getChildrens( xmlFile.children()[i] );
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   GET NB CHILDREN OF A CHILD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getNbChildrens( child:XML ):int {
			var result:int;
			result = child.children().length();
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GET CHILDRENS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getChildrens( child:XML, sub:Boolean=false ):Object {
			var result:Object = { };
			var subResult:Object;
			var content:Array = new Array();
			
			if(!sub) result.root = child.name()+'s';
			result.type = String( child.name() );
			var attributes:Object = getAttributes( child ) ; 
			result.attribute = attributes;
			
			if ( child.children()[0] && (child.children()[0].nodeKind() == 'text' && !sub) )
			{
				result.content = String( child.children()[0] );
			}
			else
			{
				var nbChildrens:int = getNbChildrens( child );
				if ( nbChildrens != 0) {
					for ( var i:int = 0; i < nbChildrens; i++ ) 
					{
						var hasChildren:int = getSubChildrens( child.children()[i] );
						if ( hasChildren == 2 ) 
						{
							content.push( getChildrens( child.children()[i], true ) );
							result.content = content;
						}
						else if ( hasChildren == 1 ) 
						{
							subResult = new Object();
							subResult.type = String( child.children()[i].name() );
							subResult.content = String( child.children()[i] );
							subResult.attribute = getAttributes( child.children()[i] );
							content.push( subResult );
							if (nbChildrens > 1) result.content = content;
							else result.content = subResult;
						}
						else if ( hasChildren == 0 ) 
						{
							subResult = new Object();
							subResult.type = String( child.children()[i].name() );
							subResult.content = null;
							subResult.attribute = getAttributes( child.children()[i] );
							content.push( subResult );
							if (nbChildrens > 1) result.content = content;
							else result.content = subResult;
						}
					}
				}
				else 
				{
					result.content = null;
				}
			}	
			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					GET SUB CHILDRENS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getSubChildrens( child:XML ):int {
			var result:int;
			
			var nbChildrens:int = getNbChildrens( child );
			if ( nbChildrens > 1) {
				result = 2;
			}
			else {
				if ( nbChildrens == 0 ) {
					result = 0;
				}
				else {
					var childKind:String  = child.children()[0].nodeKind();
					if ( childKind == "element" ) { result = 2; }
					else { result = 1; }
				}	
			}
			return result;
		}	
				
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    GET NB ATTRIBUTES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getNbAttributes( child:XML ):int {
			var result:int;
			result = child.@*.length();
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	   GET ATTRIBUTES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getAttributes( child:XML ):Object {
			var result:Object = {};
			var name:String;
			
			var nbAttributes:int = getNbAttributes( child ); 
			if ( nbAttributes != 0 ) {
				for( var i:int=0; i<nbAttributes; i++ ){
					name= String(child.attributes()[i].name());
					result[name] = child.attributes()[i];
				}
			}
			else {
				result = null;
			}
			
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 REMOVE NAMESPACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function removeXmlNamespace( child:XML ):XML {
			var result:XML;
			var xmlnsPattern:RegExp = new RegExp('xmlns[ a-zA-Z0-9é._%-/:"=]{1,}', '');
			result = child.replace(xmlnsPattern, '');
			
			return result;
		}
		
	}	
}