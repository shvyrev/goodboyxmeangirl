/**
 * CSS PARSING
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.styleSheet
{
	import flash.utils.Dictionary;
    final public class CSS
    {
		private static const CSS_BLOCS:RegExp = /[^{]*\{([^}]*)*}/g;
        private static const CSS_COMMENT:RegExp = /\/\*[a-zA-Z0-9,:\-# ]{0,}\*\//g;
        private static const CSS_INLINE:RegExp = /[\t\n\r]/g;
        private static const FIND_A_HREF_CLASS:RegExp = /a\.([^\:]+)/gi;
		private static var styleSheets:Dictionary = new Dictionary(true);
		
		private var styleSheet:String;
		private var styles:Dictionary = new Dictionary(true);
		private var stylesToArray:Array = [];
		
		/**
		 * STATICS
		 */
		static public function getStyleSheet(name:String):CSS {
			return styleSheets[name];
		}
		
        /**
         * CONSTRUCTEUR
         */
        public function CSS(styleSheet:String, name:String = 'undefined') {
			styleSheets[name] = this;
            this.styleSheet = parse(styleSheet);
		}
		
		/**
		 * PARSE
		 * @param	css
		 * @return
		 */
		private function parse(css:String):String {
            var blocs:Array = css.match(CSS_BLOCS);
            for (var i:int = 0; i < blocs.length; i ++) parseStyleBlock(blocs[i]);
			return css;
        }
		
		private function parseStyleBlock(bloc:String):void {
			//remove comments and inline all class
			bloc = bloc.replace(CSS_COMMENT, '');
			bloc = bloc.replace(CSS_INLINE, '');
			
			//parse
            var splitBlock:Array = bloc.split("{");
            var splitStyle:Array = String(splitBlock[0]).split(",");
			var style:Style;
			
			for (var i:int = 0; i < splitStyle.length; i++) {
				// style
				var styleName:String = splitStyle[i].replace(/[ ]/g,'');
				var splitId:Array = styleName.split(":"), id:String = splitId[0].replace(/[.#]{0,}/, '');
				if (splitId.length > 1) {
					if (hasStyle(id)) style = getStyle(id).addRelated( new Style(splitId[1], Style.TYPE_SUBSTYLE) );
					else stylesToArray[stylesToArray.length] = styles[id] = style = (new Style( id, getType(splitId[0]) )).addRelated( new Style(splitId[1], Style.TYPE_SUBSTYLE) );
				} else {
					if (hasStyle(id)) style = getStyle(id);
					else stylesToArray[stylesToArray.length] = styles[id] = style = new Style( id, getType(splitId[0]) );
				}
				
				// pairs
				var pairs:Array = String(splitBlock[1]).substr(0, String(splitBlock[1]).length - 1).split(';');
				for (var j:int = 0; j < pairs.length - 1; j++) {
					var a:Array = pairs[j].replace(/:[ ]{0,}/, ':').split(':');
					style.add(a[0].replace(/[ ]/g,''), a[1]);
				}
			}
        }
		
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			styleSheet = "";
			styles = null;
			stylesToArray = null;
        }
		
		/**
		 * TOSTRING
		 */
		public function toString():String { return styleSheet; }
		public function toArray():Array { return stylesToArray; } 
		
		/**
		 * UTILITIES
		 */
		private function getType(name:String):String { return (name.indexOf('#') != -1)?Style.TYPE_ID:(name.indexOf('.') != -1)?Style.TYPE_CLASS:Style.TYPE_ELEMENT; }
		public function hasStyle(name:String):Boolean { return (styles[name] != undefined)?true:false; }
		public function getStyle(name:String):Style {
			if (name.indexOf(':') != -1) {
				var a:Array = name.split(':');
				return hasStyle(a[0])?styles[a[0]].getRelated(a[1]):null; 
			}
			return hasStyle(name)?styles[name]:null; 
		}
		
		public function applyStyle(o:Object, name:String):void {
			if (!hasStyle(name)) return;
			var style:Style = getStyle(name), data:Dictionary = style.data;
			for (var name:String in data) if (o.hasOwnProperty(name) ) o[name] = data[name];
		}
		
		
		/**
		 * GETTER/SETTER
		 */
		public function get length():int { return stylesToArray.length; }
    }
}