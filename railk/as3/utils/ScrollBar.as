/**
* 
* Scrollbar
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.stage.StageManager;
	import railk.as3.stage.StageManagerEvent;
	import railk.as3.utils.Utils;
	import railk.as3.tween.process.*;
	
	
	
	public class ScrollBar extends DynamicRegistration  {
		
		//______________________________________________________________________________ VARIABLES STATIQUES
		public static var scrollList           :Object={};
		
		//________________________________________________________________________________________ VARIABLES
		private var scrollContainer            :Sprite;
		private var slider                     :*;
		private var scrollBG                   :GraphicShape;
		private var scrollSize                 :Object;
		private var scrollColor                :Object; 
		private var customSlider               :Boolean;
		private var wheelEnable                :Boolean;
		private var resizeEnable               :Boolean;
		private var autoCheckEnable            :Boolean;
		private var autoScrollEnable           :Boolean;
		private var content                    :*;
		private var contentCheck               :Object={};
		private var multiplier                 :Number;
		private var distance                   :Number;
		private var way                        :String;
		private var rect                       :Rectangle;
		private var oldStageH                  :Number;
		private var oldStageW                  :Number;
		
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
		public function ScrollBar( name:String, orientation:String, toScroll:*, colors:Object, sizes:Object, alphas:Object = null, wheel:Boolean = false , sliderClass:Class = null, resizeAble:Boolean = false, autoCheck:Boolean = false, autoScroll:Boolean = false ):void 
		{
			scrollList[name] = this;
			wheelEnable = wheel;
			resizeEnable = resizeAble;
			autoCheckEnable = autoCheck;
			autoScrollEnable = autoScroll;
			content = toScroll;
			scrollSize = sizes;
			scrollColor = colors;
			
			scrollContainer = new Sprite();
			scrollContainer.alpha = 0;
			scrollContainer.name = "container";
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
				
				
			//--resize
			if( resizeEnable ){
				StageManager.addEventListener( StageManagerEvent.ONSTAGERESIZE, manageEvent, false, 0, true );
				oldStageH = StageManager.H;
				oldStageW = StageManager.W;
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
			if ( orientation == "V" ) {
				way = orientation;
				if ( content.height > StageManager.H ) {
					showHide(1,true);
					distance = content.height - StageManager.H;
					multiplier = distance / ( sizes.fH - sizes.sH );
					rect = new Rectangle(0, 0, 0, sizes.fH - sizes.sH);
					////////////////////////////////////
					initListeners();
					listeners = true;
					////////////////////////////////////
				}
				else { showHide(0,false); }
			}
			else if ( orientation == "H" ) {
				way = orientation;
				if ( content.width > StageManager.W ) {
					showHide(1,true);
					distance = content.width - StageManager.W;
					multiplier = distance / ( sizes.fW - sizes.sW );
					rect = new Rectangle(0, 0, sizes.fW - sizes.sW, 0);
					////////////////////////////////////
					initListeners();
					listeners = true;
					////////////////////////////////////
				}
				else {
					showHide(0,false);
				}
			}
			
			if ( alphas != null ) {
				scrollBG.alpha = alphas.fond;
				slider.alpha = alphas.slider;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			scrollContainer.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			scrollContainer.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			scrollContainer.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			if ( wheelEnable ) { StageManager._stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true ); }
			StageManager._stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			scrollContainer.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			scrollContainer.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			scrollContainer.removeEventListener( MouseEvent.CLICK, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			if ( wheelEnable ) { StageManager._stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent ); }
			StageManager._stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize():void 
		{
			if ( way == "V" ) {
				if ( content.height > StageManager.H ) {
					scrollContainer.visible = true;
					showHide(1, true);
					if ( slider.y >= oldStageH - slider.height ) { slider.y = StageManager.H - slider.height; }
					else { slider.y = ( slider.y * StageManager.H ) / oldStageH; }
					
					scrollBG.height = ( scrollSize.fH * StageManager.H ) / oldStageH;
					rect = new Rectangle(0, 0, 0, scrollBG.height - scrollSize.sH);
					distance = content.height - StageManager.H;
					multiplier = distance / ( scrollBG.height - scrollSize.sH );
					oldStageH = StageManager.H;
					scrollSize.fH = scrollBG.height;
					
					if(!listeners){
						////////////////////////////////////
						initListeners();
						listeners = true;
						////////////////////////////////////
					}	
				}	
				else {
					Process.to( slider, .4, { y:0 }, { onUpdate: function() { content.y = -(slider.y * multiplier); } } );
					showHide(0, false);
					////////////////////////////////////
					delListeners();
					listeners = false;
					////////////////////////////////////
				}	
			}
			else if ( way == "H" ) {
				if ( content.height > StageManager.H ) {
					showHide(1, true);
					if ( slider.x >= oldStageW - slider.width ) { slider.x = StageManager.W - slider.width; }
					else { slider.x = ( slider.x * StageManager.W ) / oldStageW; }
					
					scrollBG.width = ( scrollSize.fW * StageManager.W ) / oldStageW; 
					rect = new Rectangle(0, 0, scrollBG.width - scrollSize.sW, 0);
					distance = content.height - StageManager.H;
					multiplier = distance / ( scrollBG.width - scrollSize.sW );
					oldStageW = StageManager.W;
					scrollSize.fW = scrollBG.width;
					
					if(!listeners){
						////////////////////////////////////
						initListeners();
						listeners = true;
						////////////////////////////////////
					}	
				}	
				else {
					Process.to( slider, .4, { x:0 } , { onUpdate: function() { content.x = -(slider.x * multiplier); } } );
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
			else Process.to( scrollContainer, .4, { alpha:alpha}, { onComplete:function() { scrollContainer.visible = visibility; } } );
		}	
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get ObjectToScroll():* { return content; }
		
		public function set ObjectToScroll( value:* ):void { content = value; }
		
		
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
				
				case StageManagerEvent.ONSTAGERESIZE :
					resize();
					break;
					
				case MouseEvent.CLICK :
					if ( way == "V" ) { 
						if ( mouseY >= rect.height ) { value = rect.height; }
						else if ( mouseY <= slider.height ) { value = 0; }
						else { value = mouseY - slider.height / 2; }
						Process.to( slider, .4, { y:value} );
						Process.to( content, .6, { y: -(value * multiplier)},{rounded:true} );
					}
					else if ( way == "H" ) {
						if ( mouseX >= rect.width ) { value = rect.width; }
						else if ( mouseX <= slider.width ) { value = 0; }
						else { value = mouseX - slider.width / 2; }
						Process.to( slider, .4, { x:value} );
						Process.to( content, .6, { x: -(value * multiplier)},{rounded:true} );
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
						StageManager._stage.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
						scrollContainer.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
					}	
					else {
						StageManager._stage.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
					}
					break;
					
				case MouseEvent.MOUSE_UP :
					var eEvent:MouseEvent = new MouseEvent( MouseEvent.ROLL_OUT, true,false, scrollContainer.x, scrollContainer.y, scrollContainer );
					if( evt.currentTarget.name == "slider" ){
						evt.currentTarget.stopDrag();
						StageManager._stage.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
						scrollContainer.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
					}
					else {
						StageManager._stage.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
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
							Process.to( slider, 1, { y:value},{ onUpdate: function() { content.y = -(slider.y * multiplier); } } );
						}
						else if ( way == "H" ) {
							if ( mouseX >= rect.width ) { value = rect.width; }
							else if ( mouseX <= slider.width ) { value = 0; }
							else { value = mouseX - slider.width / 2; }
							Process.to( slider, 1, { x:value},{onUpdate: function() { content.x = -(slider.x * multiplier); } } );
						}
					}
					else {
						if( way == "V" ) {
							Process.to( content,.3, { y: -(slider.y * multiplier) }, {rounded:true} );
						}
						else if( way == "H" ) {
							Process.to( content,.3, { x: -(slider.x * multiplier)}, {rounded:true } );
						}
					}
					break;
					
				case MouseEvent.MOUSE_WHEEL :
					
					if ( way == "V" ) {
						if ( slider.y >= 0 + evt.delta*14  && slider.y <= rect.height+ evt.delta*14  ) {
							Process.to( slider, .4, { y: slider.y - (evt.delta * 14)} , { onUpdate: function() { content.y = -(slider.y * multiplier); } } );
						}
						else if( slider.y < 0 + evt.delta*14 ) {
							Process.to( slider, .4, { y: 0}, {onUpdate: function() { content.y = -(slider.y * multiplier); } } );
						}
						else if ( slider.y > rect.height + evt.delta*14 ) {
							Process.to( slider, .4, { y:rect.height }, {onUpdate: function() { content.y = -(slider.y * multiplier); } } );
						}
					}
					else if ( way == "H" ) {
						if ( slider.x >= 0 + evt.delta*14 && slider.x <= rect.width + evt.delta*14 ) {
							Process.to( slider, .4, { x: slider.x - (evt.delta * 14)} , {onUpdate: function() { content.x = -(slider.x * multiplier); } } );
						}
						else if( slider.x < 0 + evt.delta*14 ) {
							Process.to( slider, .4, { x: 0 }, {onUpdate: function() { content.x = -(slider.x * multiplier); } } );
						}
						else if ( slider.x > rect.height+evt.delta*14 ) {
							Process.to( slider, .4, { x:rect.width }, { onUpdate: function() { content.x = -(slider.x * multiplier); } } );
						}
					}
					break;
			}
		}
	}
}