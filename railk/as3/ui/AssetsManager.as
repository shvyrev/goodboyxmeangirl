/**
 * Assets Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class AssetsManager
	{
		static private var assets:Dictionary = new Dictionary(true);
		
		static public function addAssets(assets:Array):void {
			for (var i:int = 0; i < assets.length; i++) addAsset(assets[i])
		}
		
		static public function addAsset(name:String):void {
			assets[name] = getDefinitionByName( name ) as Class;
		}
		
		static public function getAsset(name:String):Class {
			if ( assets[name] != undefined) return assets[name];
			throw new Error("l'asset n'existe pas");
		}
	}
}