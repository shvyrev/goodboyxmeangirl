/**
 * XML saver nodes
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.saver.xml
{
	public class XmlSaverNodes extends Array
	{
		public static function add( root:String, type:String, attributes:String, content:Array):void {
			this.push();
		}
	}	
}