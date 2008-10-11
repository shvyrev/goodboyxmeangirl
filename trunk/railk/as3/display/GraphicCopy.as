/**
 * senocular graphics copy class
 */

package railk.as3.display {
	
	import flash.display.Graphics;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/**
	 * a graphics property substitute for DisplayObject instances
	 * that can be duplicated
	 */
	public dynamic class GraphicCopy extends Proxy {
		
		private var _graphics:Graphics;
		private var history:Array = new Array();
		

		public function get graphics():Graphics {
			return _graphics;
		}
		public function set graphics(g:Graphics):void {
			_graphics = g;
			copy(this);
		}
		
		/**
		 * constructor
		 * @param graphics Optional Graphics instance to recieve
		 * drawing commands given to this GraphicsCopy instance
		 */
		public function GraphicCopy(graphics:Graphics = null) {
			_graphics = graphics;
		}
		
		/**
		 * copies the graphics of a GraphicsCopy into this GraphicsCopy
		 */
		public function copy(graphicsCopy:GraphicCopy):void {
			var hist:Array = graphicsCopy.history;
			history = hist.slice();
			if (_graphics) {
				var i:int;
				var n:int = hist.length;
				_graphics.clear();
				for (i=0; i<n; i += 2) {
					_graphics[hist[i]].apply(_graphics, hist[i + 1]);
				}
			}
		}
		
		// PROXY overrides
		flash_proxy override function callProperty(methodName:*, ... args):* {
			methodName = String(methodName);
			switch(methodName) {
				case "clear":
					history.length = 0;
					break;
				default:
					history.push(methodName, args);
			}
			if (_graphics && methodName in _graphics) {
				return _graphics[methodName].apply(_graphics, args);
			}
		}
	}
}