﻿/**
* 
* Static class TagManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.ui.tag {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.grid.Grid;
	import railk.as3.data.grid.Cell;
	import railk.as3.data.list.*;
	
	
	public class TagManager {
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var tagList                            :DLinkedList;
		private static var walker                             :DListNode;
	
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
		public static function add( name:String, displayObjectName:String ):void 
		{	
			if ( getTag(name) ) { getTag(name).addFile( displayObjectName ); }
			else {
				tag = new Tag( name, displayObjectName );
				tagList.add( [name,tag] );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   MANAGE TAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):Boolean 
		{
			var result:Boolean;
			var t:DListNode = tagList.getNodeByName( name );
			if ( t )
			{
				t.data.dispose();
				tagList.removeNode( t );
				result = true;
			}
			else result = false;
			return result;
		}
		
		public static function getTag( name:String ):Tag {
			var result:Tag;
			if ( tagList.getNodeByName( name ) ) result = tagList.getNodeByName( name ).data;
			else result = null;
			return result;
		}
		
		public static function getTagByValue( value:Number ):Tag {
			walker = tagList.head;
			loop:while ( walker ) {
				if ( walker.data.value == value ) {
					var result = walker.data;
					break loop;
				}
				walker = walker.next;
			}
			return result;
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
		public static function tagCloud( fontClassName:String, H:Number, W:Number, gridPrecision:int = 5, upperCase:Boolean = true, debug:Boolean = false, debugContainer:*= null ):Array 
		{
			var i:int = 0;
			var j:int = 0;
			var result:Array = new Array();
			var minH:Number = gridPrecision;
			var minW:Number = gridPrecision;
			var cell:Cell;
			var format:TextFormat;
			var txt:TextField;
			var blocs:Array = new Array();
			var tagSortList:DLinkedList = DListSort.sort( tagList, DListSort.NUMERIC, DListSort.DESC, 'value' );
			var grid:Grid = new Grid( "tag", H, W, minH, minW, 0, 0, debug, debugContainer );
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
		private static function computeSpace( grid:Grid,  cellH:int, cellW:int, list:ObjectList, blocs:Array, fontClassName:String ):Number 
		{
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
		private static function toCellLength(size:int,cellSize:int):int { return Math.ceil(size / 5) * cellSize; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 TAG LIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	file
		 * @param	sorted
		 * @param	sortType   'desc' | 'asc'
		 * @return
		 */
		public static function tagListArray( file:String = '', sorted:Boolean = false, sortMode:String = 'desc' ):Array 
		{
			var result:Array = new Array();
			var tagSortList:DLinkedList;
			
			if ( !file )
			{
				if (sorted) {
					tagSortList = DListSort.sort( tagList, DListSort.NUMERIC, sortMode, 'value' );
					result = tagSortList.toArray();
				}
				else { result = tagList.toArray(); }
			}	
			else 
			{
				if (sorted) {
					tagSortList = DListSort.sort( tagList, DListSort.NUMERIC, sortMode, 'value' );
					walker = tagSortList.head;
				}
				else { walker = tagList.head }
				
				loop:while ( walker ) {
					if ( walker.data.file( file ) ) result.push( walker.data.name );
					walker = walker.next;
				}
			}
			return result;
		}
	}
}