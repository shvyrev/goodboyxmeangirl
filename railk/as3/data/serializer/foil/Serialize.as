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
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GET INSTANCE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function getInstance():Serialize 
		{
			return Singleton.getInstance(Deserialize);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	SINGLETON
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Serialize() { Singleton.assertSingle(Serialize); }
		
	}
}	