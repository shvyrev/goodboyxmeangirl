/**
 * Gradient shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	import flash.geom.Matrix;
	public class GradientShape extends GraphicShape
	{
		/**
		* 
		* @param	colors     [ 0xffffff, ... ]
		* @param	W
		* @param	H
		* @param	rotation   0 | 360
		* @param	type      'radial' | 'linear'
		* @param	alphas    [ 100, 100, ...]
		* @param	ratios    [ 0, 0xFF, ... ]
		* @param	hide
		* @return
		*/
		public function GradientShape(colors:Array,W:int,H:int,rotation:int,type:String,alphas:Array,ratios:Array,hide:Boolean=false,copy:Boolean=false ) {
			super(copy);
			_type = 'gradient';
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(W, H, rotation, 0, 0);
			
			this.graphicsCopy.clear();
			this.graphicsCopy.beginGradientFill(type, colors, alphas, ratios, matrix, "pad","RGB"); 
			this.graphicsCopy.lineTo(W, 0);
			this.graphicsCopy.lineTo(W, H);
			this.graphicsCopy.lineTo(0, H);
			this.graphicsCopy.lineTo(0, 0);
			this.graphicsCopy.endFill();
			(hide == true) ? this.alpha = 0 : this.alpha = 100;
		}
	}
	
}