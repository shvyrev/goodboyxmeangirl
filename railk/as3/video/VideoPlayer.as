/**
*  VIDEO PLAYER rtmp/stream
* 
* @author Richard Rodney.
* @version 0.2
* 
*/

package railk.as3.video
{
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.utils.Timer;
	import railk.as3.display.UISprite;
	import railk.as3.utils.Logger;
	import railk.as3.utils.StringUtils;


	public class VideoPlayer extends UISprite
	{
		private static const EMPTY:String = "empty";
		private static const PLAYING:String = "playing";
		private static const PAUSED:String = "paused";
		private static const STOPPED:String = "stopped";
		
		private var video:Video;
		private var videoUrl:String;
		private var videoRect:Rectangle = new Rectangle();
		private var _videoWidth:int;
		private var _videoHeight:int;
		private var _videoMetaData:VideoMetadatas;
		private var type:String;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var sound:SoundTransform;
		private var loadTimer:Timer;
		private var playTimer:Timer;
		private var scrubbingIndex:int;
		private var stateBeforeScrubbing:String;
		private var activated:Boolean;
		private var loadBeforePlay:Boolean;
		private var autoPlay:Boolean;
		
		private var _videoState:String;
		private var _loaded:Number;
		private var _played:Number;
		private var _buffering:Boolean;


		public function VideoPlayer(width:int, height:int, autoPlay:Boolean=false, type:String="stream",domain:String="") { setup(width, height,autoPlay,type,domain); }
		
		private function setup(width:int, height:int, autoPlay:Boolean, type:String, domain:String):void {
			if (domain) {
				Security.allowDomain(domain);
				Security.loadPolicyFile(domain+"/crossdomain.xml");
			}
			
			this.type = type;
			this.autoPlay = autoPlay;
			_videoWidth = width;
			_videoHeight = height;
			scrubbingIndex = 0;
			loadBeforePlay = false;
			_videoState = EMPTY;
			
			//TIMERS
			loadTimer = new Timer(500);
			playTimer = new Timer(100);
			
			//VIDEO
			video = new Video(width, height);
			video.width = width;
			video.height = height;
			video.visible = false;
			video.smoothing = true;
			addChild(video);
			
			//CONNEXION
			nc = new NetConnection();
			
			/////////////////////
			initListeners();
			nc.connect(null);
			////////////////////
		}
		
		private function launch():void {
			//STREAM
			ns = new NetStream(nc);
			ns.bufferTime = 5;
			ns.client = this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			ns.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError, false, 0, true);
			
			//SOUND
			sound = new SoundTransform();
			ns.soundTransform = sound;
		}
		
		private function initListeners():void {
			playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer, false, 0, true);
			loadTimer.addEventListener(TimerEvent.TIMER, onLoadTimer, false, 0, true);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError, false, 0, true);
		}
		
		private function delListeners():void {
			playTimer.removeEventListener(TimerEvent.TIMER, onPlayTimer );
			loadTimer.removeEventListener(TimerEvent.TIMER, onLoadTimer);
			nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
			if (ns != null) {
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				ns.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			}
		}
		
		public function load(videoUrl:String):void {
			if (videoUrl == null) return
			this.videoUrl = videoUrl;
			_videoMetaData = null;
			
			if (autoPlay || loadBeforePlay) {
				ns.play(videoUrl);
				video.attachNetStream(ns);
				video.visible = true;
				activated = true;	
				loadTimer.start();
				playTimer.start();
			}
		}
		
		public function pause():void {
			if(!activated) return;
			ns.pause();
			playTimer.reset();
		}
		
		public function play():void{
			if(!activated) {
				loadBeforePlay = true;
				load(videoUrl);
				return;
			}
			if(_videoState == STOPPED) ns.seek(0);
			else ns.resume();
			playTimer.start(),
			_videoState = PLAYING
		}
		
		public function dispose():void {
			pause();
			video.clear();
			ns.close();
			nc.close();
			video.attachNetStream(null);
			video.visible = false;
			delListeners();
		}			
		
		public function seekPercent(seekPercent:Number, scrubbing:Boolean=false):void {
			if(seekPercent < 0) seekPercent = 0;
			if(seekPercent > ns.bytesLoaded/ns.bytesTotal) seekPercent = ns.bytesLoaded/ns.bytesTotal;
			if (!scrubbing) { 
				scrubbingIndex = 0;
				if(!playTimer.running) { playTimer.reset(); playTimer.start(); }
			}
			else ++scrubbingIndex;
			
			if(scrubbingIndex == 1) {
				stateBeforeScrubbing = videoState;
				if(_videoState == PLAYING || _videoState == STOPPED) { pause(); }
			}
			
			ns.seek(seekPercent * _videoMetaData.duration);
			
			if(!scrubbing) { if(stateBeforeScrubbing == PLAYING || stateBeforeScrubbing == STOPPED) play(); }
		}
		
		public function seek(seekTime:Number, scrubbing:Boolean = false):void {
			var seekPercent:Number = seekTime / _videoMetaData.duration;
			if(seekPercent < 0) seekPercent = 0;
			if(seekPercent > ns.bytesLoaded/ns.bytesTotal) seekPercent = ns.bytesLoaded/ns.bytesTotal;
			if (!scrubbing) { 
				scrubbingIndex = 0;
				if(!playTimer.running) { playTimer.reset(); playTimer.start(); }
			}
			else ++scrubbingIndex;
			
			if(scrubbingIndex == 1) {
				stateBeforeScrubbing = videoState;
				if(_videoState == PLAYING || _videoState == STOPPED) { pause(); }
			}
			
			ns.seek(seekTime);
			
			if(!scrubbing) { if(stateBeforeScrubbing == PLAYING || stateBeforeScrubbing == STOPPED) play(); }
		}
		
		public function onMetaData(data:Object):void {
			if(_videoMetaData == null)
			{
				_videoMetaData = new VideoMetadatas(data);
				if (!isNaN(videoMetaData.width) && !isNaN(videoMetaData.height)) {
					if(stage.displayState == StageDisplayState.FULL_SCREEN) resizeVideo(stage.stageWidth, stage.stageHeight);
					else resizeVideo(_videoWidth, _videoHeight);
				}
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_METADATA));
			}
		}
		
		/**
		 * RESIZE VIDEO
		 */
		public function resizeVideo(width:int = 0, height:int = 0):void {
			_videoWidth = width, _videoHeight = height;
			videoRect = getVideoRect(_videoMetaData.width,_videoMetaData.height);
			video.width = videoRect.width;
			video.height = videoRect.height;
			video.x = videoRect.x, video.y = videoRect.y;
		}
		
		private function getVideoRect(width:int, height:int):Rectangle {
			var vW:int = width;
			var vH:int = height;
			var scaling:Number = Math.min ( stage.stageWidth / vW, stage.stageHeight / vH );
			
			vW *= scaling, vH *= scaling;
			
			vH = (vH*_videoWidth)/vW;
			vW = _videoWidth;
			if (vH < _videoHeight) {
				vW = (vW*_videoHeight)/vH;
				vH = _videoHeight;
			}
			
			var posX:int = stage.stageWidth - vW >> 1;
			var posY:int = stage.stageHeight - vH >> 1;
			
			videoRect.x = posX;
			videoRect.y = posY;
			videoRect.width = vW;
			videoRect.height = vH;
			return videoRect;
		}
		
		/**
		 * TOGGLE PLAY PAUSE
		 */
		private function togglePlayPause():void {
			if(_videoState == PLAYING) pause();
			else if(_videoState == PAUSED || _videoState == EMPTY) play();
			else if(_videoState == STOPPED) { seek(0); play(); }
		}
		
		/**
		 * TICKERS
		 * @param	event
		 */
		private function onLoadTimer(event:TimerEvent):void {
			if(ns == null) return
			_loaded = (ns.bytesLoaded/ns.bytesTotal)*100;
			if(ns.bytesLoaded >= ns.bytesTotal) loadTimer.reset();
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_LOAD, _loaded));
		}
		
		private function onPlayTimer(event:TimerEvent):void {
			if(videoMetaData == null) return;
			_played  = (ns.time / videoMetaData.duration)*100;
			if (_videoState == STOPPED) playTimer.reset();
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_PROGRESS, _played));
		}
		
		/**
		 * ERRORS AND INFOS
		 */
		private function onAsyncError(e:ErrorEvent):void { Logger.log("onAsyncError() >>> " + e.text); }
		private function onError(e:ErrorEvent):void { Logger.log("onError() >>> " + e.text);	}
		private function onNetStatus(e:NetStatusEvent):void {
			Logger.log(e.info["code"]);
			switch(e.info["code"]) {
				case "NetStream.Play.Start": 
					if (_videoState != PAUSED) {
						_videoState = PLAYING;
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_START));
					}
					break;
				case "NetStream.Play.Stop": 
					_videoState = STOPPED; 
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STOP));
					break;
				case "NetStream.Buffer.Full": 
					_buffering = false;
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STOP_BUFFERING, _played));
					break;
				case "NetStream.Buffer.Empty": 
					_buffering = true;
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_START_BUFFERING, _played));
					break;
				case "NetConnection.Connect.Success": launch(); break;
				case "NetConnection.Connect.Failed": /*Logger.log(e.info["code"]);*/ break;
				default:break;
			}
		}
		
		/**
		 * UTILS
		 */
		public function get time():String {
			var seconds:Number = ns.time % 60;
			var minutes:Number = (ns.time - seconds) / 60;
			var heures:Number = int((ns.time - minutes) / 60);
			var secondsStr:String = seconds.toString().split(".")[0];
			secondsStr = StringUtils.padString(secondsStr, 2, "0");
			var minutesStr:String = StringUtils.padString(minutes.toString(), 2, "0");
			var heuresStr:String = StringUtils.padString(heures.toString(), 2, "0");
			return "00:"+minutesStr + ":" + secondsStr;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get videoMetaData():VideoMetadatas { return _videoMetaData; }
		public function get videoState():String { return _videoState; }
		public function get loaded():Number  { return _loaded; }
		public function get played():Number { return _played; }
		public function get videoWidth():int { return video.width; }
		public function set videoWidth(width:int):void{ video.width = _videoWidth = width; }
		public function get videoHeight():int { return video.height; }
		public function set videoHeight(height:int):void { video.height = _videoHeight = height; }
		public function get volume():Number { return sound.volume; }
		public function set volume(volume:Number):void {
			if (ns != null) {
				sound.volume = volume
				ns.soundTransform = sound;
			}
		}
	}
}
