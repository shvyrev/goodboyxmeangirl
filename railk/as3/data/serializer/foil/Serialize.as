/**
 * Serialize
 * 
 * @author Richard Rodney
 * @version 0.1
 */


package railk.as3.data.serializer.foil
{
	import railk.as3.utils.Singleton;
	
	public class Serialize
	{
		//_________________________________________________________________________________________ INSTANCE
		private static var inst:Serialize;
		
		//________________________________________________________________________________________ VARIABLES
		public var type:String;
		public var name:String;
		public var info:String;
		
		private var rawData:String;
		private var toParse:String;
		private var pos:int = 0;
		
		private var root:TreeNode;
		private var node:TreeNode;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 GET INSTANCE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public static function getInstance():Serialize 
		{
			return Singleton.getInstance(Deserialize);
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 	SINGLETON
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function Serialize() { Singleton.assertSingle(Serialize); }
		
	}
}	