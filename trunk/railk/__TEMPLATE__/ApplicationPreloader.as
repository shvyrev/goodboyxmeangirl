/**
* ApplicationPreloader class
* 
* @author Richard Rodney
* @version 0.1
*/

package 
{
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.preloader.MainPreloader;
	import railk.as3.utils.Loading;
	import railk.as3.display.GraphicShape;
	import railk.as3.utils.DynamicRegistration;
	

	public class ApplicationPreloader extends MainPreloader 
	{
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function ApplicationPreloader():void {}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   CREATE LOADING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override protected function createLoading():Loading {
			var loadBar:Loading = new Loading();
			loadBar.barLoading( { fond:0xCCCCCC, bar:0x000000 }, 0, 0, 2, 220 );
			
			return loadBar;
		}
	}
	
}