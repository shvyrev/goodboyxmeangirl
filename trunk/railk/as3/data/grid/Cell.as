/**
* 
*  Cell GRID
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.data.grid {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.MouseEvent;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.tween.process.*;
	
	
	public class Cell 
	{	
		//____________________________________________________________________________________ VARIABLES CELL
		private var _id                                      :String;
		private var _contiguous                              :Object={};
		private var _X                                       :Number;
		private var _Y                                       :Number;
		private var _centerX                                 :Number;
		private var _centerY                                 :Number;
		private var _H                                       :Number;
		private var _W                                       :Number;
		private var _ligne                                   :Number;
		private var _colonne                                 :Number;
		private var _debug                                   :Boolean;
		private var used                                     :Boolean = false;
		private var gCell                                    :GraphicShape;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			     CELL
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	id
		 * @param	X
		 * @param	Y
		 * @param	centerX
		 * @param	centerY
		 * @param	H
		 * @param	W
		 * @param	ligne
		 * @param	colonne
		 * @param	debug
		 * @param	debugContainer
		 */
		public function Cell( id:String, X:Number, Y:Number, centerX:Number, centerY:Number, H:Number, W:Number, ligne:Number, colonne:Number, debug:Boolean = false, debugContainer:*= null )
		{	
			_id = id;
			_X = X;
			_Y = Y;
			_centerX = centerX;
			_centerY = centerY;
			_H = H;
			_W = W;
			_ligne = ligne;
			_colonne = colonne;
			_debug = debug;
			
			if ( debug ) {
				gCell = new GraphicShape();
				gCell.rectangle( 0x000000, X, Y, W, H);
				debugContainer.addChild( gCell );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	    GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get isUsed():Boolean { return used; }
		
		public function set isUsed( state:Boolean ):void {
			used = state;
			if ( _debug && used ) { Process.to( gCell, .3, { color:0xFF0000 } ); }
			else if ( _debug && !used ) { Process.to( gCell, .3, { color:0x000000 } ); }
		}
		
		public function get id():String { return _id; }
		
		public function get contiguous():Object { return _contiguous; }
		
		public function get x():Number { return _X; }
		
		public function get y():Number { return _Y; }
		
		public function get centerX():Number { return _centerX; }
		
		public function get centerY():Number { return _centerY; }
		
		public function get h():Number { return _H; }
		
		public function get w():Number { return _W; }
		
		public function get colonne():Number { return _colonne; }
		
		public function get ligne():Number { return _ligne; }
	}
}