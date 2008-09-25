package railk.as3.utils {
	
	import flash.utils.Dictionary
	public class Singleton
	{
		private static var instance:*;
		private static var instances:Dictionary =new Dictionary();
		
		public static function getInstance(clazz:Class):*
		{
			instances[clazz] = true;
			instance = new clazz();
			instances[clazz] = false;
			return instance;
		}
		
		public static function assertSingle(clazz:Class):void
		{
			if (!instances[clazz]) {
				throw new Error("Error: Instantiation of class "+clazz+" failed: Use "+clazz+".getInstance() instead of new.");
			}
		}
	}
}