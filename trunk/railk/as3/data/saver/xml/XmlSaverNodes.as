/**
 * XML saver nodes
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.saver.xml
{
	import flash.utils.Dictionary;
	
	public class XmlSaverNodes
	{
		private static var _nodes:Dictionary = new Dictionary();
		
		public static function add( name:String, root:String, type:String, attributes:Object = null, content:*= null):XmlSaverNode 
		{
			var node:XmlSaverNode = new XmlSaverNode( root, type, attributes, content );
			_nodes[name] = node;
			return node;
		}
		
		public static function nodes():Array 
		{
			var a:Array = new Array();
			for each (var value:Object in _nodes)
			{
				a.push(value);
			}
			return a;
		}
		
		public static function empty():void 
		{
			for each (var value:Object in _nodes)
			{
				value = null;
			}
		}
	}	
}