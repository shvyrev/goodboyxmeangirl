/////////////////////////////////////////////////////////////////
//*************************************************************//
//*                      flickrEngineEvent                    *//
//*************************************************************//
/////////////////////////////////////////////////////////////////

package railk.as3.flickr {
	// _______________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	// _______________________________________________________________________________________ CONSTRUCTEUR
	
	public class FlickrEngineEvent extends Event{
			
		// ___________________________________________________________________________________ VARIABLES STATIQUES
		static public const ONERRORGETTINGFROB               :String = "onErrorGettingFrob";
		static public const ONERRORGETTINGTOKEN              :String = "onErrorGettingToken";
		static public const ONERRORGETTINGNSID               :String = "onErrorGettingNsid";
		static public const ONGETTINGNSID                    :String = "onGettingNsid";
		static public const ONERRORGETTINGTAGS               :String = "onErrorGettingTags";
		static public const ONERRORGETTINGCONTACTS           :String = "onErrorGettingContacts";
		static public const ONERRORGETTINGPHOTOSETSLIST      :String = "onErrorGettingPhotoSetsList";
		static public const ONGETTINGPHOTOSETSLIST           :String = "onGettingPhotoSetsList";
		static public const ONERRORGETTINGPHOTOSLIST         :String = "onErrorGettingPhotosList";
		static public const ONGETTINGPHOTOSLIST              :String = "onGettingPhotosList";
		static public const ONERRORGETTINGPHOTO              :String = "onErrorGettingPhoto";
		static public const ONGETTINGPHOTO                   :String = "onGettingPhoto";
		static public const ONERRORGETTINGPHOTOSIZES         :String = "onErrorGettingPhotoSizes";
		static public const ONGETTINGPHOTOSIZES              :String = "onGettingPhotoSizes";
		static public const ONCONNECTED                      :String = "onConnected";
		
		// ___________________________________________________________________________________ VARIABLES
		public var data                                      :Object;
		
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function FlickrEngineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   GETNAME
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function getName():String {
				return currentTarget.getName() ;
		}
	}
}