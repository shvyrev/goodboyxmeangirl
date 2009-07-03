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
			if(stage){
				var regLocal:RegExp = new RegExp("file:///[A-Z][|]/", "");
				var regLocalExtended:RegExp = new RegExp("file:///[A-Z][|]/[0-9A-Za-z%_./]*/www/", "");
				var regServer:RegExp = new RegExp("http://[A-Za-z0-9.]*/", "");
				var folder:String = unescape( stage.loaderInfo.loaderURL );
				if ( folder.search(regLocal) != -1) folder = folder.replace( regLocalExtended, '');
				else if ( folder.search(regServer) != -1) folder = folder.replace( regServer, '');
				return folder.replace(folder.split('/')[folder.split('/').length - 1], "");
			}
			else throw new Error('stage is not defined yet');
		}
		public static function get url():String {
			if (stage) return stage.loaderInfo.loaderURL.replace(stage.loaderInfo.loaderURL.split('/')[stage.loaderInfo.loaderURL.split('/').length - 1], "");
			else throw new Error('stage is not defined yet');
		}
	}
}