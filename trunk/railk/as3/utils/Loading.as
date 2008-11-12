/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.utils {
	
	// ___________________________________________________________________ import flash
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	// ___________________________________________________________________ import Railk
	import railk.as3.display.DSprite;
	import railk.as3.display.GraphicShape;
	import railk.as3.utils.BitmapConvertor;
	import railk.as3.utils.RegistrationPoint;
	
	
	public dynamic class Loading extends RegistrationPoint {	
		
		//____________________________________________________________________ variables rapatri馥s
		private var _radius                  :Number;
		private var _color                   :Number;
		private var _epaisseur	             :Number;
		private var _percent                 :Number;
		
		//____________________________________________________________________ variables
		private var current                 :String;
		private var barCont                 :DSprite;
		private var bar                     :GraphicShape;
		private var barFd                   :GraphicShape;
		
		private var cercleCont              :DSprite;
		private var cercleMask              :GraphicShape;
		private var cercleCercle            :GraphicShape;
		
		private var texteCont               :DSprite;
		private var texte                   :TextField;

		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						 CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function Loading(){}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																					   CIRCLE LOADING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		* 
		* @param	colors est un objet qui poss鐡e trois param鑼res /fond/, /cercle/ et /mask/
		* @param	radius
		* @param	innerRadius
		* @return
		*/
		public function cercleLoading(colors:Object, radius:Number, innerRadius:Number):void 
		{
			//--
			current = 'cercle';
			_radius = radius;
			
			//cr饌tion du loading
			cercleCont = new DSprite();
			
				var cercleFond:GraphicShape = new GraphicShape();
				cercleFond.donut(colors.fond,0,0,radius,innerRadius);
				
				cercleCercle = new GraphicShape();
				cercleCercle.donut(colors.cercle,0,0,radius,innerRadius);
				cercleCercle.alpha = 0;
				
				cercleMask = new GraphicShape();
			
			cercleCont.addChild(cercleFond);
			cercleCont.addChild(cercleCercle);
			cercleCont.addChild(cercleMask);
			addChild(cercleCont);
			
			
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function get cercleA():* {
			return cercleCercle;
		}
		
		public function get cercleM():*{
			return cercleMask;
		}
		
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																					   RIBBON LOADING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		* 
		* @param	colors     { fond:uint, ribbon:uint }
		* @param	radius
		* @param	epaisseur
		* @return
		*/
		public function ribbonLoading(colors:Object, radius:int, epaisseur:int):void {
			//--
			current = 'ribbon';
			//--vars
			_color = colors.ribbon;
			_radius = radius;
			_epaisseur = epaisseur;
			//--BG
			var ribbonBG:GraphicShape = new GraphicShape();
			ribbonBG.name = "bg";
			ribbonBG.arcRibbon( epaisseur, colors.fond, radius, 1, 360, 30);
			this.addChild( ribbonBG );
		}
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function set ribbonPercent( percent:int ):void {
			//vars
			_percent = percent;
			var angle:Number = (percent * 360) / 100;
			//--Remove
			if ( this.getChildByName( 'ribbon' ) != null ) removeChild( this.getChildByName( 'ribbon' ) );
			//--Ribbon
			var ribbon:GraphicShape = new GraphicShape();
			ribbon.name = 'ribbon';
			ribbon.arcRibbon( _epaisseur, _color, _radius, 2, angle, 30);
			ribbon.rotation = -90;
			this.addChild( ribbon );
		}
		
		public function set ribbonThickness( epaisseur:int ):void {
			//--vars
			_epaisseur = epaisseur;
			var angle:Number = (_percent * 360) / 100;
			//--Remove
			if ( this.getChildByName( 'ribbon' ) != null ) removeChild( this.getChildByName( 'ribbon' ) );
			//--Ribbon
			var ribbon:GraphicShape = new GraphicShape();
			ribbon.name = 'ribbon';
			ribbon.arcRibbon( epaisseur, _color, _radius, 2, angle, 30);
			ribbon.rotation = -90;
			this.addChild( ribbon );
		}
		
		public function set ribbonRadius( radius:int ):void {
			//--vars
			_radius = radius;
			var angle:Number = (_percent * 360) / 100;
			//--Remove
			if ( this.getChildByName( 'ribbon' ) != null ) removeChild( this.getChildByName( 'ribbon' ) );
			//--Ribbon
			var ribbon:GraphicShape = new GraphicShape();
			ribbon.name = 'ribbon';
			ribbon.arcRibbon( _epaisseur, _color, radius, 3, angle, 30);
			ribbon.rotation = -90;
			this.addChild( ribbon );
		}

		
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						  BAR LOADING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		* 
		* @param	colors est un objet qui poss鐡e deux param鑼res /fond/ et /bar/
		* @param	X
		* @param	Y
		* @param	H
		* @param	W
		* @return
		*/
		public function barLoading(colors:Object, X:Number, Y:Number, H:Number, W:Number):void {
			//--
			current = 'barre';
			barCont = new DSprite();
			
				barFd = new GraphicShape();
				barFd.rectangle(colors.fond,0,0,W,H);
				
				bar = new GraphicShape();
				bar.rectangle(colors.bar,0,0,1,H);
			
			barCont.addChild(barFd);
			barCont.addChild(bar)
			addChild(barCont);
		}
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function get barColor():uint {
			var bmpC:BitmapConvertor = new BitmapConvertor();
			var tmpObj:Bitmap = bmpC.convert( bar,1,null );
			var col:uint = tmpObj.bitmapData.getPixel( 0,0 );
			bmpC.dispose();
			return col;
		}
		
		public function set barColor( value:uint ):void {
			bar.color = value;
		}
		
		public function get barFond():Number {
			return barFd.width;
		}
		
		public function set barFond( value:Number ):void {
			barFd.width = value;
		}
		
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																						TEXTE LAODING
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		/**
		* 
		* @param	fontName  new font().name
		* @param	fontSize
		* @param	fontColor
		* @param	fontAlign "center" / "left" / "right"
		* @return
		*/
		public function texteLoading( fontName:*, fontSize:Number, fontColor:uint, fontAlign:String ):void
		{
			//--
			current = 'texte';
			//
			texteCont = new DSprite();
			texteCont.name = "textecont";
			addChild( texteCont );
			
			var format:TextFormat = new TextFormat();
			format.font = fontName;
			format.color = fontColor;
			format.size = fontSize;
			format.align = "center";
			
			texte = new TextField();
			texte.autoSize = TextFieldAutoSize.CENTER;
			texte.text = "00";
			texte.height = fontSize;
			texte.embedFonts = true;
			texte.selectable = false;
			texte.setTextFormat( format );
			texteCont.addChild( texte );
		}
		
		
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		// 																				 COMMON GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧
		public function get percent():Number {
			var result:Number;
			
			if( current == 'cercle' ) {}
			else if( current == 'ribbon' ) {}
			else if ( current == 'barre' ) { result = bar.width; }
			else if( current == 'texte' ) { result = int( texte.text ); }
			
			return result;
		}
		
		public function set percent(value:Number):void {
			if( current == 'ribbon' ) {}
			else if ( current == 'cercle' ) 
			{
				//on retire le precedent cercle
				cercleCont.removeChild(cercleMask);
				
				//on calcul l'angle en fonction du pourcentage
				if( value == 0 ) { value=1; }
				var angle:Number = ( value*360 )/100;
				
				cercleMask = new GraphicShape();
				cercleMask.camembert(_color,0,0,_radius+10,0,angle,100);
				cercleCont.addChildAt(cercleMask,cercleCont.numChildren-1);
				
				cercleCercle.mask = cercleMask;
				cercleCercle.alpha = 1;
				cercleMask.rotation = -90;
				
			}
			else if( current == 'barre' ) { bar.width =  (value*barFd.width)/100; }
			else if( current == 'texte' ) { texte.appendText(''); texte.text = String(value); }
		}
		

	}
	
}