/**
* 
* Static class LinkManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.link {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.link.LinkManagerEvent;
	import railk.as3.utils.link.linkItem.Link;
	
	// __________________________________________________________________________________ IMPORT LINKED LIST
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	// ____________________________________________________________________________________ IMPORT SWFADRESS
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	
	
	
	
	public class LinkManager extends Sprite {
		
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                             :EventDispatcher;
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var linkList                           :DLinkedList;
		private static var walker                             :DListNode;
		private static var itr                                :DListIterator;
		
		//_____________________________________________________________________________ VARIABLES LINKMANAGER
		private static var siteTitre                          :String;
		private static var swfAdress                          :Boolean=false;
		private static var state                              :String;
		
		//____________________________________________________________________________________ VARIABLES LINK
		private static var link                               :Link;
		
		// ________________________________________________________________________________ VARIABLE EVENEMENT
		private static var eEvent                             :LinkManagerEvent;
		
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  				 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( titre:String, swfAdressEnable:Boolean=false ):void {
			if(swfAdressEnable){
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, manageEvent );
				siteTitre = titre;
				swfAdress = swfAdressEnable
			}
			
			 linkList = new DLinkedList();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			 ADD LINK
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name                   nom du lien de type /.../.../...
		 * @param	displayObject		   displayObject clickable
		 * @param	displayObjectContent   Object de { nom:{ objet:dislplayObject , colors:{click:uint,out:uint,hover:uint}=null, action:Function(type="hover"|"out")=null } }
		 * @param	onClick                fonction qui se declenche lors du clik function( ..., type=String("do"|"undo") )
		 * @param	swfAdressEnable        est-ce que le liens utilise swfadress
		 */
		public static function add( name:String, displayObject:*, displayObjectContent:Object, onClick:Function = null, swfAdressEnable:Boolean = false ):void {
			var enable:Boolean;
			if ( swfAdress && swfAdressEnable ) { enable = true; }
			else if( swfAdress && !swfAdressEnable ) { enable = false; }
			else if( !swfAdress && swfAdressEnable ) { enable = false; }
			else if( !swfAdress && !swfAdressEnable ) { enable = false; }
			
			link = new Link( name, displayObject, displayObjectContent, onClick, enable );
			linkList.append( link );
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE LINKS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):Boolean {
			var result:Boolean;
			
			walker = linkList.head;
			//--
			while ( walker ) {
				//--
				var l:Link = walker.data ;
				if ( l.name == name ) {
					l.dispose();
					//suppression du node
					itr = new DListIterator(linkList, walker);
					itr.remove();
					
					result = true;
				}
				else {
					result = false;
				}
				//incrementation
				walker = walker.next;
			}
			
			return result;
		}
		
		
		public static function getLink( name:String ):Link {
			walker = linkList.head;
			
			while ( walker ) {
				//--
				if ( walker.data.name == name ) {
					var result = walker.data;
				}
				walker = walker.next;
			}
			return result;
		}
		
		
		public static function getLinkContent( name:String ):* {
			walker = linkList.head;
			
			while ( walker ) {
				//--
				if ( walker.data.name == name ) {
					var result = walker.data.object;
				}
				walker = walker.next;
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  SWFADRESS UTILITIES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function replace(str, find, replace) {
			return str.split(find).join(replace);
		}
		
		private static function toTitleCase(str) {
			return str.substr(0,1).toUpperCase() + str.substr(1);
		}
		
		private static function formatTitle(title) {
			return siteTitre + (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : '');
		}
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:SWFAddressEvent ) {
			
			//--vars
			var args:Object;
			var prop:String;
			
			try {
				if ( evt.value == '/' ) {
					walker = linkList.head;
					while ( walker ) {
						if ( walker.data.isActive() ) {
							walker.data.undoAction();
						}
						walker = walker.next;
					}
					
					state = "home";
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"changed state", state:state };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
				}
				else {
					walker = linkList.head;
					while ( walker ) {
						if ( walker.data.isActive() ) {
							walker.data.undoAction();
						}
						walker = walker.next;
					}
					getLink( evt.value ).doAction();
					
					state = evt.value;
					///////////////////////////////////////////////////////////////
					//arguments du messages
					args = { info:"changed state", state:state };
					//envoie de l'evenement pour les listeners de uploader
					eEvent = new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
				}
				
				SWFAddress.setTitle(formatTitle(evt.value));
				
			} catch (err) {
				state = "erreur 404";
				///////////////////////////////////////////////////////////////
				//arguments du messages
				args = { info:"error state", state:state };
				//envoie de l'evenement pour les listeners de uploader
				eEvent = new LinkManagerEvent( LinkManagerEvent.ONERRORSTATE, args );
				dispatchEvent( eEvent );
				///////////////////////////////////////////////////////////////
			}
		}
		
	}
	
}