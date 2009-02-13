/**
* 
* Interface for the FLVPLAYER layout configutation
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.video.flvplayer
{
	import flash.display.BitmapData;
	import railk.as3.display.DSprite;
	
	public interface IConfig
	{
		function init( width:Number, height:Number, fonts:Object, share:String, backgroundImage:BitmapData ):void;
		function createBG():DSprite;
		function createBGimage():DSprite; 
		function createMask():DSprite; 
		function createLoading():DSprite;
		function createPlayPauseButton():DSprite;
		function createReplayButton():DSprite;
		function createBufferBar():DSprite; 
		function createSeekBar():DSprite; 
		function createSeeker():DSprite;
		function createVolumeBarBG():DSprite;
		function createVolumeBar():DSprite;
		function createVolumeButton():DSprite;
		function createVolumeSeeker():DSprite;
		function createFullscreenButton():DSprite;
		function createX2Button():DSprite; 
		function createShareButton():DSprite;
		function createSharePanel( share:String ):DSprite; 
		function createDownloadButton():DSprite;
		function createScreenshotButton():DSprite; 
		function createPlayListButton():DSprite;
		function createPlayList():DSprite;
		function createBulle():DSprite;
		function createTime():DSprite;
		function createResizeButton():DSprite;
	}
	
}