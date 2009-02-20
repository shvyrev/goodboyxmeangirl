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
	import railk.as3.data.pool.PoolFactory;
	public class ProcessPoolFactory implements PoolFactory 
	{
		public function initObject( object:*, ...args ):void 
		{
			object.setProperties( args );
		}
	}
	
}