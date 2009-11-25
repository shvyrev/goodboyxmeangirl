/**
* Mp3 Player Engine
* 
* @author Richard Rodney.
* @version 0.2
*/

package railk.as3.sound
{	
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;	
	
	public class AudioPlayer extends EventDispatcher
	{
		private var url				:String;
		private var sound           :Sound;
		private var channel         :SoundChannel;
		private var volume          :SoundTransform;
		
		private var share     		:Boolean;
		private var download  		:Boolean;		
		
		private var ticker          :Shape = new Shape();
		public var loaded           :Number;
		public var played           :Number;
		private var total           :Number;
		
		private var share           :String
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function AudioPlayer() {
			sound = new Sound();
			volume = new SoundTransform();
			initListeners();
		}
		
		/**
		 * INIT
		 */
		public function init( share:Boolean = false, download:Boolean = false, externalDomain:Boolean=false ):void {
			this.download = download;
			this.share = share;
			this.externalDomain = externalDomain;
		}
		
		/**
		 * CREATE
		 */
		public function create( url:String, domain:String='' ):void {
			if (externalDomain) {
				Security.allowDomain(domain);
				Security.loadPolicyFile("http://+"domain+"/crossdomain.xml");
			}
			
			this.url = url;
			
			//--Sharing the player
			var path:String = ExternalInterface.call("window.location.href.toString");
			share = '<object width="'+width+'" height="'+height+'">';
			share += '<param name="allowscriptaccess" value="always" />';
			share += '< param name = "movie" value ="' + path + 'flash/'+name+'.swf" / >';
			share += '< embed src ="' + path + 'flash/'+name+'.swf" type="application/x-shockwave-flash"  allowscriptaccess="always" width="'+width+'" height="'+height+'" >';
			share += '</embed></object>';
		}
		
		/**
		 * LISTENERS
		 */
		private function initListeners():void { 
			ticker.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			channel.addEventListener( Event.SOUND_COMPLETE, manageEvent, false, 0, true );
			sound.addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
			sound.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
			sound.addEventListener( Event.OPEN, manageEvent, false, 0, true );
			sound.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
		}
		private function delListeners():void {
			ticker.removeEventListener( Event.ENTER_FRAME, manageEvent );
			channel.removeEventListener( Event.SOUND_COMPLETE, manageEvent );
			sound.removeEventListener( Event.COMPLETE, manageEvent );
			sound.removeEventListener( ProgressEvent.PROGRESS, manageEvent );
			sound.removeEventListener( Event.OPEN, manageEvent );
			sound.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
		}
		
		/**
		 * ACTIONS
		 */
		public function play():void {
			if(!channel) sound.load( url, new SoundLoaderContext(3000,true) );
			else channel = sound.play( channel.position );
		}
		
		public function pause():void {
			channel.stop();
		}
		
		public function replay():void {
			channel = sound.play(0);
		}
		
		public function seek(pos:Number,size:Number):void {
			channel = _sound.play( (pos*sound.length)/size );
		}
		
		public function volume(pos:Number, size:Number):void {
			volume.volume = (pos*100)/size;
			channel.soundTransform = volume;
		}
		
		public function downloadVideo():void {
			navigateToURL( new URLRequest( url ), '_blank' );
		}
		
		public function shareAudio():void {
			System.setClipboard( share );
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			delListeners();
			sound = null;
		}
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case Event.OPEN :
					channel = sound.play();
					channel.stop();
					break;
					
				case ProgressEvent.PROGRESS :
					if ( sound.isBuffering ) channel.stop();
					else channel = sound.play(channel.position)
					loaded = (evt.bytesLoaded/evt.bytesTotal)*100;
					dispatchEvent(evt);
					break;
					
				case Event.COMPLETE :
					loaded = 100;
					delListeners();
					dispatchEvent(evt);
					break;
					
				case Event.SOUND_COMPLETE : dispatchEvent(evt); break;
				
				case Event.ENTER_FRAME :
					current = Math.floor( channel.position );	
					total = Math.round( sound.length );
					played = current / total;
					dispatchEvent(evt);
					break;
					
				default : break;
			}
		}
	}	
}