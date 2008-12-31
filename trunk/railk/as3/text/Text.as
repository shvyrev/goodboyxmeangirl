﻿/**
* TextLink class to create textfield link
* 
* @author Richard Rodney
* @version 0.1
* 
*/

package railk.as3.text
{
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;
	
	
	public class  Text extends TextField
	{
		//________________________________________________________________________________________ CONSTANTES
		public static const AUTOSIZE_LEFT                         :String = TextFieldAutoSize.LEFT;
		public static const AUTOSIZE_RIGHT                        :String = TextFieldAutoSize.RIGHT;
		public static const AUTOSIZE_CENTER                       :String = TextFieldAutoSize.CENTER;
		
		public static const DYNAMIC_TYPE                          :String = TextFieldType.DYNAMIC;
		public static const INPUT_TYPE                            :String = TextFieldType.INPUT;
		
		//_________________________________________________________________________________________ VARIABLES
		private var format                                        :TextFormat;
		private var texte                                         :TextField;
		
		//________________________________________________________________________________ VARIABLES TEXTLINK
		private var _hasAutoSize                                  :Boolean; 
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	type         'dynamic'|'input'
		 * @param	text
		 * @param	color
		 * @param	font
		 * @param	embedFonts
		 * @param	size
		 * @param	align
		 * @param	selectable
		 * @param	autoSize
		 * @param	autoSizeType
		 * @param	width
		 * @param	height
		 */
		public function Text( name:String='', type:String='dynamic', text:String='', color:uint=0xffffff, font:String='arial', embedFont:Boolean=false, size:Number=10, align:String='left', wordwrap:Boolean=false, htmlText:Boolean=false, selectable:Boolean=false, hasAutoSize:Boolean=false, autoSize:String='', width:Number=0, height:Number=0, backgroundColor:uint=0x00FFFFFF, borderColor:uint=0x00FFFFFF ):void 
		{
			_hasAutoSize = hasAutoSize;
			
			super.name = name;
			format = new TextFormat();
			format.color = color;
			format.font =  font;
			format.size = size;
			format.align = align;
			super.type = type;
			if ( !htmlText )
			{
				super.text = (text) ? text : ' ';
				super.setTextFormat( format ); 
			}
			else 
			{ 
				super.htmlText = (text) ? text : ' '; 
			}
			super.embedFonts = embedFont;
			super.selectable = selectable;
			if ( hasAutoSize )
			{
				super.autoSize = autoSize;
				if( width != 0) super.width = width;
				if( height != 0) super.height = height;
			}
			else
			{
				if( width != 0) super.width = width;
				if( height != 0) super.height = height;
			}
			if ( backgroundColor != 0x00FFFFFF )
			{
				super.background = true;
				super.backgroundColor = backgroundColor;
			}
			if ( borderColor != 0x00FFFFFF )
			{
				super.border = true;
				super.borderColor = borderColor;
			}
			super.wordWrap = wordwrap;
			super.mouseEnabled = selectable;
			super.multiline = true;
			super.antiAliasType = AntiAliasType.ADVANCED;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	   		TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String {
			return '[ TEXT > ' + super.name + ' ]';
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	    GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function set text(value:String):void 
		{
			super.appendText('');
			super.text = value;
		}
		
		public function get color():Object { return format.color; }
		
		public function set color(value:Object):void 
		{
			format.color = value;
			super.setTextFormat( format );
		}
		
		override public function get textColor():uint { return format.color as uint; }
		
		override public function set textColor(value:uint):void 
		{
			format.color = value;
			super.setTextFormat( format );
		}
		
		public function get font():String { return format.font; }
		
		public function set font(value:String):void 
		{
			format.font =  value;
			super.setTextFormat( format );
		}
		
		public function get size():Object { return format.size; }
		
		public function set size(value:Object):void 
		{
			format.size = value;
			super.setTextFormat( format );
		}
		
		public function get align():String { return format.align; }
		
		public function set align(value:String):void 
		{
			format.align = value;
			super.setTextFormat( format );
		}
		
		public override function set width(value:Number):void 
		{
			if (!_hasAutoSize) super.width = value;
		}
		
		public override function set height(value:Number):void 
		{
			if (!_hasAutoSize) super.height = value;
		}
		
		public function get hasAutoSize():Boolean { return _hasAutoSize; }
		
		public function set hasAutoSize(value:Boolean):void { _hasAutoSize = value; }
		
		override public function set autoSize(value:String):void 
		{
			if (_hasAutoSize) super.autoSize = value;
		}
	}
}