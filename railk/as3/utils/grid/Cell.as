/**
* 
*  Cell GRID
* 
* 
* @author Richard Rodney
* @version 0.2
* 
*/

package railk.as3.utils.grid {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	
	// ______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.TextShortcuts;
	
	
	
	public class Cell extends Sprite {
		
		
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
		 * @param	H
		 * @param	W
		 */
		public function Cell( id:String, X:Number,Y:Number, centerX:Number, centerY:Number, H:Number, W:Number, ligne:Number, colonne:Number, debug:Boolean=false, debugContainer:*=null ):void {
			
			//--Tweener
			ColorShortcuts.init();
			DisplayShortcuts.init();
			TextShortcuts.init();
			
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
		public function get isUsed():Boolean {
			return used;
		}
		
		public function set isUsed( state:Boolean ):void {
			used = state;
			if ( _debug && used ) {
				Tweener.addTween( gCell, { _color:0xFF0000, time:.3 } );
			}
			else if ( _debug && !used ) {
				Tweener.addTween( gCell, { _color:0x000000, time:.3 } );
			}
		}
		
		public function get id():String{ 
			return _id;
		}
		
		public function get contiguous():Object { 
			return _contiguous;
		}
		
		public override function get x():Number {
			return _X;
		}
		
		public override function get y():Number {
			return _Y;
		}
		
		public function get centerX():Number {
			return _centerX;
		}
		
		public function get centerY():Number {
			return _centerY;
		}
		
		public function get h():Number {
			return _H;
		}
		
		public function get w():Number {
			return _W;
		}
		
		public function get colonne():Number {
			return _colonne;
		}
		
		public function get ligne():Number {
			return _ligne;
		}
		
	}
}