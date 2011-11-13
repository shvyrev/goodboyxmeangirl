/**
* HTML TEXT
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.text
{
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;
	import railk.as3.display.UITextField;
	
	
	public class  HtmlText extends UITextField
	{
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	name
		 * @param	text
		 */
		public function HtmlText( name:String = '', text:String = '', wordwrap:Boolean = false ) {
			super.name = name;
			super.multiline = true;
			super.htmlText = (text) ? text : ' '; 
			super.antiAliasType = AntiAliasType.ADVANCED;
			super.wordWrap = wordwrap;
			super.embedFonts = true;
		}
		
		/**
		 * GETTER/SETTER
		 */
		override public function set text(value:String):void {
			super.appendText('');
			super.text = value;
			dispatchChange();
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			dispatchChange();
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			dispatchChange();
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			dispatchChange();
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			dispatchChange();
		}
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '[ HTML_TEXT > ' + super.name + ' ]';
		}
	}
}