/**
* INFO BULLE
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO:AUTHORISE SPECIAL GRAPHIC PART INSTEAD OF TEXT OR WITH THE TEXT AND ADD THE CIRCLE TYPE AND ORIENTATION
*/

package railk.as3.ui
{
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.DSprite;
	import railk.as3.display.GraphicShape;
	import railk.as3.display.RegistrationPoint;
	import railk.as3.tween.process.*;
	
	
	public class ToolTip extends RegistrationPoint
	{
		// __________________________________________________________________________________ VARIABLES BULLE
		private var bulle                          :GraphicShape;
		private var triangle                       :GraphicShape;
		private var info                           :DSprite;
		private var txt                            :TextField;
		private var format                         :TextFormat;
		
		private var _filters                       :Array;
		private var _type                          :String;
		private var _thickness                     :Number;
		private var _width                         :Number;
		private var _height                        :Number;
		private var _orientation                   :String;
		private var _bulleColor                    :uint;
		private var _texteColor                    :uint;
		private var _texte                         :String;
		private var _font                          :String;
		private var _fontSize                      :int;
		private var _corner                        :int;
		private var _dropShadow                    :Boolean;
		private var _tri                           :Boolean;
		private var _triPoints                     :Array;
		private var _triPlace                      :String;
		
		// _______________________________________________________________________________ VARIABLES CONTROLE
		private var engaged                        :Boolean = false;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	type           'rectangle'
		 * @param	thickness      width or height of the infobulle considering the orientation
		 * @param	orientation    H | V
		 * @param	bulleColor     uint
		 * @param	texte          Text to put inside the infobulle
		 * @param	texteColor     color of the text
		 * @param	font           font to be used ( embeded font is obligatory )
		 * @param	fontSize       size of the font
		 * @param	corner         size of the round corner if type is rectangular
		 * @param	dropShadow     false | true
		 * @param	tri            enabled or not the small marker for the infobulle
		 * @param   triPoints      [ A:Point,B:Point,C:Point ]
		 * @param	triPlace       place of the marker top | bottom | left | right
		 * 
		 */
		public function ToolTip( type:String, thickness:Number, orientation:String, bulleColor:uint, texte:String, texteColor:uint, font:String, fontSize:int, corner:int = 0, dropShadow:Boolean = false, tri:Boolean = false, triPoints:Array = null, triPlace:String = 'bottom' ):void 
		{
			_type = type;
			_thickness = thickness;
			_orientation = orientation;
			_bulleColor = bulleColor;
			_texteColor = texteColor;
			_texte = texte;
			_font = font;
			_fontSize = fontSize;
			_corner = corner;
			_dropShadow = dropShadow;
			_tri= tri;
			_triPlace = triPlace;
			if ( triPoints == null) triPoints = [ new Point(0, 0), new Point(6, -6), new Point(-6, -6) ];
			_triPoints = triPoints;
			_filters = new Array();
			
			//--dropShadow
			if (dropShadow) _filters.push( new DropShadowFilter( 8, 45, 0xffffff, .1 ) );
			
			//--texte
			format = new TextFormat();
			format.align = 'left';
			format.color = texteColor; 
			format.font = font;
			format.size =  fontSize;
			
			info = new DSprite();
			
				txt = new TextField();
				txt.name = 'txt';
				txt.text = texte;
				txt.type = "dynamic";
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.selectable = false;
				txt.embedFonts = true;
				txt.setTextFormat( format );
			
			info.addChild( txt );
			
			if ( txt.textWidth >= 20 ) _width = txt.textWidth + 20
			else _width = txt.textWidth;
			
			//--bulle
			bulle = new GraphicShape();
			bulle.roundRectangle( bulleColor, 0, 0, _width, thickness, corner, corner );
			bulle.y = -thickness;
			bulle.filters = _filters;
			addChild( bulle );
			info.x = bulle.x + 10;
			info.y2 = bulle.y2-1;
			addChild( info );
			
			//--triangle
			if(tri){
				triangle = new GraphicShape();
				triangle.triangle( triPoints[0], triPoints[1], triPoints[2], bulleColor );
				triangle.filters = _filters;
				addChild( triangle );
				placeTriangle( triPlace );
			}
					
			_width = txt.textWidth;
			_height = thickness;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   TRIANGLE PLACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function placeTriangle( place:String ):void {
			switch( place )
				{
					case 'top' :
						triangle.rotation = 180;
						bulle.x2 = 0;
						bulle.y += triangle.height+bulle.height;
						info.x = bulle.x + 10;
						info.y2 = bulle.y2-1;
						break;
					
					case 'bottom' :
						triangle.rotation = 0;
						bulle.x2 = 0;
						bulle.y -= triangle.height;
						info.x = bulle.x + 10;
						info.y2 = bulle.y2-1;
						break;
						
					case 'left' :
						triangle.rotation2 = 90;
						triangle.y = 0;
						triangle.x = 0;
						bulle.y2 = triangle.y2;
						bulle.x = triangle.x + triangle.width - 2;
						info.x = bulle.x + 10;
						info.y2 = bulle.y2-1;
						break;
						
					case 'right' :
						triangle.rotation2 = -90;
						triangle.y = 0;
						triangle.x = 0;
						bulle.y2 = triangle.y2;
						bulle.x = -(bulle.width + triangle.width - 2);
						info.x = bulle.x + 10;
						info.y2 = bulle.y2-1;
						break;	
				}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get thickness():Number { return _thickness; }
		
		public function set thickness( value:Number ):void {
			bulle.roundRectangle( bulleColor, 0, 0, value, _thickness, _corner, _corner );
			if (_tri) placeTriangle( _triPlace );
			_thickness = value;
		}
		
		public function get orientation():String { return _orientation; }
		
		public function set orientation( value:String ):void { _orientation = value; }
		
		public function get font():String { return _font; }
		
		public function set font( value:String ):void { _font = value; }
		
		public function get fontSize():int { return _fontSize; }
		
		public function set fontSize( value:int ):void { _fontSize = value; }
		
		public function get corner():int { return _corner; }
		
		public function set corner( value:int ):void {
			bulle.roundRectangle( bulleColor, 0, 0, _width, _thickness, value, value );
			if (_tri) placeTriangle( _triPlace );
			_corner = value;
		}
		
		public function get bulleColor():uint { return _bulleColor; }
		
		public function set bulleColor( value:uint ):void { _bulleColor = value; }
		
		public function get texteColor():uint { return _texteColor; }
		
		public function set texteColor( value:uint ):void { _texteColor = value; }
		
		public function get texte():String { return _texte; }
		
		public function set texte( value:String ):void {
			txt.appendText( '' );
			Process.to( txt, .3, { text:value }, { onUpdate:function()
			{ 
				var add:int=0;
				if ( txt.textWidth >= 20 ) 
				{
					add = 20;
					Process.to( triangle, 0, { alpha:1 } );
					engaged = false;
				}	
				else
				{
					if(_tri && !engaged )
						Process.to( triangle, .2, { alpha:0 } );
						engaged = true;
				}		
						
				bulle.roundRectangle( bulleColor, 0, 0, txt.textWidth+add, _height, _corner, _corner );
				if (_tri) 
					placeTriangle( _triPlace );
				_width = bulle.width;	
			} } );
			_texte = value;
		}
		
		public function get triEnabled():Boolean { return _tri; }
		
		public function set triEnabled( value:Boolean ):void {
			triangle.visible = false;
			_tri = value;
		}
		
		public function get triPoints():Array { return _triPoints; }
		
		public function set triPoints( value:Array ):void { _triPoints = value; }
		
		public function get triPlace():String { return _triPlace; }
		
		public function set triPlace( value:String ):void {
			_triPlace = value;
			placeTriangle( _triPlace );
		}
	}
}