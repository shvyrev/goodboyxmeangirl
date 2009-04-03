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
		
	public class AbstractModel implements IModel
	{
		protected var proxys:Array=[];
		public static function getInstance():AbstractModel {
			return Singleton.getInstance(AbstractModel);
		}
		
		public function AbstractModel() { 
			Singleton.assertSingle(AbstractModel);
		}
		
		public function registerProxy( proxyClass:Class ):void {
			proxys[proxys.length] = proxyClass;
		}

		public function removeProxy( name:String ):void {
			loop:for (var i:int = 0; i < proxys.length; i++) {
				if ( proxys[i].NAME = name ) {
					proxys.splice(i, 1);
					break loop;
				}
			}
		}
		
		public function hasProxy( name:String ):Boolean {
			for (var i:int=0; i<proxys.length; ++i) if ( proxys[i].NAME = name ) return true;
			return false
		}
	}
}