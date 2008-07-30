/**
* 
* Interface for the MP3PLAYER layout configutation
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.son.mp3player
{
	import railk.as3.utils.DynamicRegistration;
	
	public interface IConfig
	{
		function init( width:Number, height:Number, fonts:Object, share:String ):void;
		function createBG():DynamicRegistration;
		function createMask():DynamicRegistration; 
		function createPlayPauseButton():DynamicRegistration;
		function createBufferBar():DynamicRegistration; 
		function createSeekBar():DynamicRegistration; 
		function createSeeker():DynamicRegistration;
		function createVolumeBarBG():DynamicRegistration;
		function createVolumeBar():DynamicRegistration;
		function createVolumeButton():DynamicRegistration;
		function createVolumeSeeker():DynamicRegistration;
		function createShareButton():DynamicRegistration;
		function createSharePanel( share:String ):DynamicRegistration; 
		function createDownloadButton():DynamicRegistration;
		function createPlayListButton():DynamicRegistration;
		function createPlayList():DynamicRegistration;
		function createBulle():DynamicRegistration;
		function createTime():DynamicRegistration;
	}
	
}