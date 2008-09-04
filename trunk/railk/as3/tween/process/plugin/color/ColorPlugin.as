package railk.as3.tween.process.plugin.color {

	import flash.filters.ColorMatrixFilter;
	import railk.as3.tween.process.plugin.color.IColor;
	public class ColorPlugin extends Array implements IColor {
		
		private var lumR:Number = 0.212671;
		private var lumG:Number = 0.715160;
		private var lumB:Number = 0.072169;
		private var identityMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private var resultMatrix:Array; 
		
		public function getType():String { return 'color'; }
		public function ColorPlugin(p_matrix:Array=null) {
			resultMatrix = identityMatrix.slice();
		}
		
		public function setColor( color:uint, amount:Number=1):Array {
			if (isNaN(color)) return resultMatrix;
			else if (isNaN(amount)) amount = 1;
			var r:Number = ((color >> 16) & 0xff) / 255;
			var g:Number = ((color >> 8)  & 0xff) / 255;
			var b:Number = (color         & 0xff) / 255;
			var inv:Number = 1 - amount;
			var temp:Array =  [inv + amount * r * lumR, amount * r * lumG,       amount * r * lumB,       0, 0,
							  amount * g * lumR,        inv + amount * g * lumG, amount * g * lumB,       0, 0,
							  amount * b * lumR,        amount * b * lumG,       inv + amount * b * lumB, 0, 0,
							  0, 				          0, 					     0, 					    1, 0];		
			return applyMatrix(temp, resultMatrix);
		}
			
		public function setThreshold(n:Number):Array {
			if (isNaN(n)) return resultMatrix;
			n = cleanValue(n, 255);
			var temp:Array = [lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						lumR * 256, lumG * 256, lumB * 256, 0,  -256 * n, 
						0,           0,           0,           1,  0]; 
			return applyMatrix(temp, resultMatrix);
		}
		
		public function setHue( n:Number):Array {
			if (isNaN(n)) return resultMatrix;
			n = cleanValue(n, 180);
			n *= Math.PI / 180;
			var c:Number = Math.cos(n);
			var s:Number = Math.sin(n);
			var temp:Array = [(lumR + (c * (1 - lumR))) + (s * (-lumR)), (lumG + (c * (-lumG))) + (s * (-lumG)), (lumB + (c * (-lumB))) + (s * (1 - lumB)), 0, 0, (lumR + (c * (-lumR))) + (s * 0.143), (lumG + (c * (1 - lumG))) + (s * 0.14), (lumB + (c * (-lumB))) + (s * -0.283), 0, 0, (lumR + (c * (-lumR))) + (s * (-(1 - lumR))), (lumG + (c * (-lumG))) + (s * lumG), (lumB + (c * (1 - lumB))) + (s * lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			return applyMatrix(temp, resultMatrix);
		}
		
		public function setBrightness(n:Number):Array {
			if (isNaN(n)) return resultMatrix;
			n = cleanValue(n, 100);
			return applyMatrix([1,0,0,0,n,
								0,1,0,0,n,
								0,0,1,0,n,
								0,0,0,1,0,
								0,0,0,0,1], resultMatrix);
		}
		
		public function setSaturation(n:Number):Array {
			if (isNaN(n)) return resultMatrix;
			n = cleanValue(n, 100);
			var inv:Number = 1 - n;
			var r:Number = inv * lumR;
			var g:Number = inv * lumG;
			var b:Number = inv * lumB;
			var temp:Array = [r + n, g     , b     , 0, 0,
							  r     , g + n, b     , 0, 0,
							  r     , g     , b + n, 0, 0,
							  0     , 0     , 0     , 1, 0];
			return applyMatrix(temp, resultMatrix);
		}
		
		public function setContrast(n:Number):Array {
			if (isNaN(n)) return resultMatrix;
			n = cleanValue(n, 100);
			trace( n );
			n += 0.01;
			var temp:Array =  [n,0,0,0,128 * (1 - n),
							   0,n,0,0,128 * (1 - n),
							   0,0,n,0,128 * (1 - n),
							   0,0,0,1,0];
			return applyMatrix(temp, resultMatrix);
		}
		
		public function applyMatrix(m:Array, m2:Array):Array {
			if (!(m is Array) || !(m2 is Array)) return m2;
			var temp:Array = [];
			var i:int = 0;
			var z:int = 0;
			var y:int, x:int;
			for (y = 0; y < 4; y++) {
				for (x = 0; x < 5; x++) {
					if (x == 4) z = m[i + 4];
					else z = 0;
					temp[i + x] = m[i]   * m2[x]      + 
								  m[i+1] * m2[x + 5]  + 
								  m[i+2] * m2[x + 10] + 
								  m[i+3] * m2[x + 15] +
								  z;
				}
				i += 5;
			}
			return temp;
		}
		
		private function cleanValue(p_val:Number,p_limit:Number):Number { return Math.min(p_limit,Math.max(-p_limit,p_val)); }
	}	
}