/**
* 
* Processs factory
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.tween.process
{
	import railk.as3.tween.process.Process;
	import railk.as3.utils.objectPool.ObjectPoolFactory;
	public class ProcessFactory implements ObjectPoolFactory 
	{
		public function initObject( object:*, ...args ):void 
		{
			object.setProperties( args );
		}
	}
	
}