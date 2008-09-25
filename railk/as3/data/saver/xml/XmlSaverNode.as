/**
 * XML saver nodes
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.saver.xml
{
	public class XmlSaverNode
	{
		public var name:String;
		public var root:String;
		public var type:String;
		public var attributes:Object;
		public var content:*;
		
		public  function XmlSaverNode( name:String, root:String, type:String, attributes:Object, content:*= null):void 
		{
			this.name = name;
			this.root = root;
			this.type = type;
			this.attributes = attributes;
			this.content = content;
		}
		
		public function addContent( type:String, attributes:Object, content:String )
		{
			this.content = new Array();
			this.content.push( { type:type, attributes:attributes, content:content } );
		}
		
		public function toString():String 
		{
			return '[ XmlSaverNode >'+this.name+' ]'
		}
	}	
}