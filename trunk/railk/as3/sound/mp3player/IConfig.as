/**
* 
* Interface for the MP3PLAYER layout configutation
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.sound.mp3player
{
	import railk.as3.display.DSprite;
	
	public interface IConfig
	{
		function init( width:Number, height:Number, fonts:Object, share:String ):void;
		function createBG():DSprite;
		function createMask():DSprite; 
		function createPlayPauseButton():DSprite;
		function createBufferBar():DSprite; 
		function createSeekBar():DSprite; 
		function createSeeker():DSprite;
		function createVolumeBarBG():DSprite;
		function createVolumeBar():DSprite;
		function createVolumeButton():DSprite;
		function createVolumeSeeker():DSprite;
		function createShareButton():DSprite;
		function createSharePanel( share:String ):DSprite; 
		function createDownloadButton():DSprite;
		function createPlayListButton():DSprite;
		function createPlayList():DSprite;
		function createBulle():DSprite;
		function createTime():DSprite;
	}
	
}