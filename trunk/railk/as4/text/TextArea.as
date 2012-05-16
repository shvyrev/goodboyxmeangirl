/**
 * TEXTAERA
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as4.text
{	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.engine.*;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.net.navigateToURL;
	import flash.system.System;
	
	import railk.as3.display.UISprite;
	import railk.as3.ui.loader.*;
	
	public class TextArea extends UISprite
	{
		private var selectable:Boolean;
		private var _width:Number;
		
		public var bloc:TextBlock;
		public var content:Vector.<ContentElement>;
		private var formats:Dictionary;
		private var format:ElementFormat;
		private var lineMap:Array = [];
		private var lines:Vector.<TextLine> = new Vector.<TextLine>();
		private var dispatcher:EventDispatcher = new EventDispatcher();
		private var cursors:Vector.<UISprite> = new Vector.<UISprite>();
		private var lineUpdaters:Vector.<LineUpdater> = new Vector.<LineUpdater>();
		
		public var firstLine:TextLine;
		private var selection:Point = new Point( -1, -1);
		private var ctrlDown:Boolean;
		private var copyText:String;
		
		public function TextArea(text:String, width:Number, height:Number, selectable:Boolean = true) {
			this.selectable = selectable;
			_width = width;
			analyse(text);
			render(width);
		}
		
		/**
		 * TEXT ANALYSIS
		 * 
		 * @param	text
		 */
		public function analyse(text:String):void {
			var style:RegExp = /style="[a-zA-Z0-9,:\-# ]{1,}"/;
			var font:RegExp = /font:[a-zA-Z0-9_-]{0,}/;
			var size:RegExp = /size:[0-9]{0,}/;
			var color:RegExp = /color:[a-zA-Z0-9#]{0,}/;
			var align:RegExp = /align:[a-zA-Z]{0,}/;
			var link:RegExp = /href="[a-zA-Z0-9-_.#:\/]{0,}"/;
			var target:RegExp = /target="[a-zA-Z_]{0,}"/;
			var media:RegExp = /src="[a-zA-Z0-9-_.#:\/]{0,}"/;
			var underlined:RegExp = /underlined:[true|false]/;
			var htmlTag:RegExp = /(<([\/@!?#]?[^\W_]+)(?:\s|(?:\s(?:[^'">\s]|'[^']*'|"[^"]*")*))*\/?>)|(<\!--[^-]*-->)/g;
			var openTag:RegExp = /<[a-zA-Z0-9]{1,}/;
			var closeTag:RegExp = /<\/[a-zA-Z0-9 ]{1,}>/;
			var singleTag:RegExp = /<[a-zA-Z0-9=",.: ]{1,}\/>/;
			var trimmed:String = text;
			
			//////////////////////////////////////
			content = new Vector.<ContentElement>();
			formats = new Dictionary();
			bloc = new TextBlock();
			/////////////////////////////////////
			
			var tags:Array = trimmed.match(htmlTag), openTags:Array = [], index:int = 0;
			for (var i:int = 0; i < tags.length; i++) {
				var tag:String = tags[i]
				if(!i && trimmed.indexOf(tag, index)!=0) lineMap[lineMap.length] = [getFormat(),0,trimmed.indexOf(tag, index),null,null];
				/////////////////////////////////////////FORMAT//////////////////////////////////
				if (tag.search(style) != -1) {
					var s:String = tag.match(style)[0];
					format = getFormat(getStyle(s, font), getStyle(s, size), getStyle(s, color));
					tag.replace(style, '');
				}
				else format = (format)?format:getFormat();
				/////////////////////////////////////////////////////////////////////////////////
				
				if (tag.search(singleTag) != -1) {
					if (openTags.length > 0) lineMap[lineMap.length] = [formats[openTags[0][0]], openTags[0][1], trimmed.indexOf(tag, index),null,null];
					lineMap[lineMap.length] = (tag.search('br') != -1)?[format,'\n']:[tag.match(media)[0].split('"')[1],tag.match(/width="[0-9]{0,}"/)[0].split('"')[1],tag.match(/height="[0-9]{0,}"/)[0].split('"')[1]];
					if (openTags.length > 0) openTags[0][1] = trimmed.indexOf(tag, index);
				}
				else if (tag.search(openTag) != -1) {
					if (openTags.length > 0) lineMap[lineMap.length] = [formats[openTags[0][0]], openTags[0][1], trimmed.indexOf(tag, index),null,null];
					openTags.unshift([tag,trimmed.indexOf(tag, index),tag.match(link),tag.match(target)]);
					formats[tag] = format;
				}
				else if (tag.search(closeTag) != -1) {
					var data:Array = openTags.shift();
					lineMap[lineMap.length] = [formats[data[0]], data[1], trimmed.indexOf(tag, index),data[2],data[3]]
					if (openTags.length > 0) openTags[0][1] = trimmed.indexOf(tag, index);
				}
				if (i == tags.length - 1 && (trimmed.indexOf(tag, index) + tag.length) != trimmed.length ) lineMap[lineMap.length] = [getFormat(), (trimmed.indexOf(tag, index)), trimmed.length,null,null];
				trimmed = trimmed.replace(tag, '');
			}
			
			for (i = 0; i < lineMap.length; i++) {
				if(lineMap[i].length == 5) addText(trimmed.substring(lineMap[i][1], lineMap[i][2]), lineMap[i][0],lineMap[i][3],lineMap[i][4]);
				else if(lineMap[i].length == 3) addMedia(lineMap[i][0], lineMap[i][1], lineMap[i][2]);
				else addText(lineMap[i][1], lineMap[i][0],null,null);
			}
			bloc.content = new GroupElement(content);
		}
		
		/**
		 * ADD CONTENT
		 */
		private function addText(text:String, format:ElementFormat, link:Array, target:Array):void {
			var el:TextElement = new TextElement(text, format);
			if (link) {
				dispatcher.addEventListener(MouseEvent.CLICK, linkEvent, false, 0, true);
				dispatcher.addEventListener(MouseEvent.MOUSE_OVER, linkEvent, false, 0, true);
				dispatcher.addEventListener(MouseEvent.MOUSE_OUT, linkEvent, false, 0, true);
				el.userData = [link[0].split('"')[1],(target)?target[0].split('"')[1]:'_blanc'];
				el.eventMirror = dispatcher;
			}
			content[content.length] = el;
		}
		
		private function addMedia(media:String, width:Number, height:Number):void {
			loadUI(media).complete(placeMedia,media,UILoader.CONTENT).start();
			var gfx:GraphicElement = new GraphicElement(getPlaceHolder(width, height), width, height, format);
			gfx.userData = media;
			content[content.length] = gfx;
		}
		
		/**
		 * RENDER
		 * 
		 * @param	width
		 */
		public function render(width:Number):void {
			clearLines();
			if (selectable) (stage)?enableLineSelection():addEventListener(Event.ADDED_TO_STAGE, enableLineSelection);
			var line:TextLine = firstLine = bloc.createTextLine(null, width);
			var pos:Number = 0;
			while (line) {
				lines[lines.length] = addChild(line) as TextLine;
				lineUpdaters[lineUpdaters.length] = new LineUpdater(line, this, width);
				line.name = String(lines.length - 1);
				
				var atomCount:int = line.atomCount; 
				var atomheight:Number = 0; 
				for(var i:int = 0; i < atomCount; i++){
					var thisAtomHeight:int = line.getAtomBounds(i).height;
					if(thisAtomHeight > atomheight) atomheight += thisAtomHeight;
				}
				line.flushAtomData(); 
				pos += atomheight;
				line.y = pos;
				
				if (selectable) setCursor(line);
				line = bloc.createTextLine(line, width);
			}
		}
		
		private function clearLines():void {
			if (!lines.length) return;
			bloc.releaseLines(bloc.firstLine, bloc.lastLine);
			for (var i:int = 0; i < lines.length; i++) this.removeChild(lines[i]);
			for (i = 0; i < cursors.length; i++) this.removeChild(cursors[i]);
			lines = new Vector.<TextLine>();
			cursors = new Vector.<UISprite>();
			lineUpdaters = new Vector.<LineUpdater>();
			firstLine = null;
		}
		
		/**
		 * SELECTABLE
		 */
		private function enableLineSelection(e:Event=null):void {
			this.addEventListener(MouseEvent.MOUSE_OUT, selectionEvent, false,  0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, selectionEvent, false,  0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, selectionEvent, false,  0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, selectionEvent, false,  0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEvent, false,  0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardEvent, false,  0, true);
		}
		
		private function disableLineSelection():void {
			this.removeEventListener(MouseEvent.MOUSE_OUT, selectionEvent);
			this.removeEventListener(MouseEvent.MOUSE_OVER, selectionEvent);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, selectionEvent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, selectionEvent);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardEvent);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyboardEvent);
		}
		 
		private function setCursor(line:TextLine):void {
			var s:UISprite = getCursor('', line.height), bound:Rectangle = line.getAtomBounds(line.getAtomIndexAtPoint(x, line.y));
			s.y = line.y + bound.y;
			cursors[cursors.length] = addChild( s ) as UISprite;
		}
		
		private function getCursor(name:String, height:Number=NaN):UISprite {
			var cursor:UISprite = (name)?cursors[Number(name)]:new UISprite();
			if(!isNaN(height)){
				cursor.graphics.clear();
				cursor.graphics.beginFill(0xFFFFFF);
				cursor.graphics.drawRect(0, 0, .1, height);
				cursor.graphics.endFill();
				cursor.blendMode = 'invert';
				cursor.mouseEnabled = false;
				cursor.mouseChildren = false;
			}
			return cursor;
		}
		
		private function delCursors():void { for (var i:int = 0; i < cursors.length; i++) removeChild(cursors[i]); }
		
		/**
		 * UTILITIES
		 */
		private function getTextLine():TextLine {
			var o:Array = (!this.getObjectsUnderPoint( new Point(mouseX, mouseY) ).length)?(!this.getObjectsUnderPoint( new Point(x, mouseY) ).length)?this.getObjectsUnderPoint( new Point(x+10, mouseY) ):this.getObjectsUnderPoint( new Point(x, mouseY) ):this.getObjectsUnderPoint( new Point(mouseX, mouseY) );
			return (o.length > 0)?((o[0] is TextLine )?o[0]:(o[0].parent.parent is TextLine?o[0].parent.parent:null)):null;
		}
		 
		private function getPlaceHolder(width:Number, height:Number):UISprite {
			var ph:UISprite = new UISprite();
			ph.graphics.beginFill(0xffffff,0);
			ph.graphics.drawRect(0, 0, width, height);
			ph.graphics.endFill();
			return ph;
		}
		
		private function placeMedia(name:String, media:DisplayObject):void {
			if ( media is Bitmap) var bmp:Bitmap = new Bitmap((media as Bitmap).bitmapData.clone(), 'auto', true);
			for (var i:int = 0; i < content.length; i++) if (content[i].userData == name) (content[i] as GraphicElement).graphic = bmp
		}
		 
		public function getFormat(font:String='', size:String='', color:String='' ):ElementFormat {
			return new ElementFormat(new FontDescription((font)?font:'arial'),(size)?Number(size):12,(color)?stringToColor(color):0x000000);
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
		
		private function getStyle(s:String, r:RegExp):String { return (s.match(r))?s.match(r)[0].split(':')[1]:''; }
		
		/**
		 * LINK EVENT
		 * @param	e
		 */
		private function linkEvent(e:MouseEvent):void {
			var line:TextLine = e.target as TextLine;       
			var region:TextLineMirrorRegion = line.getMirrorRegion(dispatcher);
			var selected:TextElement = region.element as TextElement;
			switch(e.type) {
				case MouseEvent.CLICK : navigateToURL(new URLRequest(selected.userData[0]),selected.userData[1]); break;
				case MouseEvent.MOUSE_OVER : Mouse.cursor = 'button'; break;
				case MouseEvent.MOUSE_OUT : Mouse.cursor = selectable?'auto':'ibeam'; break;
			}
		}
		
		/**
		 * SELECTION EVENT
		 * @param	e
		 */
		private function selectionEvent(e:MouseEvent):void {
			var line:TextLine = getTextLine(), initCursors:Function = function():void{ for (var i:int = 0; i < cursors.length; i++) cursors[i].width = .1; };
			switch(e.type) {
				case MouseEvent.MOUSE_UP :
					firstLine = null; 
					selection = new Point( -1, -1);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, selectionEvent );
					setCopyText();
					break;
				case MouseEvent.MOUSE_DOWN :
					initCursors();
					if (!line) return;
					firstLine = line; 
					stage.addEventListener(MouseEvent.MOUSE_MOVE, selectionEvent, false, 0, true); 
					break;
				case MouseEvent.MOUSE_MOVE :
					if (!line) return;
					initCursors();
					placeCursors(e, Number(firstLine.name), Number(line.name));
					break;
				case MouseEvent.MOUSE_OVER : Mouse.cursor = (selectable)?'ibeam':'auto'; break;
				case MouseEvent.MOUSE_OUT : Mouse.cursor = 'auto';	break;
			}
		}
		
		private function placeCursors(e:MouseEvent, first:int, current:int):void {
			var from:int = (first>current)?current:first, to:int = ((first>current)?first:current)+1;
			var nb:int = current - first + 1, cursor:UISprite;
			var index:int = lines[current].getAtomIndexAtPoint(e.stageX, lines[current].y);
			var bound:Rectangle = (index != -1)?lines[current].getAtomBounds(index):new Rectangle(-1, -1, lines[current].width, lines[current].height);
			var pos:Number = bound.x + lines[current].x - ((first == current)?getCursor(String(current)).x:0);
			if (selection.x == -1) selection.x = bound.x + lines[current].x;
			var down:Boolean = (from == first) && (first != current);
			var mX:Number = (mouseX < 0)?0:bound.x;
			
			for (var i:int = from; i < to; i++) {
				cursor = getCursor(String(i));
				var right:Boolean = (mouseX > selection.x) && (Number(getTextLine().name)==first);
				if (down || right) {
					cursor.x = (first == i)?(selection.x < 0)?0:selection.x:0;
					cursor.width = (current == i)?(pos>=bound.width)?pos:pos+bound.width:(first == i)?(nb==1)?pos+bound.width:lines[i].width - selection.x:lines[i].width;
				} else {
					cursor.width = (current == i)?(first == i)?(selection.x - mX):(mX != -1)?lines[i].width - mX:0:(first == i)?(selection.x>lines[i].width)?lines[i].width:selection.x:lines[i].width;
					cursor.x = (current == i)?(mX<0)?0:mX:0;
				}
				lines[i].flushAtomData();
			}	
		}
		
		private function setCopyText():void {
			copyText = '';
			for (var i:int = 0; i < lines.length; i++) {
				var c:UISprite = cursors[i], l:TextLine = lines[i];
				// last line always have 1 pixel more screwing calculation need to understand where it's  coming from
				var last:Boolean = ( i == lines.length - 1 && c.width>.1);
				var begin:int = l.getAtomTextBlockBeginIndex(l.getAtomIndexAtPoint(c.x + x, l.y));
				var end:int = l.getAtomTextBlockEndIndex(l.getAtomIndexAtPoint(c.x+c.width+x-(last?1:0), l.y));
				var nb:int = (l.textBlock.content as GroupElement).elementCount;
				copyText += (c.width == .1)?'':l.textBlock.content.rawText.substring(begin, end);
				l.flushAtomData();
			}
		}
		
		/**
		 * KEYBOARD EVENT
		 */
		private function keyboardEvent(e:KeyboardEvent):void {
			switch(e.type) {
				case KeyboardEvent.KEY_DOWN : if ( e.keyCode == 17 ) ctrlDown = true; break;
				case KeyboardEvent.KEY_UP :
					if (e.keyCode == 17) ctrlDown = false; 
					if (e.keyCode == 67 && ctrlDown) System.setClipboard(copyText);
					break;
			}
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function getLine(n:int):LineUpdater {
			return lineUpdaters[n - 1];
		}
		
		public function get numLines():int { 
			var line:TextLine = firstLine, n:int=0;
			while ( line ) {
				n++;
				line = line.nextLine;
			}
			return n;
		}
	}
}

import flash.text.engine.TextLine;
import flash.text.engine.TextElement;
import flash.text.engine.GroupElement;
import railk.as4.text.TextArea;
internal class LineUpdater 
{
	private var textArea:TextArea;
	private var width:Number;
	private var line:TextLine;
	private var _text:String;
	
	public function LineUpdater(line:TextLine, textArea:TextArea, width:Number) {
		this.textArea = textArea;
		this.width = width;
		this.line = line;
		_text = line.textBlock.content.rawText.substring(line.textBlockBeginIndex, line.textBlockBeginIndex + line.rawTextLength - 1);
	}
	
	public function get text():String { return _text; }
	public function set text(value:String):void {
		//TODO
	}
}