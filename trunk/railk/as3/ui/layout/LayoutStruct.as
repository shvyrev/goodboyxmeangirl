/**
 * Layout Manager structure
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.data.parser.Parser;
	public class LayoutStruct
	{
		public var dataType:String;
		public var blocs:Array;
		
		public function LayoutStruct(data:String){
			this.blocs = parse( data );
		}

		private function parse(data:String):Array {
			return Parser.XMLItem( new XML( data) );
		}		
	}
}