/**
* 
* MVC Abstract Model
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import railk.as3.pattern.mvc.interfaces.IModel;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.data.objectList.ObjectList;
		
	public class AbstractModel implements IModel
	{
		protected var proxys:ObjectList = new ObjectList();
		
		public static function getInstance():AbstractModel 
		{
			return Singleton.getInstance(AbstractModel);
		}
		
		public function AbstractModel() 
		{ 
			Singleton.assertSingle(AbstractModel);
		}
		
		public function registerProxy( proxyClass:Class ):void
		{
			proxys.add([proxyClass.NAME,new proxyClass() ])
		}

		public function removeProxy( name:String ):void
		{
			proxys.remove(name);
		}
		
		public function hasProxy( name:String ):Boolean
		{
			( proxys.getObjectByName(name) )?true:false;
		}
	}
}