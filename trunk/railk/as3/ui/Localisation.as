/**
 * Localisation class
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{	
	import railk.as3.TopLevel;
	import railk.as3.pattern.singleton.Singleton;
	public class Localisation
	{
		public var current:String=''
		public static function getInstance():Localisation{
			return Singleton.getInstance(Localisation);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Localisation() { Singleton.assertSingle(Localisation); }
		
		
		public function getConfig(lang:String,zip:Boolean=false):String {
			current = lang;
			return (TopLevel.root.loaderInfo.url.indexOf("file") == 0)?'../assets/siteLocal'+((lang!='fr')?lang.toUpperCase():'')+'.xml':'assets/site'+((lang!='fr')?lang.toUpperCase():'')+((zip)?'.zip':'.xml');
		}
	}
}