/**
 * 
 * RTween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{	
	public interface IRTween
	{
		function start():void;
		function pause():void;
		function dispose():void;
		function get proxy():Object;
	}
}	