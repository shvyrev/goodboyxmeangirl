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
		static public const ONCOMMENTPOST                   :String = "onCommentPost";
		
		
		// ��������������������������������������������������������������������������������������������������
		// 																						 CONSTRUCTEUR
		// ��������������������������������������������������������������������������������������������������
		public function CommentsEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				//on r�cup�re les variables pass�es en param�tres
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}