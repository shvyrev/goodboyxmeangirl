/**
* Animatedclip class with frame and script
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.display
{
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.objectList.ObjectList;
	import railk.as3.utils.objectList.ObjectNode;
	
	public class AnimatedClip extends RegistrationPoint
	{
		// ________________________________________________________________________________________ VARIABLES
		private var _frames                                               :int = 0;
		private var _frameRate                                            :Number;
		private var _current                                              :ObjectNode;
		private var framesList                                            :ObjectList;
		private var t                                                     :Timer;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AnimatedClip( frames:int=1 ):void {
			_frames = frames;
			framesList = new ObjectList();
			for ( var i:int=0; i < frames; i++ )
			{
				framesList.add( [String(i),null] );
			}
			_current = framesList.head;
			t = new Timer(1);
			t.addEventListener( TimerEvent.TIMER, manageEvent, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		 PLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function play( frameRate:int = 1 ):void {
			_frameRate = frameRate;
			t.delay = frameRate;
			t.start();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		 STOP
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function stop():void {
			t.stop();
			t.reset();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  FRAME SELECTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function goToFrame( frame:int ):void {
			_current = framesList.getObjectByID( frame );
			pushFrameOnScreen();
		}
		
		
		public function nextFrame():void {
			_current = _current.next;
			pushFrameOnScreen();
		}
		
		public function previousFrame():void {
			_current = _current.prev;
			pushFrameOnScreen();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE FRAME
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addFrameContent( frame:int, data:*, script:Function = null ):void {
			framesList.getObjectByID( frame ).data = data;
			pushFrameOnScreen();
		}
		
		/**
		 * 
		 * @param	type   'before' | 'after'
		 * @param	place
		 * @param	content
		 * @param	script
		 */
		public function addFrame( type:String, place:int, data:*= null, script:Function = null ):void {
			if ( type == 'before' ) framesList.insertBefore( framesList.getObjectByID( place ), String(place - 1), data, "", script );
			else if ( type == 'after' ) framesList.insertAfter( framesList.getObjectByID( place ), String(place + 1), data, "", script );
			_frames += 1;
		}
		
		public function removeFrame( frame:int ):void {
			framesList.remove( String( frame ) );
			_frames -= 1;
		}
		
		public function addFrameScript( frame:int, script:Function ):void {
			framesList.getObjectByID( frame ).script = script;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 PUSH FRAME ON SCREEN
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function pushFrameOnScreen():void {
			if( this.numChildren > 0 ) this.removeChildAt( 0 );
			this.addChild( _current.data );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			t.removeEventListener( TimerEvent.TIMER, manageEvent );
			for ( var i:int=0; i < framesList.length; i++ )
			{
				framesList.iterate( i ).dispose();
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:TimerEvent ):void {
			switch( evt.type )
			{
				case TimerEvent.TIMER :
					pushFrameOnScreen();
					break;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get currentFrame():ObjectNode { return _current; }
		
		public function get frames():int { return _frames; }
		
		public function set frames( value:int ):void { _frames = value; }
		
		public function get frameRate():Number { return _frameRate; }
		
		public function set frameRate( value:Number ):void {
			_frameRate = value;
			t.delay = value
		}
		
	}
	
}