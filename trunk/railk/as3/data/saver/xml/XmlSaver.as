/**
* 
* edit and save xml files
* 
* @author Richard Rodney.
* @version 0.3
* 
* usage : 
*  créer un objet avec type/requester/content { root:"rss", type:"image", attribute:{ nom:String(upload.fileName), url:"../images"+String(upload.fileName)}=null, content:*={type:"", content:""}string,null }
*  le premeier objet de content doit définir de façon unique l'objet.
*  les apellations dans content sont libres.
* 
* TODO: UPDATEXMLFILE > make a better remove and modify fonction allowing more complex checking base on the whole node data.
* 		FIND A WAY TO GET THE ZIPFILE RIGHT VIA AMFPHP LOAD FOR NOW IT DOESNT WORK SO I USE URLLOADER THATS MAKE MORE CODE ><
* 
*/

package railk.as3.data.saver.xml {
	
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	// ___________________________________________________________________________________________ IMPORT ZIP
	import nochump.util.zip.*;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.saver.xml.XmlSaverEvent;
	import railk.as3.network.amfphp.AmfphpClient;
	import railk.as3.network.amfphp.AmfphpClientEvent;
	import railk.as3.network.amfphp.service.FileService;
	import railk.as3.data.parser.Parser;
	

	public class XmlSaver extends EventDispatcher {
		
		//__________________________________________________________________________________ VARIABLES SERVICE
		private var amf                                   :AmfphpClient;
		private var service                               :FileService;
		private var requester                             :String = 'xmlSaver';
		private var loader                                :URLLoader;
		
		//_________________________________________________________________________________ VARIABLES RECUPERE
		private var _name                                 :String;
		private var _nodes                                :Array;
		private var _file                                 :String;
		private var _zip                                  :Boolean;
		private var _updateType                           :String;
		
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
			amf = new AmfphpClient( server, path );
			
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
		// 																						     	MANAGE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * create a whole new xml file replacing the old one if it exist
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function create( file:String, nodes:Array, zip:Boolean = false ):void 
		{
			_file = file;
			_nodes = nodes;
			_zip = zip;
			createXmlFile();
		}
		
		/**
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function add( file:String, nodes:Array, zip:Boolean = false ):void 
		{
			_file = file;
			_nodes = nodes;
			_zip = zip;
			_updateType = 'add';
			checkFile();
		}
		
		/**
		 * remove based on id/content
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function remove( file:String, nodes:Array, zip:Boolean = false ):void 
		{
			_file = file;
			_nodes = nodes;
			_zip = zip;
			_updateType = 'remove';
			checkFile();
		}
		
		/**
		 * update comparison based on the id/date of each root node
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function update( file:String, nodes:Array, zip:Boolean = false ):void 
		{
			_file = file;
			_nodes = nodes;
			_zip = zip;
			_updateType = 'modify';
			checkFile();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	CHECK FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function checkFile():void 
		{
			var toCheck:String
			if ( _zip) toCheck = _file.split('.')[0] + '.zip';
			else toCheck = _file;
			amf.call( new FileService().check( toCheck ), requester );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	 LOAD FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function loadFile():void 
		{
			var toLoad:String
			//AmfphpClient.call( new FileService().load( toLoad, (_zip) ? 'binary' : 'xml' ), requester );
			if ( _zip) {
				toLoad = _file.split('.')[0] + '.zip';
				loader= new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadEvent, false, 0, true );
				loader.dataFormat = 'binary';
				loader.load(new URLRequest( toLoad ));
			}
			else
			{
				toLoad = _file;
				loader= new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadEvent, false, 0, true );
				loader.dataFormat = 'text';
				loader.load(new URLRequest( toLoad ));
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   		   	 SAVE FILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function saveFile( xml:XML ):void 
		{
			if (_zip)
			{
				var entryName = _file.split('/')[_file.split('/').length - 1];
				var zipName = _file.split('.')[0];
				zipFile = new ZipOutput();
				var ze:ZipEntry = new ZipEntry( entryName );
				zipFile.putNextEntry(ze);
				var fileData:ByteArray = new ByteArray();
				fileData.writeUTFBytes( "<?xml version='1.0' encoding='utf-8' ?>\n"+xml.toXMLString() );
				zipFile.write(fileData);
				zipFile.closeEntry();
				zipFile.finish();	
				
				amf.call( new FileService().saveFile( zipName+'.zip', zipFile.byteArray ), requester);
			}
			else 
			{
				amf.call( new FileService().saveXml( _file, xml.toXMLString() ), requester);
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
		private function manageEvent(evt:* ):void 
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
								if ( evt.data == true ) loadFile();
								else create(_file, _nodes, _zip);
								///////////////////////////////////////////////////////////////
								args = { info:"problem checking file", data:evt.data };
								eEvent = new XmlSaverEvent( XmlSaverEvent.ON_CHECK_COMLETE, args );
								dispatchEvent( eEvent );
								///////////////////////////////////////////////////////////////
								break;
								
							case 'load' :
								if ( _zip ) xmlFile = new XML( parseZip( evt.data as ByteArray ) );
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
								dispose();
								break;
						}
						break;
						
					case AmfphpClientEvent.ON_ERROR :
						///////////////////////////////////////////////////////////////
						args = { info:"problem with "+ evt.service +" file" };
						eEvent = new XmlSaverEvent( XmlSaverEvent.ON_ERROR, args );
						dispatchEvent( eEvent );
						///////////////////////////////////////////////////////////////
						dispose();
						break;
				}
			}	
		}
		
		private function loadEvent( evt:Event ):void {
			if ( _zip) xmlFile = new XML( parseZip( loader.data ) );
			else xmlFile = new XML( loader.data );
			updateXmlFile();
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        	   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void 
		{
			delListeners();
			amf.close();
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
					for ( var j:int = 0; j < _nodes[i].content.length; j++ ){
						tmpStr += "<"+_nodes[i].content[j].type;
						
						if ( _nodes[i].content[j].attribute != null ) {
							for ( subtype in _nodes[i].content[j].attribute ) {
								tmpStr += " " + subtype + "='" + _nodes[i].content[j].attribute[subtype] + "' ";
							}
						}
						
						tmpStr += subNode(_nodes[i].content[j].content, _nodes[i].content[j].type);
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
		// 																				CREATE XMLFILE SUBNODE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function subNode(node:*, type:String):String
		{
			var subtype:String;
			var tmpStr:String;
			
			if ( node != null && node is String ) {
					tmpStr = ">" + node +"</" + type +">";
			}
			else if ( node != null && node is Array ) {
									
				tmpStr = ">";
				for ( var i:int = 0; i < node.length; i++ ){
					tmpStr += "<"+node[i].type;
					
					if ( node[i].attribute != null ) {
						for ( subtype in node[i].attribute ) {
							tmpStr += " " + subtype + "='" + node[i].attribute[subtype] + "' ";
						}
					}
					
					tmpStr += subNode(node[i].content, node[i].type);
				}	
				tmpStr += "</" + type +">";
				
			}
			else {
				tmpStr = "/>";
			}
			
			return tmpStr;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        UPDATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function updateXmlFile():void 
		{
			var updated:Boolean = false;
			if ( _nodes[0].root == 'atom' ) xmlFile = removeXmlNamespace( xmlFile );
			else if ( _nodes[0].root == 'rss' ) xmlFile = rssToXml( xmlFile );
			
			var actualXML:Array = parseToNode( xmlFile );
			var newXML:Array = _nodes;
			var i:int, j:int = 0;
			
			
			switch( _updateType )
			{
				case 'add' :
					var nextID = actualXML.length + 1;
					for (i= 0; i < newXML.length; i++) 
					{
						actualXML.push( newXML[i] );
					}
					updated = true;
					_nodes = actualXML;
					break;
				
				case 'remove' :
					for (i= 0; i < newXML.length; i++) 
					{
						for (j = 0; j < actualXML.length ; j++) 
						{
							if ( newXML[i].content[0].content == actualXML[j].content[0].content )
							{
								actualXML.splice(j, 1);
								updated = true;
							}
						}
					}
					_nodes = actualXML;
					break;
					
				case 'modify' :
					if ( _nodes[0].root == 'atom')
					{
						for (i=0; i < 5; i++) 
						{
							actualXML[i].root = 'atom';
						}
						for (i=5; i < newXML.length; i++) 
						{
							for (j = 5; j < actualXML.length ; j++) 
							{
								if ( newXML[i].content[2].content != actualXML[j].content[2].content )
								{
									actualXML[j] = newXML[i];
									updated = true;
								}
							}
						}
						if (updated) actualXML[2].content = newXML[2].content;
					}
					else if ( _nodes[0].root == 'rss')
					{
						for (i=0; i < 5; i++) 
						{
							actualXML[i].root = 'rss';
							if ( i == 4 )
							{
								actualXML[i].attribute['xmlns:atom'] = 'http://www.w3.org/2005/Atom';
								actualXML[i].type = 'atom:link';
							}
						}
						for (i= 5; i < newXML.length; i++) 
						{
							for (j = 5; j < actualXML.length ; j++) 
							{
								if ( newXML[i].content[1].content != actualXML[j].content[1].content )
								{
									actualXML[j] = newXML[i];
									updated = true;
								}
							}
						}
					}
					else
					{
						for (i= 0; i < newXML.length; i++) 
						{
							for (j = 0; j < actualXML.length ; j++) 
							{
								if ( newXML[i].content[0].content != actualXML[j].content[0].content )
								{
									actualXML[j] = newXML[i];
									updated = true;
								}
							}
						}
					}	
					_nodes = actualXML;
					break;	
			}
			
			if ( updated ) createXmlFile();
			else dispose();
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
			var xmlnsPattern:RegExp = new RegExp('xmlns[a-zA-Z0-9é._%-/:"=]{1,}', '');
			result = new XML( child.toString().replace(xmlnsPattern, '') );
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	   RSS TO XML
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function rssToXml( child:XML ):XML {
			var result:XML;
			result = child.children()[0];
			return result;
		}
		
	}	
}