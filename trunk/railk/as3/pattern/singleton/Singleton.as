/**
* 
* Singleton pattern
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.singleton 
{	
	import flash.utils.Dictionary
	
	public class Singleton
	{
		private static var instance:*;
		private static var instances:Dictionary = new Dictionary();
		private static var allowInstantiation:Boolean = false;
		
		public static function getInstance(classe:Class):*
		{
			if ( instances[classe] == undefined )
			{
				allowInstantiation = true;
				instances[classe] = new classe();
				allowInstantiation = false;
			}	
			return instances[classe];
		}
		
		public static function assertSingle(classe:Class):void
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation of class "+classe+" failed: Use "+classe+".getInstance() instead of new.");
			}
		}
	}
}