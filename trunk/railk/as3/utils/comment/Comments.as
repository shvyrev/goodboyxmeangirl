/**
* 
* comment system
* 
* @author Richard rodney
*/

package railk.as3.utils.comment {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import railk.as3.utils.DynamicRegistration;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.stage.StageManager;
	import railk.as3.data.loader.MultiLoader;
	import railk.as3.data.loader.MultiLoaderEvent;
	import railk.as3.data.saver.XmlSaver;
	import railk.as3.data.saver.XmlSaverEvent;
	import railk.as3.data.parser.Parser;
	import railk.as3.data.checker.FileCheck;
	import railk.as3.data.checker.FileCheckEvent;
	
	import railk.as3.utils.comment.CommentsEvent;
	
	// ______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	
	
	
	public class Comments extends Sprite {
		
		// ________________________________________________________________________________ VARIABLES LOADER
		private var loader              		:MultiLoader;
		
		// _______________________________________________________________________________ VARIABLES COMMENT
		private var comments                    :Sprite;
		private var cPseudo                     :TextField;
		private var cMail                       :TextField;
		private var cTexte                      :TextField;
		private var cDate                       :TextField;
		
		// __________________________________________________________________________________ VARIABLES FORM
		private var form                        :Sprite;
		private var fPseudo                     :TextField;
		private var fMail                       :TextField;
		private var fTexte                      :TextField;
		private var fDate                       :TextField;
		private var reset                       :Sprite;
		private var send                        :Sprite
		
		// ________________________________________________________________________________ VARIABLES SCROLL
		private var scroll                      :Sprite;
		
		// _______________________________________________________________________________________ VARIABLES
		private var container                   :DynamicRegistration;
		private var fontClasses                 :Object;
		private var files                       :Array;
		private var current                     :int;
		
		// ___________________________________________________________________________________ VARIABLES XML
		private var xmlSave                     :XmlSaver;
		private var check                       :FileCheck;
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Comments():void {
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   INITIALISATION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create( __current__:int, __files__:Array, __fontClasses__:Object  ):void {
			
			//--vars
			current = __current__;
			files = __files__;
			fontClasses = __fontClasses__;
			
			//--conteneur
			container = new DynamicRegistration();
			container.name = "container";
			addChild( container );
			
			//--xml saver
			xmlSave = new XmlSaver();
			xmlSave.addEventListener( XmlSaverEvent.ONCHECKCOMLETE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONLOADPROGRESS, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONLOADCOMPLETE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONSAVEBEGIN, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONSAVECOMLETE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONSAVEIOERROR, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONCREATE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONUPDATE, manageEvent, false, 0, true );
			
			//--multiloader
			loader = new MultiLoader( "comment" );
			loader.addEventListener( MultiLoaderEvent.ONMULTILOADERBEGIN, manageEvent, false, 0, true );
			loader.addEventListener( MultiLoaderEvent.ONMULTILOADERPROGRESS, manageEvent, false, 0, true );
			loader.addEventListener( MultiLoaderEvent.ONMULTILOADERCOMPLETE, manageEvent, false, 0, true );
			loader.addEventListener( MultiLoaderEvent.ONITEMCOMPLETE, manageEvent, false, 0, true );
			
			//--filechecker
			FileCheck.check( files[current].texte );
			FileCheck.addEventListener( FileCheckEvent.ONFILECHECKRESPONSE, manageEvent );
			FileCheck.addEventListener( FileCheckEvent.ONFILECHECKERROR, manageEvent );
			
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  CREATE COMMENTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createComments( com:Array ):void {
			trace( comments )
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  CREATE COMMENT FORM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createForm():void {
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				CREATE OVERALL SCROLL
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createScroll():void {
			
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 		  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				
				case FileCheckEvent.ONFILECHECKRESPONSE :
					trace( evt.info );
					if ( evt.rep == true ) {
						
						loader.add( files[current].texte, "first" );
						loader.start();
						
					}else {
						//////////////////////////////////////
						createComments( null );
						createForm();
						createScroll();
						//////////////////////////////////////
					}
					break;
					
				case FileCheckEvent.ONFILECHECKERROR :
					trace( evt.info );
					break;	
				
				case MultiLoaderEvent.ONITEMBEGIN :
					trace( evt.info );
					break;
					
				case MultiLoaderEvent.ONITEMPROGRESS :
					trace( evt.info );
					break;
					
				case MultiLoaderEvent.ONITEMCOMPLETE :
					trace( evt.info );
					if ( evt.item.name == "first" ) {
						//////////////////////////////////////
						createComments( null );
						createForm();
						createScroll();
						//////////////////////////////////////
					}
					else if ( evt.item.name == "reload" ) {
						
					}
					break;
					
				case MultiLoaderEvent.ONMULTILOADERBEGIN :
					trace( evt.info );
					break;
					
				case MultiLoaderEvent.ONMULTILOADERPROGRESS :
					trace( evt.info );
					break;
					
				case MultiLoaderEvent.ONMULTILOADERCOMPLETE :
					trace( evt.info );
					break;	
			}
		}
		
	}
	
}