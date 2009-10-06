/**
 * TextArea
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 */

package railk.as3.text
{	
	import flash.text.TextField;	
	public class TextArea extends TextField
	{
		private var _letters:Array=[];
		private var _words:Array=[];
		private var _lines:Array = [];
		
		private var firstFormat:Format;
		private var lastFormat:Format;
		private var currentFormat:Format;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	text
		 * @param	height
		 * @param	width
		 * @param	lineHeight
		 * @param	letterSpacing
		 * @param	justify
		 */
		public function TextArea(text:String,width:Number,height:Number,lines:Number=NaN,lineHeight:Number=NaN,letterSpacing:Number=NaN,justify:String='left') {
			var font:RegExp = /font:[a-zA-Z0-9 _-]{0,}/;
			var size:RegExp = /size:[0-9]{0,}/;
			var color:RegExp = /color:[a-zA-Z0-9 #]{0,}/;
			var underlined:RegExp = /underlined:[true|false]/;
			
			var trimmed:String = ''; 
			var format:String = ''; 
			var style:Boolean;
			
			for (i= 0; i < text.length; i++) {
				if ( text.substr(i, 6) == "<style" ) {
					style = true;
				}
				else if ( text.substr(i, 8) == "</style>" ) {
					currentFormat.place[currentFormat.place.length-1].end = trimmed.length;
					currentFormat = currentFormat.prev;
					text = text.replace(/<\/style>/, '');
				}
				else  if (text.charAt(i) == ">" && format.search(/\<style/) != -1) {
					addformat(	has(format.match(font), 'arial','font'), 
								Number(has(format.match(size), '12','size')), 
								stringToColor(has(format.match(color), '0x000000','color')), 
								stringToBoolean(has(format.match(underlined), 'false','underlined')), 
								lineHeight, 
								letterSpacing, 
								justify
					);
					currentFormat.place.push( { begin:trimmed.length } );
					format = '';
					style = false;
					i++;
				}
				else if ( text.substr(i, 5) == "<br/>") text = text.replace(/<br\/>/, '\n');
				
				if (style) format += text.charAt(i);
				else {
					trimmed += text.charAt(i);
					if(text.charAt(i)!=' ') _letters[_letters.length] = text.charAt(i);
				}
			}
			
			this.text = trimmed;
			this.width = width;
			this.height = height;
			if (lines) for (var i:int = 0; i < lines-this.numLines; i++) trimmed += '\r';
			this.text = (trimmed)?trimmed:' ';
			
			var walker:Format = firstFormat;
			while (walker) {
				for (i=0; i < walker.place.length; i++) this.setTextFormat(walker.textFormat, walker.place[i].begin, walker.place[i].end);
				walker = walker.next;
			}
		}
		
		/**
		 * ADD A NEW TEXTFORMAT FOR THE SPECIFY PART OF THE TEXT
		 * 
		 * @param	font
		 * @param	size
		 * @param	color
		 * @param	underlined
		 * @param	lineHeight
		 * @param	letterSpacing
		 * @param	justify
		 */
		private function addformat(font:String, size:Number, color:uint, underlined:Boolean, lineHeight:Number, letterSpacing:Number, justify:String ):void {
			var format:Format = new Format(font, size, color, underlined, lineHeight, letterSpacing, justify);
			if (firstFormat ==  null ) firstFormat = lastFormat = currentFormat = format;
			else {
				lastFormat.next = format;
				format.prev = lastFormat;
				lastFormat = currentFormat = format;
			}
		}
		
		/**
		 * UTILITIES
		 */
		public function getLine(line:int):Line {
			return new Line(this, line,lastFormat);
		}
		 
		private function stringToBoolean(bool:String):Boolean {
			var lookup:Object = { '1':1, 'yes':1, 'true':1, '0':0, 'no':0, 'false':0 };
			return lookup[bool];
		}
		
		private function stringToColor(color:String):uint {
			if ( color.charAt(0) == '#' ) color = color.replace(/#/, '0x');
			else if (color.substr(0, 2) != '0x') color = '0x' + color;
			return uint(color);
		}
		
		private function has(result:Array,defaut:String,what:String):* {
			return (result!=null)?result[0].split(':')[1]:((currentFormat!=null)?currentFormat[what]:defaut);
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get lines():Array { return _lines; }
		public function get words():Array { return _words; }
		public function get letters():Array { return _letters; }
	}
}

import flash.text.TextField;
class Line {
	private var textField:TextField;
	private var line:int;
	private var format:Format;
	
	public function Line(textField:TextField,line:int,format:Format) {
		this.textField = textField;
		this.line = line-1;
		this.format = format;
	}
	
	public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
      	textField.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
		textField.removeEventListener(type, listener, useCapture);
	}
	
	public function get text():String { return textField.getLineText(line); }
	public function set text(txt:String):void { 
		textField.replaceText( textField.getLineOffset(line),  textField.getLineOffset(line) + textField.getLineLength(line)-1, txt );
		textField.setTextFormat(format.textFormat,textField.getLineOffset(line),textField.getLineOffset(line) + textField.getLineLength(line)-1);
	}
}

import flash.text.TextFormat;
class Format {
	public var prev:Format;
	public var next:Format;
	
	public var font:String;
	public var size:Number;
	public var color:uint;
	public var underlined:Boolean;
	public var textFormat:TextFormat;
	
	public var place:Array = [];
	
	public function Format(font:String, size:Number, color:uint, underlined:Boolean, lineHeight:Number, letterSpacing:Number, justify:String) {
		this.font = font;
		this.size = size;
		this.color = color;
		this.underlined = underlined;
		textFormat = new TextFormat(font, size, color, null, null, underlined, null, null, justify, null, null, null, lineHeight);
		textFormat.letterSpacing = letterSpacing;
	}
}