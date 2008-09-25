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
		private var _nodes:Dictionary;
		
		public function XmlSaverNodes() 
		{
			_nodes  = new Dictionary();
		}
		
		public function add( name:String, root:String, type:String, attributes:Object = null, content:*= null):XmlSaverNode 
		{
			var node:XmlSaverNode = new XmlSaverNode( name, root, type, attributes, content );
			_nodes[name] = node;
			return node;
		}
		
		public function get nodes():Array 
		{
			var a:Array = new Array();
			for each (var value:Object in _nodes)
			{
				a.push(value);
			}
			return a;
		}
		
		public function empty():void 
		{
			for each (var value:Object in _nodes)
			{
				value = null;
			}
		}
		
		public function toString():String 
		{
			var result:String ='';
			for each (var value:Object in _nodes)
			{
				result += value + '\n';
			}
			return result;
		}
	}	
}