/**
* 
* Static class TagManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.tag {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.tag.Tag;
	import railk.as3.utils.grid.Grid;
	import railk.as3.utils.grid.Cell;
	import railk.as3.utils.Utils;
	
	// __________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	
	
	public class TagManager extends Sprite {
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var tagList                            :DLinkedList;
		private static var walker                             :DListNode;
		private static var itr                                :DListIterator;
	
		//_____________________________________________________________________________________ VARIABLES TAG
		private static var tag                                :Tag;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init():void {
			 tagList = new DLinkedList();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			  ADD TAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function add( name:String, displayObjectName:String ):void {
			
			if ( getTag( name ) != null ) {
				getTag( name ).addFile( displayObjectName );
			}
			else {
				tag = new Tag( name, displayObjectName );
				tagList.append( tag );
			}
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   MANAGE TAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):Boolean {
			var result:Boolean;
			
			walker = tagList.head;
			//--
			while ( walker ) {
				//--
				var t:Tag = walker.data ;
				if ( t.name == name ) {
					t.dispose();
					itr = new DListIterator(tagList, walker);
					itr.remove();
					result = true;
				}
				else {
					result = false;
				}
				walker = walker.next;
			}
			
			return result;
		}
		
		
		public static function getTag( name:String ):Tag {
			walker = tagList.head;
			
			while ( walker ) {
				if ( walker.data.name == name ) {
					var result = walker.data;
				}
				walker = walker.next;
			}
			return result;
		}
		
		public static function getTagByValue( value:Number ):Tag {
			walker = tagList.head;
			
			while ( walker ) {
				if ( walker.data.value == value ) {
					var result = walker.data;
				}
				walker = walker.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						SORT TAG LIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function sortTagList( list:DLinkedList ):DLinkedList {
			var tagSortList:DLinkedList = new DLinkedList();
			var currentValue:Number = 0;
			walker = list.head;
			
			while ( walker ) {
				itr = new DListIterator( tagSortList, w );
				
				if ( tagSortList.size == 0 ) {
					tagSortList.append( walker.data );
					var w:DListNode = tagSortList.head;
				}
				else if ( walker.data.value <= currentValue ) {
					tagSortList.insertAfter( itr, walker.data );
					w = w.next;
				}
				else {
					tagSortList.insertBefore( itr, walker.data );
					w = w.prev;
				}
				
				currentValue = walker.data.value;
				walker = walker.next;
			}
			return tagSortList;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TAG CLOUD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	fontClassName   Nom de la typo
		 * @param	H
		 * @param	W
		 * @param	gridPrecision   DE 5 minimum  20 maximum
		 * @param	debug
		 * @param	debugContainer
		 * @return
		 */
		public static function tagCloud( fontClassName:String, H:Number, W:Number, gridPrecision:int=5, upperCase:Boolean=true, debug:Boolean=false, debugContainer:*=null ):Array {
			
			var i:int = 0;
			var j:int = 0;
			var result:Array = new Array();
			var minH:Number = gridPrecision;
			var minW:Number = gridPrecision;
			var cell:Cell;
			var format:TextFormat;
			var txt:TextField;
			var blocs:Array = new Array();
			
			var tagSortList:DLinkedList = sortTagList( tagList );
			var grid:Grid = new Grid( "tag", H, W, minH, minW, 0, debug, debugContainer );
			var multiplier:Number = computeSpace( grid, minH, minW, tagSortList, blocs, fontClassName );
			
			//--compute blocs
			walker = tagSortList.head;
			while ( walker ) {
				var texte:String = walker.data.name;
				if (upperCase) { texte = texte.toUpperCase(); }
				else { texte = texte.toLowerCase(); }
				
				format = new TextFormat();
				format.font = fontClassName;
				format.align = "left";
				format.size = walker.data.value*multiplier;
				
				txt = new TextField();
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = texte;
				txt.setTextFormat( format );
				
				var tagWidth:Number = txt.width;
				var tagHeight:Number = txt.height;
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				blocs.push( { h:toCellLength(tagHeight, gridPrecision), w:toCellLength(tagWidth, gridPrecision), extra:{texte:texte, size:walker.data.value*multiplier} } );
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				walker = walker.next;
			}
			
			result = grid.getBlocsPlace( blocs );			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						COMPUTE SPACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function computeSpace( grid:Grid,  cellH:int, cellW:int, list:DLinkedList, blocs:Array, fontClassName:String ):Number {
			var result:Number = 1;
			var nbCells:int = 0;
			var tagWidth:Number;
			var tagHeight:Number;
			var format:TextFormat;
			var txt:TextField;
			var largest:int=0;
			var highest:int=0;
				
			walker = list.head;
			while ( walker ) {
				format = new TextFormat();
				format.font = fontClassName;
				format.align = "left";
				format.size = walker.data.value;
				
				txt = new TextField();
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = walker.data.name;
				txt.setTextFormat( format );
				
				tagWidth = txt.width;
				tagHeight = txt.height;
				
				if ( tagWidth > largest ) largest = tagWidth;
				if ( tagHeight > highest ) highest = tagHeight;

				nbCells += int( (tagWidth / cellW )*(tagHeight / cellH ) ) + 1;
				
				walker = walker.next;
			}
			
			if ( nbCells != grid.freeCells ) {
				result =  int(grid.freeCells / nbCells); 
				if ( largest * result > grid.width ) result = 1;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   TO CELL LENGTH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function toCellLength(size:int,cellSize:int):int {
			var result:int = Math.ceil(size / 5) * cellSize;
			return result;
		}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 TAG LIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	file
		 * @param	sorted
		 * @return
		 */
		public static function tagListArray( file:*= null, sorted:Boolean=false ):Array {
			var result:Array = new Array();
			
			if (sorted) {
				var tagSortList:DLinkedList = sortTagList( tagList );
				walker = tagSortList.head;
			}
			else {
				walker = tagList.head;
			}	
			
			while ( walker ) {
				if ( walker.data.file( file ) ) {
					result.push( walker.data.name );
				}
				walker = walker.next;
			}
			
			return result;
		}
		
		
	}
	
}