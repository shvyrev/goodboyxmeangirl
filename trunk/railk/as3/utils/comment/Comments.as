/**
* 
* comment system
* 
* @author Richard rodney
* @version 0.1
* 
* TODO
* 	gestion des notes/pertinence de chaque commentaire
* 	verification de la validité des champ website et email
* 	edition d'un commentaire
* 	repondre a un commentaire
* 
*/

package railk.as3.utils.comment {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.loader.MultiLoader;
	import railk.as3.data.loader.MultiLoaderEvent;
	import railk.as3.data.saver.XmlSaver;
	import railk.as3.data.saver.XmlSaverEvent;
	import railk.as3.data.parser.Parser;
	import railk.as3.data.checker.FileCheck;
	import railk.as3.data.checker.FileCheckEvent;
	import railk.as3.utils.DynamicRegistration;
	import railk.as3.utils.ScrollBar;
	import railk.as3.utils.link.LinkManager;
	import railk.as3.utils.objectList.*;	
	import railk.as3.utils.StringValidation;
	import railk.as3.utils.Utils;
	import railk.as3.utils.Logger;
	
	import railk.as3.utils.comment.commentItem.Comment;
	import railk.as3.utils.comment.commentItem.Form;
	
	
	public class Comments extends DynamicRegistration {
		
		// _____________________________________________________________________________ VARIABLES RAPATRIEES
		private var _path                       		:String;
		private var _name                       		:String;
		private var _type                       		:String;
		private var _config                     		:Class;
		
		// _________________________________________________________________________________ VARIABLES LOADER
		private var loader              				:MultiLoader;
		
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var container                  			:DynamicRegistration;
		private var scroll                     			:ScrollBar;
		private var comments                            :DynamicRegistration;
		private var commentList                         :ObjectList;
		private var comment                             :Comment;
		private var form                                :Form;
		private var answerForm                          :Form;
		private var commentNode                         :Array;
		private var commentsXml                         :Array;
																	
		// ____________________________________________________________________________________ VARIABLES XML
		private var xmlSave                     		:XmlSaver;
		private var check                       		:FileCheck;
		
		// _______________________________________________________________________________ VARIABLES CONTROLE
		private var hasComments                         :Boolean=false;
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Comments( path:String, name:String, type:String, config:Class ):void {
			
			//--vars
			_path = path;
			_name = name;
			_type = type;
			_config = _config;
			
			//--conteneur
			container = new DynamicRegistration();
			addChild( container );
			
			//--commentList
			commentList = new ObjectList();
			
			//--xml saver
			xmlSave = new XmlSaver();
			xmlSave.addEventListener( XmlSaverEvent.ONCHECKCOMLETE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONLOADPROGRESS, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONLOADCOMPLETE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONSAVECOMLETE, manageEvent, false, 0, true );
			xmlSave.addEventListener( XmlSaverEvent.ONSAVEIOERROR, manageEvent, false, 0, true );
			
			//--multiloader
			loader = new MultiLoader( "comment", 'first' );
			loader.addEventListener( MultiLoaderEvent.ONMULTILOADERBEGIN, manageEvent, false, 0, true );
			loader.addEventListener( MultiLoaderEvent.ONMULTILOADERPROGRESS, manageEvent, false, 0, true );
			loader.addEventListener( MultiLoaderEvent.ONMULTILOADERCOMPLETE, manageEvent, false, 0, true );
			loader.addEventListener( MultiLoaderEvent.ONITEMCOMPLETE, manageEvent, false, 0, true );
			
			//--filechecker
			FileCheck.check( path +''+ name );
			FileCheck.addEventListener( FileCheckEvent.ONFILECHECKRESPONSE, manageEvent, false, 0, true );
			FileCheck.addEventListener( FileCheckEvent.ONFILECHECKERROR, manageEvent, false, 0, true );
			
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  CREATE COMMENT FORM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createLayout( mode:String ):void 
		{
			comments = new DynamicRegistration();
			if ( mode == 'empty' )
			{
				comment = new Comment( _config, mode );
				comments.addChild( comment );
			}
			else if ( mode == 'comment')
			{
				var H:int=0;
				for (var i:int = 0; i < commentsXml.length; i++) 
				{
					comment = new Comment( _config, mode )
					comment.id = commentsXml[i].id;
					comment.name = commentsXml[i].name;
					comment.mail = commentsXml[i].mail;
					comment.date = commentsXml[i].date;
					comment.website = commentsXml[i].website;
					comment.texte = commentsXml[i].texte;
					comment.x = 0; 
					comment.y = H;
					comments.addChild( comment );
					H += comment.height;
					///////////////////////////////////////////////
					commentList.add([commentsXml[i].id, comment]);
					///////////////////////////////////////////////
				}
			}
			
			form = new Form( _config );
			form.x = comments.x;
			form.y = comments.y + comments.height;
			
			container.addChild( comments );
			container.addChild( form )
			////////////////////
			initActions()
			////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  CREATE COMMENT FORM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createAnswerForm():void 
		{
			/*answerForm = new Form( _config );
			answerForm.x = ;
			answerForm.y = ;
			container.addChild( answerForm );*/
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  CREATE COMMENT FORM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function editComment():void 
		{
			//TODO
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  CREATE COMMENT FORM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function deleteComment( id:int ):void 
		{
			//commentList.remove( String( id ) );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		         GESTIONS DES ACTIONS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function initActions():void {
			LinkManager.add( 'reset', form.resetBT, { objets: { objet:form.resetBT, colors:null, action:null }, 'mouse', function(){ form.reset(); } });
			LinkManager.add( 'send', form.sendBT, { objets: { objet:form.sendBT, colors:null, action:null }, 'mouse', function(){ createXmlComment(); } } );
			LinkManager.add( 'view', form.viewBT, { objets: { objet:form.viewBT, colors:null, action:null }, 'mouse', function(){ form.view(); } } );
			LinkManager.add( 'mail', comment.mailBT, { objets: { objet:comment.mailBT, colors:null, action:null }, 'mouse', function(){ navigateToURL( new URLRequest('mailto:'+comment.mail), '_blank') };});
			LinkManager.add( 'website', comment.websiteBT, { objets: { objet:comment.websiteBT, colors:null, action:null }, 'mouse', function(){  navigateToURL( new URLRequest( comment.website ), '_blank'); } } });
			LinkManager.add( 'answer', comment.answerBT, { objets: { objet:comment.answerBT, colors:null, action:null }, 'mouse', function(){ createAnswerForm(); } } });
			LinkManager.add( 'note', comment.noteBT, { objets: { objet:comment.noteBT, colors:null, action:null }, 'mouse', function(){} } });
			LinkManager.add( 'delete', comment.deleteBT, { objets: { objet:comment.deleteBT, colors:null, action:null }, 'mouse', function(){ deleteComment(); } } });
			LinkManager.add( 'edit', comment.editBT, { objets: { objet:comment.editBT, colors:null, action:null }, 'mouse', function(){ editComment(); } } });
		}
		
		private function delActions():void {
			LinkManager.getLink('reset' ).dispose();
			LinkManager.getLink('send' ).dispose();
			LinkManager.getLink('view' ).dispose();
			LinkManager.getLink('mail' ).dispose();
			LinkManager.getLink('website' ).dispose();
			LinkManager.getLink('answer' ).dispose();
			LinkManager.getLink('note' ).dispose();
			LinkManager.getLink('delete' ).dispose();
			LinkManager.getLink('edit' ).dispose();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				ANALYSE COMMENT TEXTE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function analyseCommentTexte( texte:String ):String {
			var linkPattern:RegExp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
			linkPattern.exec( texte );
			return texte.replace( linkPattern, '<a href='+linkPattern.exec( texte )[0]+'>'+linkPattern.exec( texte )[0]+'</a>') );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   CREATE XML COMMENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createXmlComment( id:int=null ):void {
			commentNode = new Array();
			commentNode.push( { root:"comments", type:"comment", attribute:null, content:[ { type:"id", attribute:null, content:commentsXml.lenght+1  },
																							{ type:"name", attribute:null, content:form.name }, 
																							{ type:"mail", attribute:null, content:form.mail }, 
																							{ type:"date", attribute:null, content:Utils.date() },
																							{ type:"website", attribute:null, content:form.website },
																							{ type:"texte", attribute:null, content:analyseCommentTexte( form.texte ); }, 
																							{ type:"answer", attribute:null, content:String( id ) }, 
			});
			
			var zipMode:Boolean;
			if ( _type == 'zip' ) zipMode = true;
			else zipMode = false;
			
			xmlSave.create( _path + '' + _name, commentNode, true, zipMode );
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	   PARSE COMMENTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function parseComments( data:* ):void 
		{
			if ( _type == 'xml' )
			{
				commentsXml = Parser.XMLItem( new XML( data.toString()) );
			}
			else if (_type == 'zip' )
			{
				var loadedData:IDataInput = data ;
				var zipFile:ZipFile = new ZipFile(loadedData);
				for(var i:int = 0; i < zipFile.entries.length; i++) {
					var entry:ZipEntry = zipFile.entries[i];
					var data:ByteArray = zipFile.getInput(entry);
					
					switch( entry.name )
					{
						case _name+'.xml' :
							commentsXml = Parser.XMLItem( new XML( data.toString()) );
							break;
					}
				}
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 		  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			delActions()
			xmlSave.removeEventListener( XmlSaverEvent.ONCHECKCOMLETE, manageEvent );
			xmlSave.removeEventListener( XmlSaverEvent.ONLOADPROGRESS, manageEvent );
			xmlSave.removeEventListener( XmlSaverEvent.ONLOADCOMPLETE, manageEvent );
			xmlSave.removeEventListener( XmlSaverEvent.ONSAVECOMLETE, manageEvent );
			xmlSave.removeEventListener( XmlSaverEvent.ONSAVEIOERROR, manageEvent );
			loader.removeEventListener( MultiLoaderEvent.ONMULTILOADERBEGIN, manageEvent );
			loader.removeEventListener( MultiLoaderEvent.ONMULTILOADERPROGRESS, manageEvent );
			loader.removeEventListener( MultiLoaderEvent.ONMULTILOADERCOMPLETE, manageEvent );
			FileCheck.removeEventListener( FileCheckEvent.ONFILECHECKRESPONSE, manageEvent );
			FileCheck.removeEventListener( FileCheckEvent.ONFILECHECKERROR, manageEvent );
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				
				case FileCheckEvent.ONFILECHECKRESPONSE :
					trace( evt.info );
					if ( evt.rep == true ) {
						
						loader.add( ''+_path+''+_name, "com" );
						loader.start();
						
					}else {
						////////////////////////
						createLayout( 'empty' )
						////////////////////////
					}
					break;
					
				case FileCheckEvent.ONFILECHECKERROR :
					trace( evt.info );
					break;	
				
					
				case MultiLoaderEvent.ONMULTILOADERBEGIN :
					Logger.print( evt.info, Logger.MESSAGE );
					break;
					
				case MultiLoaderEvent.ONMULTILOADERPROGRESS :
					
					break;
					
				case MultiLoaderEvent.ONMULTILOADERCOMPLETE :
					Logger.print( evt.info, Logger.MESSAGE );
					if ( loader.role == 'first' ) {
						loader.role = 'reload';
						////////////////////////////
						parseComments( loader.getItemContent( 'com' ) );
						createLayout( 'comment' );
						////////////////////////////
					}
					else if ( loader.role = 'reload' ) {
						
					}
					break;	
					
			}
		}
		
	}
	
}