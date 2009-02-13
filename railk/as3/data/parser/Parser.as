/**
* 
* xml parser class
* 
* @author richard rodney
* @version 0.2
*/

package railk.as3.data.parser {
	
	
	public class Parser {
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						    XMLPARSER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function XMLItem( xmlFile:XML ):Array 
		{
			var result:Array = new Array();
			var nbNodes:Number = getNbChildrens( xmlFile );
			for ( var i:int = 0; i<nbNodes; i++ ) {
				result[i] = getChildrens( xmlFile.children()[i] );
			}
			return result;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																		   GET NB CHILDREN OF A CHILD
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function getNbChildrens( child:XML ):int {
			var result:int;
			result = child.children().length();
			return result;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						GET CHILDRENS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function getChildrens( child:XML ):Object {
			var result:Object = { };
			var name:String;
			
			var attributes:Object = getAttributes( child ) ;
			var nbChildrens:int = getNbChildrens( child );
			if ( nbChildrens != 0) 
			{
				for ( var i:int = 0; i < nbChildrens; i++ ) 
				{
					var hasChildren:int = getSubChildrens( child.children()[i] );
					if ( hasChildren == 2 ) 
					{
						name = String( child.children()[i].name() );
						result[name] = getChildrens( child.children()[i] );
					}
					else if ( hasChildren == 1 ) 
					{
						name = String( child.children()[i].name() );
						if( result[name] ) result[name] += ','+child.children()[i];
						else result[name] = child.children()[i];
						var subAttributes:Object = getAttributes( child.children()[i] );
						if ( subAttributes ) result[name + "_attributes"] = subAttributes;
					}
					else if ( hasChildren == 0 ) 
					{
						name = String( child.children()[i].name() );
						result[name] = getAttributes( child.children()[i] );
					}
				}
				if(attributes) result["attributes"] = attributes;
			}
			else 
			{
				if ( attributes != null) 
				{
					name = String( child.name() );
					result[name] = attributes;
				}
				else {
					result = null;
				}	
			}
			return result;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																					GET SUB CHILDRENS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
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
				
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				    GET NB ATTRIBUTES
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function getNbAttributes( child:XML ):int {
			var result:int;
			result = child.@*.length();
			return result;
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				  	   GET ATTRIBUTES
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
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
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																					 REMOVE NAMESPACE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		private static function removeXmlNamespace( child:XML ):XML {
			var result:XML;
			var xmlnsPattern:RegExp = new RegExp('xmlns[ a-zA-Z0-9�._%-/:"=]{1,}', '');
			result = child.replace(xmlnsPattern, '');
			
			return result;
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 GA_XMLPARSER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function GA_XMLItem( xml:XML, type:String = 'GeoMap' ):Array 
		{
			var nodes:Array = new Array();
			var nb_nodes:Number = xml.children()[0].children().length();
			var count:Number = 0;

			//cr饌tion du tabelau contenant les informations xml tri馥s
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