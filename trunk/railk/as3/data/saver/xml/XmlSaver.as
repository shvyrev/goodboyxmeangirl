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
	import railk.as3.utils.Logger;
	
	

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
			Logger.print( "xmlSaver for " + name +" file launch", Logger.MESSAGE, 'XMLSAVER' );
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
				var ze:ZipEntry = new ZipEntry( "essai.xml" );
				zipFile.putNextEntry(ze);
				var fileData:ByteArray = new ByteArray();
				fileData.writeUTFBytes( "<?xml version='1.0' encoding='utf-8' ?>\n"+xml.toXMLString() );
				zipFile.write(fileData);
				zipFile.closeEntry();
				zipFile.finish();	
				
				AmfphpClient.call( new FileService().saveFile( _file, zipFile.byteArray ));
				
			}
			else 
			{
				AmfphpClient.call( new FileService().saveXml( _file, xml.toXMLString() ));
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
						///////////////////////////
						dispose();
						//////////////////////////
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
		private function dispose():void 
		{
			delListeners()
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
				
				var entry:String = _nodes[0].root;
				xmlFileList = xmlFile.children();
				idList = xmlFile.child(entry).child("id");
				dateList = xmlFile.child(entry).child("date");
				
				idElement = 'id';
				dateElement = "date";
				element = _nodes[0].root;
			}
			
			
			//--indexList + firstEntry
			var done:Boolean = false;
			for ( var l:int=0; l < xmlFileList.length(); l ++ ) {
				indexList[ xmlFileList[l].toXMLString() ] = l;
				if ( xmlFileList[l].name() == element && !done ){
					done = true;
					firstEntry = l-1;
					if ( firstEntry < 0 ) firstEntry = 0;
				}
			}
			
			//-- création du nouveau noeud
			for ( var i:Number = 0; i < _nodes.length; i++ ) {
			
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
				
				//--String to XML object
				tmpXml = new XML( tmpStr );
				
				//update de noeud preexistant ?
				var appended:Boolean = false;
				update:for ( var k:int=0; k <= idList.length(); k++ ) {
					var result:Object = hasSubChildrens( tmpXml, element );
					var oldDate:XMLList;
					
					if ( result != null ) {
						if ( result.children == 2 ) {
							var found:Object = getSubChildrens( idElement, idList[k], result.xml );
							if ( found.bool ) {
								if ( found.xml.child(dateElement) != dateList[k] ) {
									//on remplace la date pour retrouver l'index corespondant afin de supprimer l'enfant
									oldDate = found.xml.child(dateElement);
									found.xml.replace( dateElement, dateList[k]);
									delete xmlFileList[ indexList[ found.xml.toXMLString() ] ];
									
									//on remet la bonne date pour effceuer l'update et replace l'enfant updater en debut de liste
									found.xml.replace( dateElement, oldDate);
									appendList.push( found.xml );
									////////////////////////////////
									appended = true;
									updated = true;
									////////////////////////////////
									break update;
								}
							}	
						}
					}
				}
				
				//--si il n'y pas pas d'entrée deja existante on ajoute l'engtré a l'appendList
				if (result != null ){
					if ( result.children == 2 && !appended ) {
						appendList.push( found.xml );
						////////////////////////////////
						updated = true;
						////////////////////////////////
					}
				}	
			}
			
			//--fichier final
			if ( _nodes[0].root == 'rss' ) {
				header.children()[0].appendChild( xmlFileList );
				for ( l = 0; l < appendList.length; l++ ) {
					header.children()[0].insertChildAfter( header.children()[0].children()[firstEntry], appendList[l] );
				}
			}
			else {
				header.appendChild( xmlFileList );
				for ( l = 0; l < appendList.length; l++ ) {
					header.insertChildAfter( header.children()[firstEntry], appendList[l] );
				}
			}
			
			if( updated ) saveFile( header );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						CREATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createXmlFile():void 
		{
			var subtype:String;
			var tmpStr:String;
			
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
				
				if ( _nodes[0].root == 'rss' ) { xmlFile.children()[0].appendChild( tmpStr ); }
				else { xmlFile.appendChild( tmpStr ); }	
			}
			
			saveFile( xmlFile );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 REMOVE NAMESPACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function removeXmlNamespace( child:String ):XML {
			var result:XML;
			var xmlnsPattern:RegExp = new RegExp('xmlns[ a-zA-Z0-9é._%-/:"=]{1,}', '');
			result = new XML( child.replace(xmlnsPattern, '') );
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					HAS SUB CHILDRENS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function hasSubChildrens( child:XML, element:String ):Object 
		{
			var result:Object;
			if ( child.name() == element ) { 
			
				var nbChildrens:int = child.children().length();
				if ( nbChildrens > 1) {
					result = { children:2, xml:child };
				}
				else {
					if ( nbChildrens == 0 ) {
						result = { children:0, xml:child };
					}
					else {
						var childKind:String  = child.children()[0].nodeKind();
						if ( childKind == "element" ) { result = { children:2, xml:child }; }
						else { result = { children:1, xml:child }; }
					}	
				}
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					GET SUB CHILDRENS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getSubChildrens( elementName:String, elementValue:String, child:XML ):Object 
		{
			var result:Object={};
			if ( child.child(elementName) == elementValue ) {
				result.bool = true;
				result.xml = child;
			}
			else {
				result.bool = false;
				result.xml = child;
			}
			return result;
		}
		
	}	
}