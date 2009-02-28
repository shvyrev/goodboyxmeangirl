/**
* 
*  Grid
* 
* @author Richard Rodney
* @version 0.2
* 
* TODO > GET RANDOMS BLOC
*/

package railk.as3.data.grid {

	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.grid.Cell;
	import railk.as3.data.grid.Bloc;
	import railk.as3.data.list.*;
	import railk.as3.utils.ObjectDumper;
	import railk.as3.utils.Utils;
	
	
	public class Grid 
	{	
		//_______________________________________________________________________________ VARIABLES STATIQUES
		public static var gridList                           :Object={};
		
		//____________________________________________________________________________________ VARIABLES GRID
		private var nbCol                                    :Number;
		private var nbLigne                                  :Number;
		private var nbCell                                   :Number;
		private var _height                                  :int;
		private var _width                                   :int;
		private var count                                    :int = 0;
		private var sortedBloc                               :DLinkedList;                                 
		
		//____________________________________________________________________________________ VARIABLES CELL
		private var cell                                     :Cell;
		private var cellWidth                                :int;
		private var cellHeight                               :int;
		private var cellList                                 :DLinkedList;
		private var walker                                   :DListNode;
		
		//____________________________________________________________________________________ VARIABLES BLOC
		private var bloc                                     :Bloc;
		private var blocList                                 :DLinkedList;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			     GRID
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	gridH
		 * @param	gridW
		 * @param	cellH
		 * @param	cellW
		 * @param	espace
		 */
		public function Grid( name:String, gridW:Number, gridH:Number, cellW:Number, cellH:Number, espaceW:Number, espaceH:Number )
		{
			gridList[name] = this;
			_height = gridH;
			_width = gridW;
			cellHeight = cellH;
			cellWidth = cellW;
			
			//--vars
			nbCol = Math.round(gridW/(cellW + espaceW));
			nbLigne = Math.round(gridH/(cellH + espaceH));
			var X:int=0;
			var Y:int = 0;
			var i:int=0;
			var j:int = 0;
			var m:Boolean = true;
			var pos:int;
			cellList = new DLinkedList();
			blocList = new DLinkedList();
			
			while (true) {
				pos = m ? i++ : --i;
				cell = new Cell( String(count), X, Y, X + (cellW/2), Y+(cellH/2), cellH, cellW, pos, j );
				contiguous( j, pos, nbCol-1, nbLigne-1 );
				cellList.add( [String(count),cell] );
				X+= cellW+espaceW;
				count++;
				
				if (i == nbCol|| i == 0) {
					if (j++ == nbLigne) break;
					X=0;
					Y+= cellH+espaceH;
					m = !m;
				}
			}		
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		   CONTIGUOUS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function contiguous( x:int, y:int, h:int, w:int, r:int = 1 ):void 
		{
			var vx:int = x + r;
			var vy:int = y + r;
			var count:int = 0;
			
			while ( vx >= x-r) {
				while ( vy >= y-r ) {
					if( vx==x && vy==y ){ }
					else {
						//--Haut_gauche OK
						if ( (x == 0 && vx != x-r) && (y == 0 && vy != y-r) ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--Haut Droite OK
						else if ( ( x == w && vx != x+r) && (y == 0 && vy != y-r) ){
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--Premiere ligne OK
						else if ( x != 0 && (y == 0 && vy != y - r) && x!=w ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--premiere colonne OK
						else if ( y != 0 && (x == 0 && vx != x - r) && y != h ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--entre les limites OK
						else if ( (x > 0 && x < w) && (y > 0 && y < h)  ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--derniere colonne
						else if ( y != 0 && (x == h && vx != x + r) && y != h ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--derniere ligne OK
						else if ( x != 0 && (y == h && vy != y + r) && x!=w ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--Bas_gauche OK
						if ( (x == 0 && vx != x-r) && (y == h && vy != y+r) ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--bas Droite OK
						else if ( ( x == w && vx != x+r) && (y == h && vy != y+r) ){
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
					}
					vy--;
				}
				vx--;
				vy = y+r;
			}
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		  REMOVE GRID
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function remove( name:String ) 
		{
			var grid = gridList[name];
			walker = cellList.head;
			while ( walker ) {
				walker.data = null;
				walker = walker.next;
			}
			cellList.clear();
			grid = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    GET CELLS BY TYPE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	type   "coord" | "center" | "place"    |
		 * @param	data    {x,y}  |  {x,y}   | {ligne,col} | 
		 */
		public function getCellByType( type:String, data:Object ):Cell 
		{
			var result:Cell;
			walker = cellList.head;
			while ( walker ) {
				switch( type ) {
					case "coord" :
						if ( walker.data.x == data.x && walker.data.y == data.y ) {
							result = walker.data;
						}
						break;
					
					case "center" :
						if ( walker.data.centerX == data.x && walker.data.centerY == data.y ) {
							result = walker.data;
						}
						break;
					
					case "place" :
						if ( walker.data.ligne == data.ligne && walker.data.colonne == data.col ) {
							result = walker.data;
						}
						break;	
				}
				walker = walker.next;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      GET RANDOM CELL
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getRandomCell():Cell 
		{
			var result:Cell;
			var l = Utils.randRange( 0, ligne-1);
			var c = Utils.randRange( 0, col-1);
			result = getCellByType( 'place', { ligne:l, col:c } );
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 	  GET BLOCS PLACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getBlocsPlace( blocs:Array ):Array 
		{
			var result:Array = new Array();
			var currentWidth:Number = 0;
			var currentNode:DListNode;
			sortedBloc = new DLinkedList();
			
			//--sort the bloc by width
			var i:int = blocs.length;
			while (i--) {
				if ( sortedBloc.length == 0 ) {
					sortedBloc.add( [String(i),blocs[i]] );
					currentNode = sortedBloc.head;
				}
				else if ( blocs[i].w <= currentWidth ) {
					sortedBloc.insertAfter( currentNode,String(i), blocs[i] );
					currentNode = currentNode.next;
				}
				else {
					sortedBloc.insertBefore( currentNode,String(i), blocs[i] );
					currentNode = currentNode.prev;
				}
				currentWidth = blocs[i].w;
			}
			
			///////////////////////////////
			initBlocs();
			///////////////////////////////
			
			//--place the blocs by greatest width from left to right and top to bottom on the grid
			currentNode = sortedBloc.head;
			while ( currentNode ) {
				////////////////////////////////////////////////////////////
				var o:Object = manageBlocs( currentNode.data.w, currentNode.data.h );
				o.extra = currentNode.data.extra;
				result.push( o );
				////////////////////////////////////////////////////////////
				currentNode = currentNode.next;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    	   INIT BLOCS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function initBlocs():void {
			bloc = new Bloc( String(1), 0, 0, _width, _height, _width, _height );
			blocList.add( [String(1),bloc] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    	 MANAGE BLOCS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageBlocs( w:int, h:int ):Object 
		{
			var result:Object;
			var b:Bloc;
			walker = blocList.head;
			while (walker) {
				if ( walker.data.width >= w && walker.data.height >= h && !walker.data.isUsed ) {
					b = walker.data;
					result = { x:walker.data.beginX, y:walker.data.beginY };
					break;
				}
				walker = walker.next;
			}
			
			//--Cell > used
			var c:Cell;
			var x:int = b.beginX; 
			var y:int = b.beginY;
				
			while (y <= h+b.beginY ) {
				while ( x <= w+b.beginX ) {
					c = getCellByType( 'coord', { x:x, y:y } );
					c.isUsed = true;
					x += cellWidth;
				}
				y += cellHeight;
				x = 0;
			}
			
			//-- redecoupage du bloc si necéssaire
			if ( b.width > w && b.height > h) {
				/*bloc1*/addBloc( blocList.length+1, b.beginX, h-cellHeight, b.width, b.height-cellHeight, b.width, b.height-h );
				/*bloc2*/addBloc( blocList.length+1, w+cellWidth, b.beginY, b.width, h, b.width-w, h  );
				b.width = w;
				b.height = h-cellHeight;
				b.endX = w;
				b.endY = h - cellHeight;
				b.isUsed = true;
			}
			else if ( b.width > w && b.height == h ) {
				/*bloc1*/addBloc( blocList.length+1, w+cellWidth, b.beginY, b.width+cellWidth, b.height, b.width-w, b.height   );
				b.width = w;
				b.height = h-cellHeight;
				b.endX = w;
				b.endY = h - cellHeight;
				b.isUsed = true;
			}
			else if ( b.width == w && b.height > h ) {
				/*bloc1*/addBloc( blocList.length+1, b.beginX, h-cellHeight, b.width, b.height-cellHeight, b.width, b.height-h  );
				b.width = w;
				b.height = h-cellHeight;
				b.endX = w;
				b.endY = h - cellHeight;
				b.isUsed = true;
			}
			else if ( b.width == w && b.height == h ) {
				b.isUsed = true;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   			 ADD BLOC
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function addBloc( id:int, beginX:int, beginY:int, endX:int , endY:int,  h:int, w:int ):void {
			bloc = new Bloc(String(id), beginX, beginY, endX , endY, w, h);
			blocList.add( [String(id),bloc] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 	  GET BLOCS PLACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function getRandomBlocsPlace( height:int, width:int, value:int, minSize:int, maxSize:int ):Array {
			var result:Array = new Array();
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————	
		public function get blocsToString():String { return blocList.toString(); }
		
		public function get coord():Array {
			var result:Array = new Array();
			walker = cellList.head;
			while ( walker ){
				result.push( { x:walker.data.x, y:walker.data.y } );
				walker = walker.next;
			}
			return result;
		}
		
		public function get ligne():Number{ return nbLigne; }
		
		public function get col():Number{ return nbCol; }
		
		public function get width():Number{ return _width; }
		
		public function get height():Number{ return _height; }
		
		public function get usedCells():int {
			var result:int = 0;
			walker = cellList.head
			while ( walker ) {
				if (walker.data.isUsed) { result += 1; }
				walker = walker.next
			}
			return result;
		}
		
		public function get freeCells():int {
			var result:int = 0;
			walker = cellList.head
			while ( walker ) {
				if (!walker.data.isUsed) { result += 1; }
				walker = walker.next
			}
			return result;
		}
	}
}