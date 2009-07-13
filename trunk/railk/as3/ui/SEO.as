/**
 * SEO
 * 
 * @author Richard Rodney
 * @version 0.1
 */


package railk.as3.ui
{
	import flash.external.ExternalInterface;
	public class SEO
	{	
		private static const FUNCTION_SETCONTENT:String = 
		"document.insertScript = function ()" +
		"{ " +
			"if (document.seo_setContent==null)" +
			"{" +
				"seo_setContent = function (id,content)" +
				"{" +
					"document.getElementById(id).innerHtml = content"+
				"}" +
			"}" +
		"}";
		
		public static function init():void {
			ExternalInterface.call(FUNCTION_SETCONTENT);
		}
			
		public static function setNav(data:Array):void {
			var content:String="";
			for (var i:int = 0; i < data.length; i++) content += '<li><a href="'+data[i].link+'">'+data[i].name+'</a></li>';
			ExternalInterface.call('seo_setContent', 'sitenav', content);
		}
		
		public static function setContent(data:Array):void {
			var content:String='';
			for (var i:int = 0; i < data.length; i++) {
				content += '<div id="'+data[i].id+'">'
				content += '<h1>'+data[i].id+'</h1>';
				content += '<p>'+data[i].content+'</p>';
				content += '</div>';
			}
			ExternalInterface.call('seo_setContent', 'copy', content);
		}
	}
}