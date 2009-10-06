/**
 * Chrome
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.air.chrome
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import railk.as3.display.graphicShape.*;
	import railk.as3.pattern.singleton.Singleton;
	
	public class Icons
	{
		private var n:*= null;
		public static function getInstance():Icons{
			return Singleton.getInstance(Icons);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Icons() { Singleton.assertSingle(Icons); }
		
		public function maximize(c:uint, isMac:Boolean = false):Bitmap {
			var bmp:Bitmap = new Bitmap(new BitmapData(16, 16, true, 0x00ffffff)), b:uint=reColor(0xffffffff,210), d:uint=reColor(0xffffffff,160);
			if (isMac) {
				mac(bmp.bitmapData, [0x1f3a10, 0xc4e57f, 0x294e1c]);
				setPixels(bmp.bitmapData,
				[	n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,d,b,b,d,n,n,n,n,n,n,
					n,n,n,n,n,n,n,d,d,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,c,c,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,c,c,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,c,c,n,n,n,n,n,n,n,
					n,n,n,n,c,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,c,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,n,n,n,c,c,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,c,c,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,c,c,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n
				]);
			} else{
				setPixels(bmp.bitmapData,
				[	n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,n,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,n,c,n,n,n,n,n,c,n,n,n,n,
					n,n,n,c,c,c,c,c,c,c,n,c,n,n,n,n,
					n,n,n,c,c,c,c,c,c,c,n,c,n,n,n,n,
					n,n,n,c,n,n,n,n,n,c,c,c,n,n,n,n,
					n,n,n,c,n,n,n,n,n,c,n,n,n,n,n,n,
					n,n,n,c,n,n,n,n,n,c,n,n,n,n,n,n,
					n,n,n,c,c,c,c,c,c,c,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n
				]);
			}
			return bmp;
		}
		
		public function minimize(c:uint,isMac:Boolean = false):Bitmap {
			var bmp:Bitmap = new Bitmap(new BitmapData(16, 16, true, 0x00ffffff)), b:uint=reColor(0xffffffff,210), d:uint=reColor(0xffffffff,160);
			if (isMac) {
				mac(bmp.bitmapData, [0x654f27, 0xfee776, 0x8b2e16]);
				setPixels(bmp.bitmapData,
				[	n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,d,b,b,d,n,n,n,n,n,n,
					n,n,n,n,n,n,n,d,d,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,c,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,c,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n
				]);
			} else {
				setPixels(bmp.bitmapData,
				[	n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,c,c,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,c,c,c,c,c,c,c,c,c,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n
				]);
			}	
			return bmp;
		}
		
		public function close(c:uint, isMac:Boolean = false):Bitmap {
			var bmp:Bitmap = new Bitmap(new BitmapData(16, 16, true, 0x00ffffff)),a:uint=reColor(c,160), b:uint=reColor(0xffffffff,210), d:uint=reColor(0xffffffff,160);
			if (isMac) {
				mac(bmp.bitmapData, [0x8c2426, 0xfa3e3f, 0x991e22]);
				setPixels(bmp.bitmapData,
				[	n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,d,b,b,d,n,n,n,n,n,n,
					n,n,n,n,n,n,n,d,d,n,n,n,n,n,n,n,
					n,n,n,n,c,a,n,n,n,n,a,c,n,n,n,n,
					n,n,n,n,a,c,a,n,n,a,c,a,n,n,n,n,
					n,n,n,n,n,a,c,a,a,c,a,n,n,n,n,n,
					n,n,n,n,n,n,a,c,c,a,n,n,n,n,n,n,
					n,n,n,n,n,n,a,c,c,a,n,n,n,n,n,n,
					n,n,n,n,n,a,c,a,a,c,a,n,n,n,n,n,
					n,n,n,n,a,c,a,n,n,a,c,a,n,n,n,n,
					n,n,n,n,c,a,n,n,n,n,a,c,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n
				]);
			} else{
				setPixels(bmp.bitmapData,
				[	n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,a,c,a,n,n,n,a,c,a,n,n,n,n,
					n,n,n,n,a,c,a,n,a,c,a,n,n,n,n,n,
					n,n,n,n,n,a,c,a,c,a,n,n,n,n,n,n,
					n,n,n,n,n,n,a,c,a,n,n,n,n,n,n,n,
					n,n,n,n,n,a,c,a,c,a,n,n,n,n,n,n,
					n,n,n,n,a,c,a,n,a,c,a,n,n,n,n,n,
					n,n,n,a,c,a,n,n,n,a,c,a,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,
					n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n
				]);
			}
			return bmp;
		}
		
		private function mac(bmd:BitmapData, c:Array):void {
			var m:Matrix = new Matrix();
			m.translate(1, 1);
			bmd.draw( new CircleShape(c[0],0,0,8) );
			bmd.draw( new CircleShape(c[1],0,0,7), m);
			var g:GradientShape = new GradientShape([c[2], c[1]], 16, 16, 90, 'linear', [100, 0], [25, 255]);
			g.mask = new CircleShape(0x000000,0,0,7);
			bmd.draw(g,m);
		}
		
		private function setPixels(bmd:BitmapData, grid:Array):void {
			for (var y:int = 0; y < 16; y++) for (var x:int = 0; x < 16; x++) if(grid[y*16+x]!=null) bmd.setPixel32( x, y, grid[y*16+x] );
		}
		
		private function reColor(color:uint,alpha:int):uint {			
			var a:uint = alpha;
			var r:uint = color >>> 16 & 0xFF;
			var g:uint = color >>>  8 & 0xFF;
			var b:uint = color & 0xFF;
			return  a << 24 | r << 16 | g << 8 | b;
		}
	}
}