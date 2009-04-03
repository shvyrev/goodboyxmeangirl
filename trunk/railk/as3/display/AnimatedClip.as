/**
* Animatedclip class with frame and script
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.display
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	
	public class AnimatedClip extends RegistrationPoint
	{
		public var frames:int = 0;
		private var _frameRate:Number=1;
		private var _current:DListNode;
		private var framesList:DLinkedList;
		private var walker:DListNode;
		private var t:Timer;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function AnimatedClip( frames:int = 1 ):void {
			super();
			this.frames = frames;
			framesList = new DLinkedList();
			for ( var i:int=0; i < frames; i++ ){
				framesList.add( [String(i),null] );
			}
			_current = framesList.head;
			t = new Timer(1);
			t.addEventListener( TimerEvent.TIMER, manageEvent, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		 PLAY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function play( frameRate:int=1 ):void {
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
			_current = framesList.getNodeByID( frame );
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
			framesList.getNodeByID( frame ).data = data;
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
			if ( type == 'before' ) framesList.insertBefore( framesList.getNodeByID( place ), String(place - 1), data, "", script );
			else if ( type == 'after' ) framesList.insertAfter( framesList.getNodeByID( place ), String(place + 1), data, "", script );
			_frames += 1;
		}
		
		public function removeFrame( frame:int ):void {
			framesList.remove( String( frame ) );
			_frames -= 1;
		}
		
		public function addFrameScript( frame:int, script:Function ):void {
			framesList.getNodeByID( frame ).action = script;
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
			walker = framesList.head;
			loop:while ( walker ) {
				walker.dispose();
				walker = walker.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:TimerEvent ):void {
			switch( evt.type ){
				case TimerEvent.TIMER :
					pushFrameOnScreen();
					break;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get currentFrame():DListNode { return _current; }
		public function get frameRate():Number { return _frameRate; }
		public function set frameRate( value:Number ):void {
			_frameRate = value;
			t.delay = value
		}
		
	}
	
}