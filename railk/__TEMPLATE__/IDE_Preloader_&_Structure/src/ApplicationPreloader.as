/**
* ApplicationPreloader class
* 
* @author Richard Rodney
* @version 0.1
*/

package 
{
	import railk.as3.net.preloader.IDEPreloader;
	import railk.as3.ui.loading.*;
	import railk.as3.display.graphicShape.*;
	import railk.as3.display.DSprite;
	

	public class ApplicationPreloader extends MainPreloader
	{
		public function ApplicationPreloader():void {
			super();
		}
		
		override protected function createBackground():DSprite {
			return new DSprite();
		}
		
		override protected function createForeground():DSprite {
			return new DSprite();
		}
		
		override protected function createMask():DSprite {
			var s:DSprite= new DSprite();
				var m:RectangleShape = new RectangleShape(0xFF0000,0,0,220,2);
				s.addChild( m );
			return s;
		}
		
		override protected function createLoading():RectLoading {
			return new RectLoading(0xCCCCCC,0x000000,0,0,2,220 );
		}
	}
	
}