/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import railk.as3.display.graphicShape.RectangleShape;
	import railk.as3.display.UISprite;
	
	public class VideoRectLoading extends UISprite
	{	
		public var playBar:RectangleShape;
		public var loadBar:RectangleShape;
		public var bg:RectangleShape;
		private var folower:*;
		
		private var _played:Number;
		private var _loaded:Number;
		
		public function VideoRectLoading(bgColor:uint,playedColor:uint,loadedColor:uint,x:Number,y:Number,width:Number,height:Number,folower:*=null) { 
			super();
			this.folower = folower;
			bg = new RectangleShape(bgColor, x, y, width, height);
			playBar = new RectangleShape(playedColor, x, y, .1, height);
			loadBar = new RectangleShape(loadedColor, x, y, .1, height);
			addChild(bg);
			addChild(loadBar);
			addChild(playBar);
		}
		
		public function get played():Number { return _played; }
		public function set played(value:Number):void {
			_played = value;
			playBar.width =  (value * bg.width) * .01;
			if(folower!=null) folower.x = playBar.width;
		}
		
		public function get loaded():Number { return _loaded; }
		public function set loaded(value:Number):void {
			_loaded = value;
			loadBar.width =  (value * bg.width) * .01;
		}
	}
}