/**
* 
* Bitmap Converor
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.display {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BitmapConvertor 
	{	
		// _______________________________________________________________________________________ VARIABLES
		private var bmpTemp                    :BitmapData;
		private var bmp                        :Bitmap;
		private var matrix                     :Matrix;
		private var used                       :Boolean = false;
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function BitmapConvertor() {}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 	  CONVERT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function convert( img:*, scale:Number=1 , rect:Rectangle=null ):Bitmap 
		{
			used=true;
			matrix = new Matrix();
		    matrix.identity();
			matrix.scale(scale,scale);
			
			var H:int = 0;
			var W:int = 0;
			
			if( rect != null ){ H = rect.height; W = rect.width; }
			else if ( rect == null ) {H = (int(img.height)+1)*scale; W = (int(img.width)+1)*scale; }
			
			bmpTemp = new BitmapData( W, H, true, 0x00FFFFFF );
			bmpTemp.draw(img,matrix,null,null,rect,true);
			bmp = new Bitmap(bmpTemp,"auto",true);
			return bmp;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																							  DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function dispose():void {
			bmpTemp.dispose();
			bmpTemp = null;
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 		 USED
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function isUsed():Boolean { return used; }
	}
}