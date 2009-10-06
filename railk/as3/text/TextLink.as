/**
* TextLink class to create textfield link
* 
* @author Richard Rodney
* @version 0.1
* 
*/

package railk.as3.text
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;	
	import railk.as3.display.RegistrationPoint;
	
	
	public class  TextLink extends RegistrationPoint
	{
		public static const AUTOSIZE_LEFT    :String = TextFieldAutoSize.LEFT;
		public static const AUTOSIZE_RIGHT   :String = TextFieldAutoSize.RIGHT;
		public static const AUTOSIZE_CENTER  :String = TextFieldAutoSize.CENTER;
		public static const DYNAMIC_TYPE     :String = TextFieldType.DYNAMIC;
		public static const INPUT_TYPE       :String = TextFieldType.INPUT;
		
		private var textLink                 :Sprite;
		private var format                   :TextFormat;
		private var texte                    :TextField;
		
		private var _name                    :String;
		private var _type                    :String;
		private var _text                    :String; 
		private var _color                   :uint;
		private var _font                    :String; 
		private var _embedFont               :Boolean; 
		private var _size                    :Number; 
		private var _align                   :String; 
		private var _wordwrap                :Boolean; 
		private var _selectable              :Boolean; 
		private var _width                   :Number; 
		private var _height                  :Number; 
		private var _autoSize                :Boolean; 
		private var _autoSizeType            :String;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	name
		 * @param	type         'dynamic'
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
		public function TextLink(	name:String='', type:String='dynamic', text:String='', color:uint=0xffffff, font:String='arial', embedFont:Boolean=false, size:Number=10, align:String='left', pixelFont:Boolean=false, wordwrap:Boolean=false, htmlText:Boolean=false, selectable:Boolean=false, autoSize:Boolean=false, autoSizeType:String='', width:Number=0, height:Number=0, backgroundColor:uint=0x00FFFFFF, borderColor:uint=0x00FFFFFF )
		{
			_name = name;
			_type = type;
			_text = text;
			_color = color;
			_font = font;
			_embedFont = embedFont;
			_size = size;
			_align = align;
			_wordwrap = wordwrap;
			_selectable = selectable;
			_width = width;
			_height = height;
			_autoSize = autoSize;
			_autoSizeType = autoSizeType;
			
			//--textelink
			textLink = new Sprite();
			
				format = new TextFormat();
				format.color = color;
				format.font =  font;
				format.size = size;
				format.align = align;
			
				texte = new TextField();
				texte.name = name;
				texte.type = type;
				if ( !htmlText ){
					texte.text = (text) ? text : ' ';
					texte.setTextFormat( format ); 
				} else { 
					texte.htmlText = (text) ? text : ' '; 
				}
				texte.embedFonts = embedFont;
				texte.selectable = selectable;
				if ( autoSize ) {
					texte.autoSize = autoSizeType;
					if( width != 0) texte.width = width;
					if( height != 0) texte.height = height;
				} else {
					if( width != 0) texte.width = width;
					if( height != 0) texte.height = height;
				}
				if ( backgroundColor != 0x00FFFFFF ) {
					texte.background = true;
					texte.backgroundColor = backgroundColor;
				}
				if ( borderColor != 0x00FFFFFF ) {
					texte.border = true;
					texte.borderColor = borderColor;
				}
				texte.wordWrap = wordwrap;
				texte.mouseEnabled = selectable;
				if(!pixelFont) texte.antiAliasType = AntiAliasType.ADVANCED;
				textLink.addChild( texte );
			
			addChild( textLink );	
		}
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '[ TEXTLINK > ' + this._name + ' ]';
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get textfield():TextField { return texte; }
		
		override public function get name():String { return _name; }
		override public function set name(value:String):void {
			texte.name = value;
			_name = value;
		}
		
		public function get type():String { return _type; }
		public function set type(value:String):void {
			texte.type = value;
			_type = value;
		}
		
		public function get text():String { return _text; }
		public function set text(value:String):void {
			texte.appendText('');
			texte.text = value;
			_text = value;
			dispatchChange();
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void {
			format.color = value;
			_color = value;
		}
		
		public function get font():String { return _font; }
		public function set font(value:String):void {
			format.font =  value;
			_font = value;
			dispatchChange();
		}
		
		public function get embedFont():Boolean { return _embedFont; }
		public function set embedFont(value:Boolean):void {
			texte.embedFonts = value;
			_embedFont = value;
		}
		
		public function get size():Number { return _size; }
		public function set size(value:Number):void {
			format.size = value;
			_size = value;
			dispatchChange();
		}
		
		public function get align():String { return _align; }
		public function set align(value:String):void {
			format.align = value;
			_align = value;
		}
		
		public function get selectable():Boolean { return _selectable; }
		public function set selectable(value:Boolean):void {
			texte.selectable = value;
			_selectable = value;
		}
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			if (!_autoSize) {
				texte.width = value;
				_width = value;
				dispatchChange();
			}	
		}
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			if (!_autoSize){
				texte.height = value;
				_height = value;
				dispatchChange();
			}
		}
		
		public function get autoSize():Boolean { return _autoSize; }
		public function set autoSize(value:Boolean):void { _autoSize = value; }
		
		public function get autoSizeType():String { return _autoSizeType; }
		public function set autoSizeType(value:String):void {
			if (_autoSize){
				texte.autoSize = value;
				_autoSizeType = value;
			}
		}
	}
}