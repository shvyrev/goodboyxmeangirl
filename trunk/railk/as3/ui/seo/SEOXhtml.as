/**
 * SEO
 * 
 * @author Richard Rodney
 * @version 0.1
 */


package railk.as3.ui.seo
{
	public class SEOXhtml
	{	
		private var _copy:Object;
		
		public function SEOXhtml() {
			super();
		}
		public function get copy():Object
		{
			return _copy;
		}
		override protected function onComplete(event:Event):void
		{
			super.onComplete(event);
			parseCopy();
		}
		private function parseCopy():void
		{
			_copy = {}; 
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			default xml namespace = new Namespace("http://www.w3.org/1999/xhtml");
			var html:XML = XML(_data);
			var copyTags:XMLList = html..div.(hasOwnProperty("@id") && @id == "copy")..p;
			var copyTag:XML;
			
			_copy.innerHTML = XMLList(html..div.(hasOwnProperty("@id") && @id == "copy").toXMLString().replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, ""))[0];
			
			for each (copyTag in copyTags)
			{
				var str:String = "";
				var len:int = copyTag.children().length();
				for (var i:int = 0; i < len; i++)
				{
					str += copyTag.children()[i].toXMLString();
				}
				_copy[copyTag.@id] = str.replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, "");
			}
		}
		override public function toString():String
		{
			return "[SEOAsset] " + _id;
		}
	}
}