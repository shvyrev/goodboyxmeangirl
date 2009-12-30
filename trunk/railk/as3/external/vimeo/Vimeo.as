/**
 * VimeoPlayer
 * 
 * A wrapper class for Vimeo's video player (codenamed Moogaloop)
 * that allows you to embed easily into any AS3 application.
 * 
 * Example on how to use:
 * 	var vimeo_player = new VimeoPlayer(2, 400, 300);
 * 	vimeo_player.addEventListener(Event.COMPLETE, vimeoPlayerLoaded);	
 * 	addChild(vimeo_player);
 * 
 * http://vimeo.com/api/docs/moogaloop
 */
package railk.as3.external.vimeo {
  
  import flash.net.URLRequest;
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.events.MouseEvent;
  import flash.utils.Timer;
  import flash.system.Security;
  import railk.as3.display.UISprite;
  
  public class Vimeo extends UISprite 
  {
		private var container:Sprite = new Sprite();
		private var moogaloop:Object = false;
		private var player_mask:Sprite = new Sprite();

		private var player_width:int = 400;
		private var player_height:int = 300;

		private var load_timer:Timer = new Timer(200);

		public function Vimeo(clip_id:int, w:int, h:int) {
			this.setDimensions(w, h);

			Security.allowDomain("http://www.vimeo.com"); //("http://bitcast.vimeo.com");

			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest("http://www.vimeo.com/moogaloop.swf?clip_id=" + clip_id + "&width=" + w + "&height=" + h + "&fullscreen=0"); //loader.load(new URLRequest("http://bitcast.vimeo.com/vimeo/swf/moogaloop.swf?server=vimeo.com&force_embed=0&clip_id=" + id + "&width=" + pWidth + "&height=" + pHeight));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request); 
		}

		private function setDimensions(w:int, h:int):void {
			player_width  = w;
			player_height = h;
		}

		private function onComplete(e:Event) {
			// Finished loading moogaloop
			container.addChild(e.target.loader.content);
			moogaloop = e.target.loader.content;

			// Create the mask for moogaloop
			addChild(player_mask);
			container.mask = player_mask;
			addChild(container);

			redrawMask();

			load_timer.addEventListener(TimerEvent.TIMER, playerLoadedCheck);
			load_timer.start();
		}

		/**
		 * Wait for Moogaloop to finish setting up
		 */
		private function playerLoadedCheck(e:TimerEvent):void {
			if (moogaloop.player_loaded) {
				// Moogaloop is finished configuring
				load_timer.stop();
				load_timer.removeEventListener(TimerEvent.TIMER, playerLoadedCheck);

				// remove moogaloop's mouse listeners listener
				moogaloop.disableMouseMove(); 
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);

				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		/**
		 * Fake the mouse move/out events for Moogaloop
		 */
		private function mouseMove(e:MouseEvent):void {
			if (e.stageX >= this.x && e.stageX <= this.x + this.player_width &&
				e.stageY >= this.y && e.stageY <= this.y + this.player_height) {
				moogaloop.mouseMove(e);
			}
			else {
				moogaloop.mouseOut();
			}
		}

		private function redrawMask():void {
			with (player_mask.graphics) {
				beginFill(0x000000, 1);
				drawRect(container.x, container.y, player_width, player_height);
				endFill();
			}
		}

		public function play():void {
			moogaloop.api_play();
		}

		public function pause():void {
			moogaloop.api_pause();
		}

		/**
		 * returns duration of video in seconds
		 */
		public function getDuration():int {
			return moogaloop.api_getDuration();
		}

		/**
		 * Seek to specific loaded time in video (in seconds)
		 */
		public function seekTo(time:int):void {
			moogaloop.api_seekTo(time);
		}

		/**
		 * Change the primary color (i.e. 00ADEF)
		 */
		public function changeColor(hex:String):void {
			moogaloop.api_changeColor(hex);
		}

		/**
		 * Load in a different video
		 */
		public function loadVideo(id:int):void {
			moogaloop.api_loadVideo(id);
		}

		public function setSize(w:int, h:int):void {
			this.setDimensions(w, h);
			moogaloop.api_setSize(w, h);
			this.redrawMask();
		}
	}
}