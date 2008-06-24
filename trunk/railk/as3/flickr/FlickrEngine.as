/////////////////////////////////////////////////////////////////
//*************************************************************//
//*                   gestion flick                           *//
//*************************************************************//
/////////////////////////////////////////////////////////////////

package railk.as3.flickr {
	
	// ———————————————————————————————————————————————————————————————————————————————————————————————————————
	//                                                                                           IMPORT FLICKR
	// ———————————————————————————————————————————————————————————————————————————————————————————————————————
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.methodgroups.*;
	import com.adobe.webapis.flickr.events.*;
	
	// ———————————————————————————————————————————————————————————————————————————————————————————————————————
	//                                                                                            IMPORT FLASH
	// ———————————————————————————————————————————————————————————————————————————————————————————————————————
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	// ———————————————————————————————————————————————————————————————————————————————————————————————————————
	//                                                                                            IMPORT RAILK
	// ———————————————————————————————————————————————————————————————————————————————————————————————————————
	import railk.as3.flickr.FlickrEngineEvent;

	
	
	
	public class FlickrEngine extends EventDispatcher{

		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                                                                                           VARIABLES
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private var flickr                           :FlickrService;
		private var people                           :People;
		private var contact                          :Contacts;
		private var favorite                         :Favorites;
		private var url                              :Urls;
		private var interesting                      :Interestingness;
		private var photo                            :Photos;
		private var photoSet                         :PhotoSets;
		private var tag                              :Tags;
		private var auth                             :Auth;
		private var upLoader                         :Upload;
		
		private var frob                             :String;
		private var userId                           :String;
		
		private var oContacts                        :Array;
		private var oTags                            :Array;
		private var oPhotoSets                       :Array;
		private var oPhotos                          :Array;
		private var oPhoto                           :Object;
		private var oPhotoSizes                      :Array;
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                                                                                        CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function FlickrEngine( API_Key:String,API_Secret:String ):void {
			//--
			flickr = new FlickrService( API_Key );
			flickr.secret = API_Secret;
			//--
			people = new People( flickr );
			contact = new Contacts( flickr );	
			favorite = new Favorites( flickr );
			url = new Urls( flickr );
			//--
			photo = new Photos( flickr );
			photoSet = new PhotoSets( flickr );
			tag = new Tags( flickr );
			//--
			upLoader = new Upload( flickr );
			//--
			interesting = new Interestingness( flickr );
			
			
			//////////////////////TO DO///////////////////////////////
			//notes = new Notes( flickr );
			
			//initilisation des listeners
			initListenerEngine();
			//init
			oContacts = new Array();
			oTags = new Array();
			oPhotoSets = new Array();
			oPhoto = new Array();
			oPhotoSizes = new Array();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 															         GESTION LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListenerEngine():void {
			flickr.addEventListener(FlickrResultEvent.AUTH_GET_FROB, _onGetFrob);
			flickr.addEventListener(FlickrResultEvent.AUTH_GET_TOKEN, _onGetToken);
			flickr.addEventListener(FlickrResultEvent.PEOPLE_FIND_BY_USERNAME, _onGetNsid);
			flickr.addEventListener(FlickrResultEvent.TAGS_GET_LIST_USER, _onGetTags);
			flickr.addEventListener(FlickrResultEvent.CONTACTS_GET_PUBLIC_LIST, _onGetContacts);
			flickr.addEventListener(FlickrResultEvent.PHOTOSETS_GET_LIST, _onGetPhotoSetsList);
			flickr.addEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS, _onGetPhotosList);
			flickr.addEventListener(FlickrResultEvent.PHOTOS_GET_INFO, _onGetPhoto);
			flickr.addEventListener(FlickrResultEvent.PHOTOS_GET_SIZES, _onGetPhotoSizes);
		}
		
		public function delListenerEngine():void {
			flickr.removeEventListener(FlickrResultEvent.AUTH_GET_FROB, _onGetFrob);
			flickr.removeEventListener(FlickrResultEvent.AUTH_GET_TOKEN, _onGetToken);
			flickr.removeEventListener(FlickrResultEvent.PEOPLE_FIND_BY_USERNAME, _onGetNsid);
			flickr.removeEventListener(FlickrResultEvent.TAGS_GET_LIST_USER, _onGetTags);
			flickr.removeEventListener(FlickrResultEvent.CONTACTS_GET_PUBLIC_LIST, _onGetContacts);
			flickr.removeEventListener(FlickrResultEvent.PHOTOSETS_GET_LIST, _onGetPhotoSetsList);
			flickr.removeEventListener(FlickrResultEvent.PHOTOSETS_GET_PHOTOS, _onGetPhotosList);
			flickr.removeEventListener(FlickrResultEvent.PHOTOS_GET_INFO, _onGetPhoto);
			flickr.removeEventListener(FlickrResultEvent.PHOTOS_GET_SIZES, _onGetPhotoSizes);

		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 															            ACCES AUX NSID
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getUserId():void {
			people.findByUsername( "railk" );
		}
		
		private function _onGetNsid( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success )
				{
					userId = evt.data.user.nsid;
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONGETTINGNSID );
					dispatchEvent( eEvent );
				}
				else 
				{	
					trc( "error getting nsid" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGNSID );
					dispatchEvent( eEvent );
				}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 														ACCES A LA LISTE DES PHOTOSETS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getPhotoSetsList():void {
			photoSet.getList( userId );
		}
		
		private function _onGetPhotoSetsList( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success ){
					//est un array qui contient des objets( title/secret/id/server/farm)
					//--
					oPhotoSets = evt.data.photoSets;
					//--
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONGETTINGPHOTOSETSLIST );
					dispatchEvent( eEvent );
					
				}
				else 
				{
					trc( "error getting photosetsList" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGPHOTOSETSLIST );
					dispatchEvent( eEvent );
				}
		}
		
		public function get nbSets():int {
			return(oPhotoSets.length);
		}
		
		public function getSetId( num:int ):String {
			return(oPhotoSets[num].id);
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 											 ACCES A LA LISTE DES PHOTOS D'UN PHOTOSET
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getPhotosList( photoSetId:String ):void {
			photoSet.getPhotos( photoSetId );
		}
		
		private function _onGetPhotosList( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success ){
					//est un array qui contient des objet( id/secret/title/ ) 
					//--
					oPhotos = evt.data.photoSet.photos;
					//--
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONGETTINGPHOTOSLIST );
					dispatchEvent( eEvent );
					
				}
				else 
				{
					trc( "error getting photosetsList" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGPHOTOSLIST );
					dispatchEvent( eEvent );
				}
		}
		
		public function get nbPhotos():int {
			return(oPhotos.length);
		}
		
		public function getPhotoId( num:int ):String {
			return(oPhotos[num].id);
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 											 				 ACCES A UNE PHOTO PRECISE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getPhoto( photoId:String,num:int ):void {
			photo.getInfo( photoId,oPhotos[num].secret );
		}
		
		private function _onGetPhoto( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success ){
					//est un object qui contient title(string)/tags(array d'objet id/author/raw)/urls(array d'objet url)/
					//description/commentCount/dateTaken/notes(array) 
					//--
					oPhoto = evt.data.photo;
					//--
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONGETTINGPHOTO );
					dispatchEvent( eEvent );
					
				}
				else 
				{
					trc( "error getting photosetsList" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGPHOTO );
					dispatchEvent( eEvent );
				}
		}
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 											      URI DES DIFFERENTES TAILLES DE PHOTO
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getPhotoSizes( photoId:String ):void {
			photo.getSizes( photoId  );
		}
		
		private function _onGetPhotoSizes( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success ){
					//--
					oPhotoSizes = evt.data.photoSizes;
					//--
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONGETTINGPHOTOSIZES );
					dispatchEvent( eEvent );
					
				}
				else 
				{
					trc( "error getting photosetsList" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGPHOTOSIZES );
					dispatchEvent( eEvent );
				}
		}
		
		/**
		* 
		* @param	type qui est 0:square/1:thumb/2:small/3:medium/4:large
		* @return
		*/
		public function choosePhotoSize( type:int ):String {
			return("php/getImage.php?file="+oPhotoSizes[type].source);
			//return(oPhotoSizes[type].source);
		}
				
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 											                 ACCES A LA LISTE DES TAGS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getTags():void {
			tag.getListUser( userId );
		}
		
		private function _onGetTags( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success ){
					//array qui contients des objets( tag )
					//--
					oTags = evt.data.user.tags;
				}
				else 
				{
					trc( "error getting tagList" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGTAGS );
					dispatchEvent( eEvent );
				}
		}
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                 														 ACCES A LA LISTE DES CONTACTS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getContacts():void {
			contact.getPublicList( userId );
		}
		
		private function _onGetContacts( evt:FlickrResultEvent ):void {
			var eEvent:FlickrEngineEvent;

				if ( evt.success ){
					//array qui contients des objets( nsid/username )
					//--
					oContacts = evt.data.contacts;
				}
				else 
				{
					trc( "error getting contactList" );
					eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGCONTACTS );
					dispatchEvent( eEvent );
				}
		}
		
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                                                              CONNECTION AU SERVICE FLICKR PAR LOGIN
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//recuperation du  frob
		public function connect():void {
				auth = new Auth( flickr );
				auth.getFrob();
		}

		//event when getting the frob
		private function _onGetFrob( evt:FlickrResultEvent ):void {
				var eEvent:FlickrEngineEvent;

				if ( evt.success ){

						frob = evt.data.frob;
						trace( frob );
						//var urlConnexion = flickr.getLoginURL( frob, AuthPerm.WRITE );
						//navigateToURL( new URLRequest( urlConnexion ), "_blank" );

						validConnection();
				}
				else {
						trc( "error getting frob" );
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGFROB );
						dispatchEvent( eEvent );
				}
		}

		//get the token when user is registered
		public function validConnection():void {
				auth.getToken( frob );
				trace( flickr.permission );
		}

		//event when getting the token
		private function _onGetToken( evt:FlickrResultEvent ):void {
				var eEvent:FlickrEngineEvent;

				if ( evt.success ){
						var authResult:AuthResult = AuthResult( evt.data.auth );

						id = authResult.user.nsid;

						trc( "user id="+id );
						trc( "user perms="+authResult.perms );

						flickr.token = authResult.token;
						flickr.permission = authResult.perms;

						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONCONNECTED );
						this.dispatchEvent( eEvent );

				}
				else {
						trc( "error getting token" );
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ONERRORGETTINGTOKEN );
						this.dispatchEvent( eEvent );
				}
		}

		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		//                																			     TRACE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function trc( ...statements ):void {
				trace("FLICKRENGINE : "+statements.join(", "));
		}

	}
}		