/**
* 
* Interface for the FLVPLAYER layout configutation
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.video.flvplayer
{
	
	public interface IConfig
	{
		function createBG():Object;
		function createBGimage():Object; 
		function createMask():Object; 
		function createLoading():Object;
		function createPlayPauseButton():Object;
		function createReplayButton():Object;
		function createBufferBar():Object; 
		function createSeekBar():Object; 
		function createSeeker():Object;
		function createVolumeBarBG():Object;
		function createVolumeBar():Object;
		function createVolumeButton():Object;
		function createVolumeSeeker():Object;
		function createFullscreenButton():Object;
		function createX2Button():Object; 
		function createShareButton():Object;
		function createSharePanel( share:String ):Object; 
		function createDownloadButton():Object;
		function createScreenshotButton():Object; 
		function createPlayListButton():Object;
		function createPlayList():Object;
		function createBulle():Object;
		function createTime():Object;
		function createResizeButton():Object;
	}
	
}