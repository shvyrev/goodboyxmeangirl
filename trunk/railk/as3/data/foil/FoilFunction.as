/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	
	public class FoilFunction
	{
		private var _data:Function;
		
		public function FoilFunction( data:String )
		{
			trace( data );
			/*var dataExplode:Array, content:Array;
			dataExplode = data.replace(/[ ]{0,}function[ ]{0,}/g, "").split('(){');
			content = dataExplode[1].replace(/[\)]/g, "").split(';');*/
			
			_data = new Function();
			/*for (var i:int = 0; i < content.length ; i++) 
			{
				trace( content[i] );
			}*/
		}
		
		public function get data():Function { return _data; }
	}
	
}