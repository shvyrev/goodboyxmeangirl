/////////////////////////////////////////////////////////////////
//*************************************************************//
//*                      Bitmap convertor                     *//
//*************************************************************//
/////////////////////////////////////////////////////////////////
package railk.as3.utils {
	
	// ___________________________________________________________________ import flash
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BitmapConvertor {
		
		// ___________________________________________________________________ variables
		private var bmpTemp                    :BitmapData;
		private var bmp                        :Bitmap;
		private var matrix                     :Matrix;
		private var used                       :Boolean=false;
		
		
		// ___________________________________________________________________ constructeur
		
		public function BitmapConvertor() {
		}
		
		// ___________________________________________________________________ fonction de conversion
		/**
		* 
		* @param	img
		* @param	scale
		* @param	rect
		* @return
		*/
		public function convert(img, scale:Number=1 ,rect:Rectangle=null):Bitmap {
			
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
		
		// ___________________________________________________________________ suppression du bitmapdata
		
		public function dispose():void {
			bmpTemp.dispose();
			bmpTemp = null;
		}
		
		// ___________________________________________________________________ convert utilisé ?
		
		public function isUsed():Boolean {
			return used;
		}
	}
	
}