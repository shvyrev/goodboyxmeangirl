/**
* 
* Interface for the MP3PLAYER layout configutation
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.son.mp3player
{
	import flash.display.BitmapData;
	import railk.as3.utils.DynamicRegistration;
	
	public interface IConfig
	{
		function init( width:Number, height:Number, fonts:Object, share:String, backgroundImage:BitmapData ):void;
		function createBG():DynamicRegistration;
		function createBGimage():DynamicRegistration; 
		function createMask():DynamicRegistration; 
		function createLoading():DynamicRegistration;
		function createPlayPauseButton():DynamicRegistration;
		function createReplayButton():DynamicRegistration;
		function createBufferBar():DynamicRegistration; 
		function createSeekBar():DynamicRegistration; 
		function createSeeker():DynamicRegistration;
		function createVolumeBarBG():DynamicRegistration;
		function createVolumeBar():DynamicRegistration;
		function createVolumeButton():DynamicRegistration;
		function createVolumeSeeker():DynamicRegistration;
		function createFullscreenButton():DynamicRegistration;
		function createX2Button():DynamicRegistration; 
		function createShareButton():DynamicRegistration;
		function createSharePanel( share:String ):DynamicRegistration; 
		function createDownloadButton():DynamicRegistration;
		function createScreenshotButton():DynamicRegistration; 
		function createPlayListButton():DynamicRegistration;
		function createPlayList():DynamicRegistration;
		function createBulle():DynamicRegistration;
		function createTime():DynamicRegistration;
		function createResizeButton():DynamicRegistration;
	}
	
}