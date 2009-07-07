/**
 * ClassManager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class ClassManager 
	{
		static private var classes:Dictionary = new Dictionary(true);
		static public function register(...args):void {
			for (var i:int = 0; i < args.length; ++i) classes[getQualifiedClassName(args[i]).split('::')[1]] = args[i];
		}
		
		static public function get(name:String):Class {
			return (classes[name] != undefined)?classes[name]:null;
		}
	}	
}