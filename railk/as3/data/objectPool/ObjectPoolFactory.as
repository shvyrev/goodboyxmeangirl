/**
* 
* Object Pool factory Class
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.objectPool {
	
	public interface ObjectPoolFactory
	{
		function initObject( object:*, ...args ):void;
	}
}