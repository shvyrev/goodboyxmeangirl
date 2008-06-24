/**
* 
* uploader file filters
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.uploader {

	// __________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.net.FileFilter;
	
	
	
	public class UpLoaderFilters extends Sprite {
		
		// _______________________________________________________________________________________ VARIABLES FILTERS
		public static const IMGFILE                  :String ="IMGFile";
		public static const TXTFILE                  :String ="TXTFile";
		public static const SWFFILE                  :String ="SWFFile";
		public static const XMLFILE                  :String ="XMLFile";
		public static const FLVFILE                  :String = "FLVFile";
		
		private static var filter                    :FileFilter;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function UpLoaderFilters():void {
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   CHOIX DU FILTRE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public static function Type( type:String ):FileFilter {
			
			switch( type ) {
				case IMGFILE :
					filter = new FileFilter("Images", "*.jpg;*.jpeg;*.gif;*.png");
					break;
				
				case TXTFILE :
					filter = new FileFilter("Text Files", "*.txt;*.rtf");
					break;
					
				case SWFFILE :
					filter = new FileFilter("Flash Movies", "*.swf");
					break;
					
				case XMLFILE :
					filter = new FileFilter("Xml Files", "*.xml");
					break;
					
				case FLVFILE :
					filter = new FileFilter("Video Files", "*.flv;*.mp4;*.mov");
					break;
				
				default :
					break;
			}
			
			return filter;
			
		}
		
	}
	
}