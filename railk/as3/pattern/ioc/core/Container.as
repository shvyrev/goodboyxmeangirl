/**
 * 
 * Light Container
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.pattern.ioc.core
{
	import railk.as3.pattern.singleton.Singleton
	
	public class Container
	{
		public static function getInstance():Container 
		{
			return Singleton.getInstance(Container);
		}
		
		public function Container() 
		{ 
			Singleton.assertSingle(Container);
		}
		
		public function register():void
		{
			
		}
	}
	
}