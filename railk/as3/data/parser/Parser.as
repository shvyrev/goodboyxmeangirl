/**
* 
* xml parser class
* 
* @author richard rodney
* @version 0.2
*/

package railk.as3.data.parser {
	
	
	public class Parser {
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						    XMLPARSER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function XMLItem( xmlFile:XML ):Array {
			
			//--vars
			var result:Array = new Array();
			var nbNodes:Number = getNbChildrens( xmlFile );
			
			//xmlFile = removeXmlNamespace( xmlFile );
			
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
		private static function getChildrens( child:XML ):Object {
			var result:Object = {};
			var name:String;
			
			var attributes:Object = getAttributes( child ) ;
			var nbChildrens:int = getNbChildrens( child );
			if ( nbChildrens != 0) {
				for ( var i:int = 0; i < nbChildrens; i++ ) {
					var hasChildren:int = getSubChildrens( child.children()[i] );
					if ( hasChildren == 2 ) {
						name = String( child.children()[i].name() );
						result[name] = getChildrens( child.children()[i] );
					}
					else if ( hasChildren == 1 ) {
						name = String( child.children()[i].name() );
						result[name] = child.children()[i];
						result[name+"Att"] = getAttributes( child.children()[i] );
					}
					else if ( hasChildren == 0 ) {
						name = String( child.name() );
						result[name] = child;
					}
				}
				result["attributes"] = attributes;
			}
			else {
				if ( attributes != null) {
					name = String( child.name() );
					result[name] = attributes;
				}
				else {
					result = null;
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
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GA_XMLPARSER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function GA_XMLItem( xml:XML, type:String='GeoMap' ):Array {
			//--vars
			var nodes:Array = new Array();
			var nb_nodes:Number = xml.children()[0].children().length();
			var count:Number = 0;

			//création du tabelau contenant les informations xml triées
			for( var i:int=0; i<nb_nodes-1; i++ )
			{
				if ( xml.children()[0].children()[i].name() == "Region" ) {
					var itr =  xml.children()[0].children()[i].children().length();
					var location:Object = new Object();
					
					for( var j:int=0; j<itr-1; j++ )
					{
						var temp = String( xml.children()[0].children()[i].children()[j].name() );
						location[String(temp)] = xml.children()[0].children()[i].children()[j];
					}
					
					nodes[count] = location;
					count += 1;
				}
			}
			return nodes;
		}
		
	}
}

