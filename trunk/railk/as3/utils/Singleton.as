package railk.as3.utils {
	
	import flash.utils.Dictionary
	public class Singleton
	{
		private static var instance:*;
		private static var instances:Dictionary =new Dictionary();
		
		public static function getInstance(classe:Class):*
		{
			instances[classe] = true;
			instance = new classe();
			instances[classe] = false;
			return instance;
		}
		
		public static function assertSingle(classe:Class):void
		{
			if (!instances[classe]) {
				throw new Error("Error: Instantiation of class "+classe+" failed: Use "+classe+".getInstance() instead of new.");
			}
		}
	}
}