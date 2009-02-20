/**
* 
* Scrollbar
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.display.Stage
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.tween.process.*;
	
	
	
	public class ScrollBar extends RegistrationPoint  {
		
		//______________________________________________________________________________ VARIABLES STATIQUES
		public static var scrollList           :Object = { };
		private static var baseDelta           :Number = 14;
		
		//________________________________________________________________________________________ VARIABLES
		private var scrollContainer            :Sprite;
		private var slider                     :*;
		private var top   	                   :*;
		private var bottom                     :*;
		private var scrollBG                   :GraphicShape;
		private var scrollSize                 :Object;
		private var scrollColor                :Object; 
		private var scrollAlpha                :Object;
		private var customSlider               :Boolean;
		private var wheelEnable                :Boolean;
		private var resizeEnable               :Boolean;
		private var autoCheckEnable            :Boolean;
		private var autoScrollEnable           :Boolean;
		private var fullscreenEnable           :Boolean;
		private var content                    :Object;
		private var contentCheck               :Object={};
		private var multiplier                 :Number;
		private var delta                      :Number;
		private var distance                   :Number;
		private var way                        :String;
		private var rect                       :Rectangle;
		private var oldStageH                  :Number;
		private var oldStageW                  :Number;
		private var contentPlace               :Point;
		
		//________________________________________________________________________________ VARIABLES CONTROLE
		private var rollOut                    :Boolean = false;
		private var listeners                  :Boolean = false;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name                unique name for the scrollbar
		 * @param	orientation 		"V" | "H"
		 * @param	toScroll            the object to scroll
		 * @param	colors 				Object  { fond:uint, fondOver:uint, slider:uint, sliderOver:uint }
		 * @param	sizes 				Object  { fH:Number, fW:Number, sH:Number, sW:Number }
		 * @param	alphas   			Object  { fond:alpha, slider:alpha }
		 * @param	wheel				To activate the wheel or not
		 * @param	sliderClass         To use a personnal shape instead of the rectangular basic one
		 * @param	resizeAble          To give the possibility to the scrollbar to automaticaly resize itself base on the size of the screen
		 * @param	autoCheck           To make the scrollBar adapt itself automaticaly when the content size change
		 * @param	autoScroll          to follow the mouse when the mouse is hover the scrollbar.
		 */
		public function ScrollBar( name:String, orientation:String, toScroll:Object, colors:Object, sizes:Object,  topObj:*= null, bottomObj:*=null, alphas:Object = null, wheel:Boolean = false , sliderClass:Class = null, resizeAble:Boolean = false, autoCheck:Boolean = false, autoScroll:Boolean = false, fullScreen:Boolean = false )
		{
			scrollList[name] = this;
			wheelEnable = wheel;
			resizeEnable = resizeAble;
			autoCheckEnable = autoCheck;
			autoScrollEnable = autoScroll;
			fullscreenEnable = fullScreen;
			content = toScroll;
			scrollSize = sizes;
			scrollColor = colors;
			scrollAlpha = alphas;
			way = orientation;
			top = topObj;
			bottom = bottomObj;
			contentPlace = new Point( content.x, content.y);
			
			scrollContainer = new Sprite();
			scrollContainer.alpha = 0;
			scrollContainer.name = "container";
			scrollContainer.buttonMode = true;
			addChild( scrollContainer );
			
				//--BG
				scrollBG = new GraphicShape();
				scrollBG.rectangle( colors.fond, 0, 0, sizes.fW, sizes.fH );
				scrollBG.mouseEnabled = false;
				scrollContainer.addChild( scrollBG );
				
				//--Slider
				if ( slider == null ) {
					slider = new GraphicShape();
					slider.rectangle( colors.slider, 0, 0, sizes.sW, sizes.sH );
				}
				else {
					slider = new sliderClass();
				}
				slider.name = "slider";
				slider.buttonMode = true;
				scrollContainer.addChild( slider );
				
				//--TOP/BOTTOM
				if ( top != null )
				{
					top.y = scrollContainer.y -2;
					addChild( top );
				}
				if ( bottom != null )
				{
					bottom.y = scrollContainer.height + 2;
					addChild( bottom );
				}
				
			if ( !Process.pluginEnabled ) Process.enablePlugin( ProcessPlugins );
			this.addEventListener( Event.ADDED_TO_STAGE, setup, false, 0, true );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								SETUP
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function setup( evt:Event ):void 
		{
			//--resize
			if( resizeEnable ){
				stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
				oldStageH = stage.stageHeight;
				oldStageW = stage.stageWidth;
			}
			
			//--Autocheck if scroll bar is needed or must be resized if content size is modified
			if ( autoCheckEnable ) {
				contentCheck = { height:content.height, width:content.width };
				this.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			}
			
			//--AutoScroll en fonction de la position de la souris
			if ( autoScrollEnable ) {
				scrollContainer.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
			}	
				
			//--Scroll setup
			if ( way == "V" ) {
				if ( contentPlace.y+content.height > stage.stageHeight ) {
					showHide(1, true);
					distance = contentPlace.y+content.height - stage.stageHeight;
					slider.height = ( (scrollSize.fH - distance) > scrollSize.sH ) ? scrollSize.fH - distance : scrollSize.sH;
					multiplier = distance / ( scrollSize.fH - slider.height );
					delta = baseDelta / (multiplier*.5);
					delta = (delta > 6)? delta : 6;
					rect = new Rectangle(0, 0, 0, scrollSize.fH - slider.height);
					////////////////////////////////////
					initListeners();
					listeners = true;
					////////////////////////////////////
				}
				else showHide(0,false);
			}
			else if ( way == "H" ) {
				if ( contentPlace.x+content.width > stage.stageWidth ) {
					showHide(1,true);
					distance = contentPlace.x+content.width - stage.stageWidth;
					slider.width = ( (scrollSize.fW - distance) > scrollSize.sW ) ? scrollSize.fW - distance : scrollSize.sW;
					multiplier = distance / ( scrollSize.fW - slider.width );
					delta = baseDelta / (multiplier*.5);
					delta = (delta > 6)? delta : 6;
					rect = new Rectangle(0, 0, scrollSize.fW - slider.width, 0);
					////////////////////////////////////
					initListeners();
					listeners = true;
					////////////////////////////////////
				}
				else showHide(0,false);
			}
			
			if ( scrollAlpha != null ) {
				scrollBG.alpha = scrollAlpha.fond;
				slider.alpha = scrollAlpha.slider;
			}
			
			this.removeEventListener( Event.ADDED_TO_STAGE, setup );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void 
		{
			scrollContainer.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			scrollContainer.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			scrollContainer.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			if ( wheelEnable ) { stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true ); }
			stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
		}
		
		public function delListeners():void 
		{
			scrollContainer.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			scrollContainer.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			scrollContainer.removeEventListener( MouseEvent.CLICK, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			if ( wheelEnable ) { stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent ); }
			stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize():void 
		{
			if ( way == "V" ) {
				if ( contentPlace.y + content.height > stage.stageHeight ) {
					scrollContainer.visible = true;
					showHide(1, true);
					
					if ( fullscreenEnable )
					{
						if ( slider.y >= oldStageH - slider.height ) { slider.y = stage.stageHeight - slider.height; }
						else { slider.y = ( slider.y * stage.stageHeight ) / oldStageH; }
						scrollBG.height = ( scrollSize.fH * stage.stageHeight ) / oldStageH;
						if (bottom) bottom.y = scrollBG.height+2;
					}
					else
					{
						scrollBG.height = scrollSize.fH;
					}
						
					distance = contentPlace.y+content.height - stage.stageHeight;
					slider.height = ( (scrollSize.fH - distance) > scrollSize.sH ) ? scrollSize.fH - distance : scrollSize.sH;
					multiplier = distance / ( scrollBG.height - slider.height );
					delta = baseDelta / ( multiplier*.5);
					delta = (delta > 6)? delta : 6;
					rect = new Rectangle(0, 0, 0, scrollBG.height - slider.height );
					oldStageH = stage.stageHeight;
					scrollSize.fH = scrollBG.height;
					
					Process.to( slider, .5, { y:0 }, { onUpdate: function() { content.y = contentPlace.y-(slider.y * multiplier); } } );
					
					if(!listeners){
						////////////////////////////////////
						initListeners();
						listeners = true;
						////////////////////////////////////
					}	
				}	
				else {
					Process.to( slider, .4, { y:0 }, { onUpdate: function() { content.y = contentPlace.y -(slider.y * ((multiplier)? multiplier : 0) ); } } );
					showHide(0, false);
					////////////////////////////////////
					delListeners();
					listeners = false;
					////////////////////////////////////
				}	
			}
			else if ( way == "H" ) {
				if ( contentPlace.x+content.height > stage.stageWidth) {
					showHide(1, true);
					
					if ( fullscreenEnable)
					{
						if ( slider.x >= oldStageW - slider.width ) { slider.x = stage.stageWidth - slider.width; }
						else { slider.x = ( slider.x * stage.stageWidth ) / oldStageW; }
						scrollBG.width = ( scrollSize.fW * stage.stageWidth ) / oldStageW;
						if ( bottom ) bottom.x = scrollBG.width +2;
					}
					else
					{
						scrollBG.width = scrollSize.fW;
					}
						
					distance = contentPlace.x+content.height - stage.stageWidth;
					slider.width = ( (scrollSize.fW - distance) > scrollSize.sW ) ? scrollSize.fWs - distance : scrollSize.sW;
					multiplier = distance / ( scrollBG.width - slider.width  );
					delta = baseDelta / (multiplier*.5);
					delta = (delta > 6)? delta : 6;
					rect = new Rectangle(0, 0, scrollBG.width - slider.width, 0);
					oldStageW = stage.stageWidth;
					scrollSize.fW = scrollBG.width;
					
					if(!listeners){
						////////////////////////////////////
						initListeners();
						listeners = true;
						////////////////////////////////////
					}	
				}	
				else {
					Process.to( slider, .4, { x:0 } , { onUpdate: function() { content.x = contentPlace.x -(slider.x * ((multiplier)? multiplier : 0) ); } } );
					showHide(0, false);
					////////////////////////////////////
					delListeners();
					listeners = false;
					////////////////////////////////////
				}		
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   VISIBILITY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	alpha
		 */
		public function showHide( alpha:Number, visibility:Boolean ):void {
			if(alpha) Process.to( scrollContainer, .4, { alpha:alpha }, { onStart:function() { scrollContainer.visible = visibility; } } );
			else Process.to( scrollContainer, .4, { alpha:alpha }, { onComplete:function() { scrollContainer.visible = visibility; } } );
			if(top) top.alpha = alpha;
			if(bottom) bottom.alpha = alpha;
		}	
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get ObjectToScroll():Object { return content; }
		
		public function set ObjectToScroll( value:Object ):void { content = value; }
		
		override public function get alpha():Number { return scrollContainer.alpha; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ) 
		{
			var value:Number;
			switch( evt.type ) {
				case Event.ENTER_FRAME:
					if ( content.height != contentCheck.height || content.width != contentCheck.width ) {
						contentCheck.height = content.height;
						contentCheck.width = content.width;
						resize();
					}
					break;
				
				case Event.RESIZE :
					resize();
					break;
					
				case MouseEvent.CLICK :
					if ( way == "V" ) { 
						if ( mouseY >= rect.height ) { value = rect.height; }
						else if ( mouseY <= slider.height ) { value = 0; }
						else { value = mouseY - slider.height / 2; }
						Process.to( slider, .4, { y:value} );
						Process.to( content, .6, { y: contentPlace.y-(value * multiplier)},{rounded:true} );
					}
					else if ( way == "H" ) {
						if ( mouseX >= rect.width ) { value = rect.width; }
						else if ( mouseX <= slider.width ) { value = 0; }
						else { value = mouseX - slider.width / 2; }
						Process.to( slider, .4, { x:value} );
						Process.to( content, .6, { x: contentPlace.x-(value * multiplier)},{rounded:true} );
					}
					evt.updateAfterEvent();
					break;
				
				case MouseEvent.ROLL_OVER :
					Process.to( scrollBG, .6, { color:scrollColor.fondOver } );
					if( !customSlider ){
						Process.to( slider, .6, { color:scrollColor.sliderOver} );
					}	
					break;
					
				case MouseEvent.ROLL_OUT :
					Process.to( scrollBG, .6, { color:scrollColor.fond} );
					if( !customSlider ){
						Process.to( slider, .6, { color:scrollColor.slider} );
					}	
					break;
					
				case MouseEvent.MOUSE_DOWN :
					if ( evt.currentTarget.name == "slider" ) {
						evt.currentTarget.startDrag( false, rect );
						stage.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
						scrollContainer.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
					}	
					else {
						stage.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
					}
					break;
					
				case MouseEvent.MOUSE_UP :
					var eEvent:MouseEvent = new MouseEvent( MouseEvent.ROLL_OUT, true,false, scrollContainer.x, scrollContainer.y, scrollContainer );
					if( evt.currentTarget.name == "slider" ){
						evt.currentTarget.stopDrag();
						stage.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
						scrollContainer.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
					}
					else {
						stage.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
						scrollContainer.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
						manageEvent( eEvent );
						stopDrag();
					}
					break;
					
				case MouseEvent.MOUSE_MOVE :
					if ( evt.currentTarget.name == "container" ) {
						if ( way == "V" ) {
							if ( mouseY >= rect.height ) { value = rect.height; }
							else if ( mouseY <= slider.height ) { value = 0; }
							else { value = mouseY - slider.height / 2; }
							Process.to( slider, 1, { y:value }, { onUpdate: function() { content.y = contentPlace.y-(slider.y * multiplier); } } );
						}
						else if ( way == "H" ) {
							if ( mouseX >= rect.width ) { value = rect.width; }
							else if ( mouseX <= slider.width ) { value = 0; }
							else { value = mouseX - slider.width / 2; }
							Process.to( slider, 1, { x:value},{onUpdate: function() { content.x = contentPlace.x-(slider.x * multiplier); } } );
						}
					}
					else {
						if ( way == "V" ) {
							Process.to( content, .3, { y:contentPlace.y -(slider.y * multiplier) }, { rounded:true } );
						}
						else if( way == "H" ) {
							Process.to( content,.3, { x:contentPlace.x -(slider.x * multiplier)}, {rounded:true } );
						}
					}
					break;
					
				case MouseEvent.MOUSE_WHEEL :
					
					if ( way == "V" ) {
						if ( slider.y >= 0 + evt.delta*delta  && slider.y <= rect.height+ evt.delta*delta  ) {
							Process.to( slider, .4, { y: slider.y - (evt.delta * delta)} , { onUpdate: function() { content.y =contentPlace.y -(slider.y * multiplier); } } );
						}
						else if( slider.y < 0 + evt.delta*delta ) {
							Process.to( slider, .4, { y: 0}, {onUpdate: function() { content.y =contentPlace.y -(slider.y * multiplier); } } );
						}
						else if ( slider.y > rect.height + evt.delta*delta ) {
							Process.to( slider, .4, { y:rect.height }, {onUpdate: function() { content.y =contentPlace.y -(slider.y * multiplier); } } );
						}
					}
					else if ( way == "H" ) {
						if ( slider.x >= 0 + evt.delta*delta && slider.x <= rect.width + evt.delta*delta ) {
							Process.to( slider, .4, { x: slider.x - (evt.delta * delta)} , {onUpdate: function() { content.x =contentPlace.x -(slider.x * multiplier); } } );
						}
						else if( slider.x < 0 + evt.delta*delta ) {
							Process.to( slider, .4, { x: 0 }, {onUpdate: function() { content.x =contentPlace.x -(slider.x * multiplier); } } );
						}
						else if ( slider.x > rect.height+evt.delta*delta ) {
							Process.to( slider, .4, { x:rect.width }, { onUpdate: function() { content.x =contentPlace.x -(slider.x * multiplier); } } );
						}
					}
					break;
			}
		}
	}
}