/**
 * Font Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import flash.text.Font;
	public class FontManager
	{
		static public function register(font:Class):void {
			Font.registerFont(font);
		}
		
		static public function hasLocalFont( name:String ):Boolean {
			var localFonts:Array = Font.enumerateFonts(true);
			for (var i:int = 0; i < localFonts.length; ++i) if ( (localFonts[i] as Font).fontName == name ) return true;
			return true;
		}
		
	}
}