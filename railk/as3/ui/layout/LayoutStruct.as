/**
 * Layout Manager structure based on foil or xml file/string
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.data.serializer.foil.Foil;
	import railk.as3.data.parser.Parser;
	
	public class LayoutStruct
	{
		private var dataType:String;
		private var _blocs:Array;
				
		public function LayoutStruct( data:String ):void
		{
			dataType = getType( data );
			_blocs = parse( data, dataType );
		}
		
		private function getType( data:String ):String
		{
			
			return (data.charAt(0) == '{')?'foil':'xml';
		}
		
		private function parse(data:String, dataType:String):Array
		{
			var result:Array;
			switch(dataType)
			{
				case "xml":
					result = Parser.XMLItem( new XML( data) );
					break;
				
				case "foil":
					result = Foil.deserialize(data);
					break;
			}
			return result;
		}
		
		public function get blocs():Array { return _blocs; }
	}
	
}