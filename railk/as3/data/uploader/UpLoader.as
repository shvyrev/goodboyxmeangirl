/**
* uploader gestion
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.uploader {
	
	import flash.display.Sprite;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.events.*;
	
	import railk.as3.data.uploader.UpLoaderEvent;
	import railk.as3.data.uploader.UpLoaderFilters;

	public class UpLoader extends Sprite {
		
		//________________________________________________________________________________ VARIABLES STATIQUES
		static private const uploadPHPFile :String = "php/upload.php";
		
		
		//________________________________________________________________________________ VARIABLES UPLOAD
		private var uploadURL              :URLRequest;
		private var uploadVAR              :URLVariables;
		private var fileRef                :FileReference;
		private var fileType               :String;
		
		private var uploadBT               :Sprite;
		
		//________________________________________________________________________________ VARIABLES EVENEMENT
		private var eEvent                 :UpLoaderEvent;
		
		
		/*----------------------------------------------------------------------------------------------------
		*
		*                                 II  NN    NN  II  TTTTTT
		*                                 II  NNNN  NN  II    TT
		*                                 II  NN  NNNN  II    TT
		*                                 II  NN    NN  II    TT
		* 
		*----------------------------------------------------------------------------------------------------*/
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function UpLoader():void {
			//init
			uploadURL = new URLRequest( uploadPHPFile );
			uploadURL.method = URLRequestMethod.POST;
			uploadVAR = new URLVariables();
			
			fileRef = new FileReference();
			configListenersFile( fileRef );
			
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 FILEREF LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function configListenersFile( dispatcher:IEventDispatcher ):void {
            dispatcher.addEventListener( Event.CANCEL, onCancel, false, 0, true );
			dispatcher.addEventListener( Event.SELECT, onSelect, false, 0, true );
			dispatcher.addEventListener( Event.OPEN, onBegin, false, 0, true );
			dispatcher.addEventListener( ProgressEvent.PROGRESS, onProgress, false, 0, true );
            dispatcher.addEventListener( Event.COMPLETE, onComplete, false, 0, true );
			dispatcher.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onDataUploaded, false, 0, true );
            dispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatus, false, 0, true );
			dispatcher.addEventListener( IOErrorEvent.IO_ERROR, onIOError, false, 0, true );
			dispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true );
        }
		
		private function delListenersFile( dispatcher:IEventDispatcher ):void {
			dispatcher.removeEventListener( Event.CANCEL, onCancel );
			dispatcher.removeEventListener( Event.SELECT, onSelect );
			dispatcher.removeEventListener( Event.OPEN, onBegin );
			dispatcher.removeEventListener( ProgressEvent.PROGRESS, onProgress );
            dispatcher.removeEventListener( Event.COMPLETE, onComplete );
			dispatcher.removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA,onDataUploaded );
            dispatcher.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatus );
			dispatcher.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			dispatcher.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
        }
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		  FILEREF LISTERNERS FONCTIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function onCancel( evt:Event ):void {
			//arguments du messages
			var args:Object = { info:"upload annule" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONCANCEL, args );
			dispatchEvent( eEvent );
		}
		
		private function onSelect( evt:Event ):void {
			//on lance l'upload du fichier
            fileRef.upload( uploadURL );
			
			//arguments du messages
			var args:Object = { info: fileRef.name };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONSELECT, args );
			dispatchEvent( eEvent );
		}
		
		private function onBegin( evt:Event ):void {
			//arguments du messages
			var args:Object = { info:"debut du transfert" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONBEGIN, args );
			dispatchEvent( eEvent );
		}
		
		private function onProgress( evt:ProgressEvent ):void {
			try
			{
				//calcul du pourcentage d'avancement
				var percent:Number = Math.floor(evt.bytesLoaded * 100 / evt.bytesTotal);
				//arguments du messages
				var args:Object = { info:percent };
				//envoie de l'evenement pour les listeners de uploader
				eEvent = new UpLoaderEvent( UpLoaderEvent.ONPROGRESS, args );
				dispatchEvent( eEvent );
				
			} catch(e:Error)
			{
				trace("Error: " + e.message)
				return;
			}	
			
		}
		
		private function onComplete( evt:Event ):void {
			//arguments du messages
			var args:Object = { info:"transfert termine" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONCOMPLETE, args );
			dispatchEvent( eEvent );
		}
		
		private function onDataUploaded( evt:DataEvent ):void {
			//arguments du messages
			var args:Object = { info:"data uploaded" };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONDATAUPLOADED, args );
			dispatchEvent( eEvent );
		}
		
		private function onHttpStatus( evt:HTTPStatusEvent ):void {
			//arguments du messages
			var args:Object = { info:evt };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONHTTPSTATUS, args );
			dispatchEvent( eEvent );
		}
		
		private function onIOError( evt:IOErrorEvent ):void {
			//arguments du messages
			var args:Object = { info:evt };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONIOERROR, args );
			dispatchEvent( eEvent );
		}
		
		private function onSecurityError( evt:SecurityErrorEvent ):void {
			//arguments du messages
			var args:Object = { info:evt };
			//envoie de l'evenement pour les listeners de uploader
			eEvent = new UpLoaderEvent( UpLoaderEvent.ONSECURITYERROR, args );
			dispatchEvent( eEvent );
		}
		
		
		
		
		/*----------------------------------------------------------------------------------------------------
		*
		*                      CCCCCC  RRRRRR  EEEEEE  AAAAAA  TTTTTT  EEEEEE      
		*                      CC      RR  RR  EE      AA  AA    TT    EE
		*                      CC      RRRR    EEEE    AAAAAA    TT    EEEE
		*                      CCCCCC  RR   R  EEEEEE  AA  AA    TT    EEEEEE
		* 
		*----------------------------------------------------------------------------------------------------*/
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						        CREATE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	button
		 * @param	type UpLoaderFilters.IMGFILE/TXTFILE/SWFFILE/XMLFILE/
		 * @param	url the folder where to save the file
		 */
		public function create( button:Sprite, type:String, urlFolder:String ):void {
			//choix du type de fichiers uploadable
			fileType = type;
			uploadBT = button;
			//indication de l'url de sauvegarde
			uploadVAR.folder = urlFolder;
			uploadURL.data = uploadVAR;
			//configutation des ecouteurs
			configListernersButton( uploadBT );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  BUTTON LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function configListernersButton( button:Sprite ):void {
			button.buttonMode = true;
			button.addEventListener( MouseEvent.CLICK, browse, false, 0, true );
		}
		
		private function delListenersButton( button:Sprite ):void {
			button.buttonMode = false;
			button.removeEventListener( MouseEvent.CLICK, browse );
		}
		

		private function browse( evt:MouseEvent ):void {
			var target = evt.currentTarget;
			fileRef.browse( [UpLoaderFilters.Type( fileType )] );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			      DELETE ALL LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function destroy():void {
			delListenersButton( uploadBT );
			delListenersFile( fileRef );
		}
		
		
		
		/*----------------------------------------------------------------------------------------------------
		*
		*                      GGGGGG  EEEEEE  TTTTTT  TTTTTT  EEEEEE  RRRRRR       
		*                      GG      EE        TT      TT    EE      RR  RR  
		*                      GG  GG  EEEE      TT      TT    EEEE    RRRR    
		*                      GGGGGG  EEEEEE    TT      TT    EEEEEE  RR   R  
		* 
		*----------------------------------------------------------------------------------------------------*/
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   GETTER FILENAME
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get fileName():String {
			return fileRef.name;
		}
		
		
	}
	
}