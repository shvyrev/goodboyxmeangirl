/**
* 
*  Bloc GRID
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.data.grid {
	
	public class Bloc 
	{	
		//____________________________________________________________________________________ VARIABLES CELL
		private var _id                                      :String;
		private var _beginX                                  :int;
		private var _beginY                                  :int;
		private var _endX                                    :int;
		private var _endY                                    :int;
		private var _width                                   :int;
		private var _height                                  :int;
		private var used                                     :Boolean = false; 
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			     BLOC
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	id
		 * @param	beginX
		 * @param	beginY
		 * @param	endX
		 * @param	endY
		 * @param	width
		 * @param	height
		 */
		public function Bloc( id:String, beginX:int, beginY:int, endX:int, endY:int, width:int, height:int ):void 
		{	
			_id = id;
			_beginX = beginX;
			_beginY = beginY;
			_endX = endX;
			_endY = endY;
			_height = height;
			_width = width;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	    GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get isUsed():Boolean{  return used; }
		
		public function set isUsed(b:Boolean):void{  used = b; }
		
		public function get id():String{ return _id; }
		
		public function get beginX():int { return _beginX; }
		
		public function set beginX(x:int):void { _beginX = x; }
		
		public function get beginY():int { return _beginY; }
		
		public function set beginY(y:int):void { _beginY = y; }
		
		public function get endX():int { return _endX; }
		
		public function set endX(x:int):void { _endX = x; }
		
		public function get endY():int { return _endY; }
		
		public function set endY(y:int):void { _endY = y; }
		
		public function get height():int { return _height; }
		
		public function set height(h:int):void { _height = h; }
		
		public function get width():int { return _width; }
		
		public function set width(w:int):void { _width = w;}
		
		public function toString():String { return "[Bloc > id is " + id + " beginning  at x:"+ beginX +",y:"+beginY+" and w:"+width+",h:"+height+"]"; }
	}
}