/**
* Current toot and stage manager
* @author Richard Rodney
*/

package railk.as3
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class  TopLevel
	{
		public static var root:DisplayObject;
		public static var stage:Stage;
		public static var main:Sprite;
		public static function get folder():String {
			var folder:String = '';
			if(stage){
				var regLocal:RegExp = new RegExp("file:///[A-Z][|]/", "");
				var regLocalExtended:RegExp = new RegExp("file:///[A-Z][|]/[0-9A-Za-z%_./]*/www/", "");
				var regServer:RegExp = new RegExp("http://[A-Za-z0-9.]*/", "");
				folder = unescape( stage.loaderInfo.loaderURL );
				if ( folder.search(regLocal) != -1) folder = folder.replace( regLocalExtended, '');
				else if ( folder.search(regServer) != -1) folder = folder.replace( regServer, '');
				folder = folder.replace(folder.split('/')[folder.split('/').length - 1], "");
			}
			return folder;
		}
		public static function get url(folder:String=''):String {
			var url:String = '';
			if (stage) {
				url = stage.loaderInfo.loaderURL.replace(stage.loaderInfo.loaderURL.split('/')[stage.loaderInfo.loaderURL.split('/').length - 1], "");
				url = url.split(folder)[0];
			}
			return url;
		}
	}
}