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
	
	public class Classs
	{
		static private var classes:Dictionary = new Dictionary(true);
		static public function register(...args):void {
			for (var i:int = 0; i < args.length; ++i) classes[getQualifiedClassName(args[i]).split('::')[1]] = args[i];
		}
		
		static public function getInstance(name:String):* {
			var instance:*;
			try { instance = new (classes[name] as Class) }
			catch (e:Error) {
				try { instance = classes[name].getInstance.apply() }
				catch (e:Error){ instance = classes[name].getInstance.apply(null,[name]) }
			}
			return (classes[name] != undefined)?instance:null;
		}
	}	
}