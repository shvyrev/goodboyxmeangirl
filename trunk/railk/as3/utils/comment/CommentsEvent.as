/**
* 
* commentEvent systeme
* 
* @author Richard rodney
*/


package railk.as3.utils.comment {

	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;

	
	public dynamic class CommentsEvent extends Event{
			
		// _______________________________________________________________________________VARIABLES STATIQUES
		static public const ON_COMMENT_POST                   :String = "onCommentPost";
		static public const ON_COMMENT_EDIT                   :String = "onCommentEdit";
		static public const ON_COMMENT_DELETE                 :String = "onCommentDelete";
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function CommentsEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}