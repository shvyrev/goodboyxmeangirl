package railk.as3.tween.process.plugin.helpers {
	public class ColorMatrixHelper {
		public static function applyMatrix(m:Array, m2:Array):Array {
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
	}
}