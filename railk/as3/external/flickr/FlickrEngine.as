/**
* 
* Flickr Engine class
* 
* @author RICHARD RODNEY
* @version 0.2
*/

package railk.as3.external.flickr {
	
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.methodgroups.*;
	import com.adobe.webapis.flickr.events.*;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class FlickrEngine extends EventDispatcher
	{
		private var flickr                           :FlickrService;
		private var people                           :People;
		private var contact                          :Contacts;
		private var favorite                         :Favorites;
		private var url                              :Urls;
		private var interesting                      :Interestingness;
		private var photos                           :Photos;
		private var photoSet                         :PhotoSets;
		private var tag                              :Tags;
		private var notes                            :Notes;
		private var auth                             :Auth;
		private var upLoader                         :Upload;
		private var frob                             :String;
		private var userId                           :String;
		
		private var contactsList                     :Array;
		private var tagsList                         :Array;
		private var photoSetsList                    :Array;
		private var photosList                       :Array;
		private var photoSizesList                   :Array;
		private var photo                            :Object;
		
		private var eEvent                           :FlickrEngineEvent;
		private var eErrorEvent                      :FlickrEngineErrorEvent;
		
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                                                                                        CONSTRUCTEUR
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function FlickrEngine( API_Key:String, API_Secret:String )
		{
			flickr = new FlickrService( API_Key );
			flickr.secret = API_Secret;
			
			people = new People( flickr );
			contact = new Contacts( flickr );	
			favorite = new Favorites( flickr );
			url = new Urls( flickr );
			photos = new Photos( flickr );
			photoSet = new PhotoSets( flickr );
			tag = new Tags( flickr );
			upLoader = new Upload( flickr );
			interesting = new Interestingness( flickr );
			notes = new Notes( flickr );
			
			contactsList = new Array();
			tagsList = new Array();
			photoSetsList = new Array();
			photosList = new Array();
			photoSizesList = new Array();
			
			//////////////////////////////////
			initListeners();
			//////////////////////////////////
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 															         GESTION LISTENERS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function initListeners():void 
		{
			flickr.addEventListener( FlickrResultEvent.AUTH_GET_FROB, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.AUTH_GET_TOKEN, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.PEOPLE_FIND_BY_USERNAME, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.TAGS_GET_LIST_USER, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.CONTACTS_GET_PUBLIC_LIST, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.PHOTOSETS_GET_LIST, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.PHOTOSETS_GET_PHOTOS, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.PHOTOS_GET_INFO, manageEvent, false, 0, true );
			flickr.addEventListener( FlickrResultEvent.PHOTOS_GET_SIZES, manageEvent, false, 0, true );
		}
		
		public function delListeners():void 
		{
			flickr.removeEventListener( FlickrResultEvent.AUTH_GET_FROB, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.AUTH_GET_TOKEN, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.PEOPLE_FIND_BY_USERNAME, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.TAGS_GET_LIST_USER, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.CONTACTS_GET_PUBLIC_LIST, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.PHOTOSETS_GET_LIST, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.PHOTOSETS_GET_PHOTOS, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.PHOTOS_GET_INFO, manageEvent );
			flickr.removeEventListener( FlickrResultEvent.PHOTOS_GET_SIZES, manageEvent );

		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                                                              CONNECTION AU SERVICE FLICKR PAR LOGIN
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function connect():void 
		{
				auth = new Auth( flickr );
				auth.getFrob();
		}

		public function validConnection():void 
		{
			auth.getToken( frob );
			trace( flickr.permission );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 															            ACCES AUX NSID
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getUser( name:String ):void 
		{ 
			people.findByUsername( name );
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 														ACCES A LA LISTE DES PHOTOSETS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getPhotoSetsList():void 
		{ 
			photoSet.getList( userId ); 
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 											 ACCES A LA LISTE DES PHOTOS D'UN PHOTOSET
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getPhotosList( photoSetId:String ):void 
		{ 
			photoSet.getPhotos( photoSetId ); 
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 											 				 ACCES A UNE PHOTO PRECISE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getPhoto( photoId:String, num:int ):void 
		{ 
			photos.getInfo( photoId, photosList[num].secret ); 
		}

		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 											      URI DES DIFFERENTES TAILLES DE PHOTO
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getPhotoSizes( photoId:String ):void 
		{ 
			photos.getSizes( photoId  ); 
		}
		
		/**
		* 
		* @param	type qui est 0:square/1:thumb/2:small/3:medium/4:large
		* @return
		*/
		public function choosePhotoSize( type:int ):String 
		{
			return( photoSizesList[type].source);
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 											                 ACCES A LA LISTE DES TAGS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getTags():void 
		{ 
			tag.getListUser( userId ); 
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 														 ACCES A LA LISTE DES CONTACTS
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function getContacts():void 
		{ 
			contact.getPublicList( userId ); 
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                                                              							   DISPOSE
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function dispose():void
		{
			delListeners();
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                 															           	  MANAGE EVENT
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		private function manageEvent( evt:FlickrResultEvent ):void
		{
			var args:Object;
			switch( evt.type )
			{
				case FlickrResultEvent.AUTH_GET_FROB :
					if ( evt.success )
					{
						frob = evt.data.frob;
						trace( frob );
						//var urlConnexion = flickr.getLoginURL( frob, AuthPerm.WRITE );
						//navigateToURL( new URLRequest( urlConnexion ), "_blank" );
						validConnection();
					}
					else 
					{
						args = { info:"error getting frob" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_FROB_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.AUTH_GET_TOKEN :
					if ( evt.success ){
						var authResult:AuthResult = AuthResult( evt.data.auth );
						var id:String = authResult.user.nsid;
						flickr.token = authResult.token;
						flickr.permission = authResult.perms;
						
						args = { info:"connect� a flickr" };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_CONNECTED, args );
						dispatchEvent( eEvent );

					}
					else {
						args = { info:"error getting token" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_TOKEN_ERROR, args );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.PEOPLE_FIND_BY_USERNAME :
					if ( evt.success )
					{
						userId = evt.data.user.nsid;
						args = { info:"userid succes", data:userId };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_NSID, args  );
						dispatchEvent( eEvent );
					}
					else 
					{	
						args = { info:"error getting nsid" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_NSID_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.TAGS_GET_LIST_USER :
					if ( evt.success ){
						//array qui contients des objets( tag )
						tagsList = evt.data.user.tags;
						args = { info:"tags succes", data:tagsList };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_TAGS, args  );
						dispatchEvent( eEvent );
					}
					else 
					{
						args = { info:"error getting tags" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_TAGS_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.CONTACTS_GET_PUBLIC_LIST :
					if ( evt.success ){
						//array qui contients des objets( nsid/username )
						contactsList = evt.data.contacts;
						args = { info:"contacts succes", data:contactsList };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_CONTACTS, args  );
						dispatchEvent( eEvent );
					}
					else 
					{
						args = { info:"error getting contacts" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_CONTACTS_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.PHOTOSETS_GET_LIST :
					if ( evt.success ){
						//est un array qui contient des objets( title/secret/id/server/farm)
						photoSetsList = evt.data.photoSets;
						args = { info:"photosets succes", data:photoSetsList };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_PHOTOSETSLIST, args  );
						dispatchEvent( eEvent );
						
					}
					else 
					{
						args = { info:"error getting photosets" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_PHOTOSETSLIST_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.PHOTOSETS_GET_PHOTOS :
					if ( evt.success ){
						//est un array qui contient des objet( id/secret/title/ ) 
						photosList = evt.data.photoSet.photos;
						args = { info:"photos succes", data:photosList };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_PHOTOSLIST, args  );
						dispatchEvent( eEvent );
						
					}
					else 
					{
						args = { info:"error getting photos" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_PHOTOSLIST_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.PHOTOS_GET_INFO :
					if ( evt.success ){
						//est un object qui contient title(string)/tags(array d'objet id/author/raw)/urls(array d'objet url)/
						//description/commentCount/dateTaken/notes(array) 
						photo = evt.data.photo;
						args = { info:"photo succes", data:photo };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_PHOTO, args  );
						dispatchEvent( eEvent );
						
					}
					else 
					{
						args = { info:"error getting photo" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_PHOTO_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				case FlickrResultEvent.PHOTOS_GET_SIZES :
					if ( evt.success ){
						photoSizesList = evt.data.photoSizes;
						args = { info:"photoSizes succes", data:photoSizesList };
						eEvent = new FlickrEngineEvent( FlickrEngineEvent.ON_PHOTOSIZES, args  );
						dispatchEvent( eEvent );
						
					}
					else 
					{
						args = { info:"error getting photoSizes" };
						eErrorEvent = new FlickrEngineErrorEvent( FlickrEngineErrorEvent.ON_PHOTOSIZES_ERROR, args  );
						dispatchEvent( eErrorEvent );
					}
					break;
					
				default : break;
			}
		}
		
		
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		//                                                              						 GETTER/SETTER
		// 覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
		public function get nbSets():int { return( photoSetsList.length); }
		
		public function getSetId( num:int ):String { return( photoSetsList[num].id); }
		
		public function get nbPhotos():int { return( photosList.length); }
		
		public function getPhotoId( num:int ):String { return( photosList[num].id); }
		
	}
}		