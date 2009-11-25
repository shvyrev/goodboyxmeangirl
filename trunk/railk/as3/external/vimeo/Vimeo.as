/**
 * VIMEO Player loader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.external.vimeo
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class Vimeo extends Sprite
	{
		public var id:String;
		public var pWidth :int;
		public var pHeight:int;
		
		private var loader:Loader;
		
		private var moogaloop:Sprite;
		private var moogaplayer:*;
		private var masker:Sprite;
		
		public function Vimeo(id:String, width:int=550, height:int=400):void {
			this.id = id;
			this.pWidth = width;
			this.pHeight = height;
			this.getPlayer( id );
		}

		private function getPlayer ( id:String ):void {
			Security.allowDomain("http://bitcast.vimeo.com");
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, manageEvent, false, 0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, manageEvent, false, 0, true);
			loader.load(new URLRequest("http://bitcast.vimeo.com/vimeo/swf/moogaloop.swf?server=vimeo.com&force_embed=0&clip_id=" + id + "&width=" + pWidth + "&height=" + pHeight));
		}

		public function getVideo( id:String ):void { if(moogaplayer) moogaplayer.api_loadVideo( id ); }
		public function getRandomVideo():void {
			var randomId:int = int( Math.random()*10000 + 260000);
			getVideo( String(randomId) );
		}

		public function play():void { if(moogaplayer) moogaplayer.api_play(); }
		public function stop():void { if(moogaplayer) moogaplayer.api_unload(); }
		public function dispose():void { 
			if (moogaplayer) moogaplayer.api_unload();
			loader.close();
		}
		
		private function manageEvent(evt:*):void {
			switch( evt.type ) {
				case ProgressEvent.PROGRESS : dispatchEvent(evt); break;
				case Event.COMPLETE :
					moogaloop = new Sprite();
					moogaplayer = moogaloop.addChild(evt.currentTarget.content);
					masker = new Sprite();
					masker.graphics.beginFill(0x000000);
					masker.graphics.drawRect(0,0,pWidth,pHeight);
					masker.graphics.endFill();
					
					addChild(masker);
					this.addChild(moogaloop);
					moogaloop.mask = masker;
					
					loader.unload();
					break;
				default : break;
			}
		}
	}
}