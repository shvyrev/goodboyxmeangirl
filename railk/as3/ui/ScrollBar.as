/**
* 
* Scrollbar
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.ui 
{	
	import flash.display.Stage
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import railk.as3.display.RegistrationPoint;
	
	
	public class ScrollBar extends RegistrationPoint 
	{	
		private var toScroll        :Object;		
		public var slider           :*;
		public var top   	        :*;
		public var bottom           :*;
		public var bg               :*;
		private var size            :Object;
		
		private var inited	        :Boolean;
		private var vScroll			:Boolean;
		private var vToScroll		:Boolean;
		private var wheel	        :Boolean;
		private var resize		    :Boolean;
		private var autoCheck		:Boolean;
		private var autoScroll		:Boolean;
		private var fullscreen		:Boolean;
		private var listeners       :Boolean;
		
		private var baseDelta		:Number=14;
		private var multiplier      :Number;
		private var delta			:Number;
		private var distance        :Number;
		private var rect 			:Rectangle;
		
		private var rollOver		:Function;
		private var rollOut			:Function;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * @param	toScroll            the object to scroll
		 * @param	vScroll				vertical or horizontal scrollbar
		 * @param	vToScroll			vertical or horizontal content scrolling
		 * @param	wheel				To activate the wheel or not
		 * @param	resize		        To give the possibility to the scrollbar to automaticaly resize itself base on the size of the screen
		 * @param	autoCheck           To make the scrollBar adapt itself automaticaly when the content size change
		 * @param	autoScroll          to follow the mouse when the mouse is hover the scrollbar.
		 * @param	fullScreen          to make the scrollbar fulllscreen
		 */
		public function ScrollBar( toScroll:Object, vScroll:Boolean = true, vToScroll:Boolean = true, wheel:Boolean = true, autoCheck:Boolean = true, resize:Boolean = true, fullScreen:Boolean = true, autoScroll:Boolean = false ) {
			super();
			this.name = 'scrollbar';
			this.toScroll = toScroll;
			this.wheel = wheel;
			this.resize = resize;
			this.autoCheck = autoCheck;
			this.autoScroll = autoScroll;
			this.fullscreen = fullScreen;
			this.vScroll = vScroll;
			this.vToScroll = vToScroll;
		}
		
		public function create(slider:*,bg:*=null,top:*=null,bottom:*=null,rollOver:Function=null,rollOut:Function=null):void {
			if (!slider) return;
			this.top = top;
			this.bottom = bottom;
			this.slider = slider;
			this.bg = bg;
			this.rollOver = rollOver;
			this.rollOut = rollOut;
			this.inited = true;
			this.addEventListener( Event.ADDED_TO_STAGE, setup, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								SETUP
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function setup( evt:Event ):void {
			if (!inited) throw new Error('scrollbar not inited please use the create function before addchild' );
			
			size={ 	bg:((vScroll)?stage.stageHeight:stage.stageWidth), 
					slider:slider.height, 
					stageHeight:stage.stageHeight,
					stageWidth:stage.stageWidth,
					toScrollHeight:toScroll.height,
					toScrollWidth:toScroll.width,
					toScrollX:toScroll.x,
					toScrollY:toScroll.y }
			
			if (bg && bg is Number) { size.bg = bg; } else if (bg) { size.bg = bg.height; bg.mouseEnabled = false; this.addChild( bg ); }	
			if (slider) { slider.name = "slider"; slider.buttonMode = true; this.addChild( slider ); }
			if (top) { top.y = this.y -2; addChild( top ); }
			if (bottom) { bottom.y = this.height + 2; addChild( bottom ); }
			if (resize) stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			if (autoCheck) this.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			if (autoScroll) this.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
				
			if ( size.toScrollY+toScroll.height > stage.stageHeight ) {
				showHide(1, true);
				distance = size.toScrollY+toScroll.height-stage.stageHeight;
				slider.height = ((size.bg-distance)>size.slider)?size.bg-distance:size.slider;
				multiplier = distance/(size.bg-slider.height);
				delta = baseDelta/(multiplier*.5);
				delta = (delta>6)?delta:6;
				rect = new Rectangle(0,0,0,size.bg-slider.height);
				////////////////////////////////////
				initListeners();
				listeners = true;
				////////////////////////////////////
			} 
			else showHide(0,false);
			
			this.rotation = (vScroll)?0:-90;
			this.removeEventListener( Event.ADDED_TO_STAGE, setup );
			trace(size['toScrollY']);
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			this.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			if ( wheel ) { stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true ); }
			stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			this.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			this.removeEventListener( MouseEvent.CLICK, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			if ( wheel ) { stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent ); }
			stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function _resize():void {
			if ( size.toScrollY+toScroll.height > stage.stageHeight ) {
				this.visible = true;
				showHide(1, true);
				
				if ( fullscreen ){
					if ( slider.y >= size.stageHeight-slider.height ) slider.y = stage.stageHeight-slider.height;
					else slider.y = ( slider.y * stage.stageHeight )/size.stageHeight;
					if (bg && bg is Number) bg = ( size.bg*stage.stageHeight )/size.stageHeight;
					else if (bg) bg.height = ( size.bg * stage.stageHeight )/size.stageHeight;
					if (bottom) bottom.y = bg.height+2;
				}
				
				size.bg = (bg)?((bg is Number)?bg:bg.height):(vScroll?stage.stageHeight:stage.stageWidth);
				size.stageHeight= stage.stageHeight;
				size.stageWidth= stage.stageWidth;
				distance = size.toScrollY+toScroll.height-stage.stageHeight;
				slider.height = ((size.bg-distance) > size.slider )?size.bg-distance:size.slider;
				multiplier = distance/( size.bg-slider.height );
				delta = baseDelta / ( multiplier*.5);
				delta = (delta > 6)? delta : 6;
				rect = new Rectangle(0,0,0,size.bg-slider.height );
				
				Engine.to( slider,.5,NaN,0,NaN,null,function():void { toScroll.y = size.toScrollY-(slider.y*multiplier); } );
				
				if(!listeners){
					////////////////////////////////////
					initListeners();
					listeners = true;
					////////////////////////////////////
				}	
			} else {
				Engine.to( slider,.4,NaN,y,NaN,null,function():void { toScroll.y= size.toScrollY-(slider.y*((multiplier)?multiplier:0)); } );
				showHide(0, false);
				////////////////////////////////////
				delListeners();
				listeners = false;
				////////////////////////////////////
			}			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   VISIBILITY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function showHide( alpha:Number, visibility:Boolean ):void {
			if(alpha) Engine.to( this, .4,NaN,NaN,alpha,function():void { this.visible = visibility; } );
			else Engine.to( this,.4,NaN,NaN,alpha,null,null,function():void { this.visible = visibility; } );
			if(top) top.alpha = alpha;
			if(bottom) bottom.alpha = alpha;
		}		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void  {
			var e:Engine, value:Number, p:String = (vToScroll)?'y':'x', s:String = (vToScroll)?'toScrollY':'toScrollX';
			switch( evt.type ) {
				case Event.ENTER_FRAME:
					if ( toScroll.height != size.toScrollHeight || toScroll.width != size.toScrollWidth ) {
						size.toScrollHeight = toScroll.height;
						size.toScrollWidth = toScroll.width;
						_resize();
					}
					break;
				case Event.RESIZE : _resize(); break;
				case MouseEvent.CLICK :
					if ( mouseY >= rect.height ) value = rect.height;
					else if ( mouseY <= slider.height ) value = 0;
					else value = mouseY-slider.height*.5;
					e=Engine.to( slider,.2,NaN,value);
					e=Engine.to( toScroll,.2,((vToScroll)?NaN:size[s]-(value*multiplier)),((vToScroll)?size[s]-(value*multiplier):NaN));
					evt.updateAfterEvent();
					break;
				case MouseEvent.ROLL_OVER : if(rollOver!=null) rollOver.apply(); break;
				case MouseEvent.ROLL_OUT : if(rollOut!=null) rollOut.apply(); break;
				case MouseEvent.MOUSE_DOWN :
					if ( evt.currentTarget.name == "slider" ) {
						evt.currentTarget.startDrag( false, rect );
						stage.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
						this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
					}	
					else stage.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
					break;
				case MouseEvent.MOUSE_UP :
					if( evt.currentTarget.name == "slider" ){
						evt.currentTarget.stopDrag();
						stage.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
						this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
					} else {
						stage.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
						this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
						manageEvent( new MouseEvent( MouseEvent.ROLL_OUT, true,false, this.x, this.y, this ) );
						stopDrag();
					}
					break;
				case MouseEvent.MOUSE_MOVE :
					if ( evt.currentTarget.name == "scrollBar" ) {
						if ( mouseY >= rect.height ) value = rect.height;
						else if ( mouseY <= slider.height ) value = 0;
						else value = mouseY - slider.height*.5;
						e=Engine.to(slider,0,((vToScroll)?NaN:value),((vToScroll)?value:NaN),NaN,null,function():void { toScroll[p]= size[s]-(slider.y*multiplier); } );
					} 
					else e=Engine.to( toScroll,0,((vToScroll)?NaN:size[s]-(slider.y*multiplier)),((vToScroll)?size[s]-(slider.y*multiplier):NaN) );
					break;
				case MouseEvent.MOUSE_WHEEL :
					if ( slider.y >= 0+evt.delta*delta  && slider.y <= rect.height+evt.delta*delta  ) e=Engine.to( slider,.4,NaN,slider.y-(evt.delta*delta),NaN,null,function():void  { toScroll[p] =size[s]-(slider.y*multiplier); });
					else if( slider.y < 0 + evt.delta*delta ) e=Engine.to( slider,.2,NaN,0,NaN,null,function():void { toScroll[p] =size[s]-(slider.y * multiplier); });
					else if ( slider.y > rect.height + evt.delta*delta ) e=Engine.to( slider,.2,NaN,rect.height,NaN,null,function():void { toScroll[p] =size[s]-(slider.y*multiplier); });
					break;
				default : break;
			}
		}
	}
}

import flash.utils.getTimer;
internal class Engine {
	private var t:Object;
	private var stm:Number;
	private var dr:Number
	private var props:Array=[];
	private var update:Function;
	private var complete:Function;
	
	public static function to(t:Object,dr:Number, x:Number=NaN, y:Number=NaN, a:Number=NaN, start:Function=null, update:Function=null, complete:Function=null):Engine {
		return new Engine(t,dr,x,y,a,start,update,complete);
	}
	
	public function Engine(t:Object,dr:Number,x:Number,y:Number,a:Number,start:Function,update:Function,complete:Function){
		this.stm = getTimer()*.001;
		this.t = t;
		this.dr = dr;
		this.update = update;
		this.complete = complete;
		if(!isNaN(x)) props.push( {p:'x',s:t.x,c:x-t.x} );
		if(!isNaN(y)) props.push( {p:'y',s:t.y,c:y-t.y} );
		if(!isNaN(a)) props.push( {p:'alpha',s:t.alpha,c:a-t.alpha} );
		if (start!=null) start.apply();
		t.addEventListener('enterFrame', u );
	}

	private function u(evt:*):void {
		var tm:Number = (getTimer()*.001-stm);
		if ( up(((tm>=dr)?1:((tm<=0)?0:e(tm,0,1,dr))))==1 ){
			t.removeEventListener('enterFrame', u );
			if (complete != null) complete.apply();
			props = null;
		}
	}
	
	private function up(r:Number):int{
		var i:int=props.length;
		while( --i > -1 ) t[props[i].p] = Math.round(props[i].s+props[i].c*r+1e-18-1e-18);
		if (update!=null) update.apply();
		return r;
	}
	
	private function e(t:Number,b:Number,c:Number,d:Number):Number { return c*t/d+b; }
}