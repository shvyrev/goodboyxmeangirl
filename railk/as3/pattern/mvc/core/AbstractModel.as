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
	import railk.as3.pattern.mvc.interfaces.IProxy;
	import railk.as3.pattern.multiton.Multiton;
		
	public class AbstractModel implements IModel
	{
		protected var MID:String;
		protected var proxys:Array=[];
		public static function getInstance(id:String):AbstractModel {
			return Multiton.getInstance(id,AbstractModel);
		}
		
		public function AbstractModel(id:String) { 
			MID = Multiton.assertSingle(id,AbstractModel);
		}
		
		public function registerProxy( proxyClass:Class, name:String='' ):void {
			proxys[proxys.length] = new proxyClass(MID,name);
		}

		public function removeProxy( name:String ):void {
			loop:for (var i:int = 0; i < proxys.length; i++) if ( proxys[i].name == name ) { proxys.splice(i, 1); break loop; }
		}
		
		public function getProxy( name:String ):IProxy {
			for (var i:int=0; i<proxys.length; ++i) if ( proxys[i].name == name ) return proxys[i];
			return null;
		}
		
		public function hasProxy( name:String ):Boolean {
			for (var i:int=0; i<proxys.length; ++i) if ( proxys[i].name == name ) return true;
			return false;
		}
	}
}