/**
* 
* edit and save xml files
* 
* 
* @author Richard Rodney.
* @version 0.2
* 
* usage : 
*  créer un objet avec type/requester/content { root:"rss", type:"image", attribute:{ nom:String(upload.fileName), url:"../images"+String(upload.fileName)}=null, content:*={type:"", content:""}string,null }
*  le premeier objet de content doit définir de façon unique l'objet.
*  les apellations dans content sont libres.
* 
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
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	// __________________________________________________________________________________________ IMPORT ZIP
	import nochump.util.zip.*;
	
	// _______________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.saver.XmlSaverEvent;	
	
	

	public class XmlSaver extends EventDispatcher {
		
		
		//____________________________________________________________________________________ VARIABLES STATIQUES
		static private const saveXmlURL                   :String = "php/saveXML.php";
		static private const saveZipURL                   :String = "php/saveFileServer.php";
		static private const checkXmlUrl                  :String = "php/fileCheck.php";
		
		//____________________________________________________________________________________ VARIABLES RECUPERE
		private var _name                                 :String;
		private var _nodes                                :Array;
		private var _file                                 :String;
		private var _zip                                  :Boolean;
		
		//____________________________________________________________________________________ VARIABLES XML
		private var xmlFile                               :XML;
		
		//____________________________________________________________________________________ VARIABLES ZIP
		private var zipFile                               :ZipOutput;
		
		//____________________________________________________________________________________ VARIABLES LOADER
		private var loader                                :URLLoader;
		private var req                                   :URLRequest;
		private var header                                :URLRequestHeader;
		private var rep                                   :String;
		private var vars                                  :URLVariables;
		
		//____________________________________________________________________________________ VARIABLES EVENEMENT
		private var eEvent                                :XmlSaverEvent;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function XmlSaver( name:String="undefined" ):void {
			trace( "xmlSaver for " + name +" file launch" );
			_name = name;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						        CREATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	file
		 * @param	nodes
		 */
		public function create( file:String, nodes:Array, update:Boolean=false, zip:Boolean=false ):void {
			//--vars
			_file = file;
			_nodes = nodes;
			_zip = zip;
			
			
			//--check file if it exist
			if (update) {
				checkFile();
			}
			else {
				createXmlFile();
			}
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   CHECK IF FILE EXIST
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function checkFile():void {
			loader = new URLLoader();
			req= new URLRequest( checkXmlUrl );
			req.data = _file;
			req.method = URLRequestMethod.POST;
			req.contentType = "text";
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, checkComplete, false, 0, true );
			loader.addEventListener(IOErrorEvent.IO_ERROR, checkError, false, 0, true );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"checkingfile " + _file };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONCHECKBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}

		private function checkComplete( evt:Event ):void {
			
			rep = evt.currentTarget.data;
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"checkfilecomplete " + rep };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONCHECKBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
			if( rep == "true" ){
				loadXmlFile();
			}
			else if( rep == "false" ){
				createXmlFile();
			}
			
			loader.removeEventListener(Event.COMPLETE, checkComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, checkError );
		}

		private function checkError( evt:IOErrorEvent ):void {
			
			loader.removeEventListener(Event.COMPLETE, checkComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, checkError );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:evt };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONCHECKIOERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 LOAD EXISTING XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function loadXmlFile():void {
			loader = new URLLoader();
			loader.addEventListener(Event.OPEN, loadBegin, false, 0, true );
			loader.addEventListener(Event.COMPLETE, loadComplete, false, 0, true );
			loader.addEventListener(ProgressEvent.PROGRESS, loadProgress, false, 0, true );
			loader.load(new URLRequest( _file ));
			
		}
		
		
		
		private function loadBegin( evt:Event ):void {
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"chargement commence" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONLOADBEGIN, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function loadProgress( evt:ProgressEvent ):void {
			//calcul du pourcentage d'avancement
			var percent:Number = Math.floor(evt.bytesLoaded * 100 / evt.bytesTotal);
				
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:percent };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONLOADPROGRESS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		private function loadComplete( evt:Event ):void {
			
			//recupération du fichier xml
			xmlFile = new XML( loader.data );
			//on lance l'update
			updateXmlFile();
		
			loader.removeEventListener(Event.OPEN, loadBegin );
			loader.removeEventListener(Event.COMPLETE, loadComplete );
			loader.removeEventListener(ProgressEvent.PROGRESS, loadProgress );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"transfert complete" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONLOADPROGRESS, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        UPDATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function updateXmlFile():void {
			//--init
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
			
			
			//indexList + firstEntry
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
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"update xmlfile begin" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONUPDATE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////

			//lancement de la sauvegarde si updater oui ou non
			if( updated ){
				saveXmlFile( header );
			}	
			
			
		}
		
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						CREATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createXmlFile():void {
			//
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
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"create xml file begin " + xmlFile};
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONCREATE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
			
			//lancement de la sauvegarde
			saveXmlFile( xmlFile );
		}

		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	  SAVE THE CREATED OR UPDATED FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function saveXmlFile( xml:XML ):void {
			
			//--prepare zip id needed
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
				
				loader = new URLLoader();
				req = new URLRequest ( saveZipURL+"?path=../"+ _name+".flow" );
				header = new URLRequestHeader("Content-type", "application/octet-stream");
				req.requestHeaders.push( header );
				req.method = URLRequestMethod.POST;
				req.data = zipFile.byteArray;
				loader.load( req );
				loader.addEventListener(Event.COMPLETE, saveComplete, false, 0, true );
				loader.addEventListener(IOErrorEvent.IO_ERROR, saveError, false, 0, true );
			}
			else {
				loader = new URLLoader();
				req = new URLRequest( saveXmlURL );
				req.method = URLRequestMethod.POST;
				vars = new URLVariables();
				vars.nom = _file;
				vars.xml = xml.toXMLString();
				req.data = vars;
				loader.load( req );
				loader.addEventListener(Event.COMPLETE, saveComplete, false, 0, true );
				loader.addEventListener(IOErrorEvent.IO_ERROR, saveError, false, 0, true );
			}	
			
			/////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"saving xml file begin" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONSAVEBEGIN, args );
			dispatchEvent( eEvent );
			/////////////////////////////////////////////////////////////
		
		}


		private function saveComplete( evt:Event ):void {
			var rep = evt.currentTarget.data;
			
			loader.removeEventListener(Event.COMPLETE, saveComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, saveError );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"saving xml file complete "+rep };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONSAVECOMLETE, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
		}

		private function saveError( evt:IOErrorEvent ):void {
			
			loader.removeEventListener(Event.COMPLETE, saveComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, saveError );
			
			///////////////////////////////////////////////////////////////
			//arguments du messages
			var args:Object = { info:"error " + evt.toString() };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new XmlSaverEvent( XmlSaverEvent.ONSAVEIOERROR, args );
			dispatchEvent( eEvent );
			///////////////////////////////////////////////////////////////
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
		private static function hasSubChildrens( child:XML, element:String ):Object {
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
		private function getSubChildrens( elementName:String, elementValue:String, child:XML ):Object {
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