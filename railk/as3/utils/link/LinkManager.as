/**
* 
* Static class LinkManager
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.utils.link {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.link.LinkManagerEvent;
	import railk.as3.utils.link.linkItem.Link;
	import railk.as3.utils.objectList.*;
	import railk.as3.utils.tree.TreeNode;
	
	// ____________________________________________________________________________________ IMPORT SWFADRESS
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	
	public class LinkManager {
		
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                             :EventDispatcher;
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var linkList                           :ObjectList;
		private static var walker                             :ObjectNode;
		private static var treeRoot                           :TreeNode
		
		//_____________________________________________________________________________ VARIABLES LINKMANAGER
		private static var siteTitre                          :String;
		private static var swfAdress                          :Boolean = false;
		private static var tree                               :Boolean = false;
		private static var updateTitle                        :Boolean = false;
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
		public static function init( titre:String, swfAdressEnable:Boolean=false, treeEnable:Boolean=false, updateTitleEnabled:Boolean=false ):void {
			if(swfAdressEnable){
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, manageEvent );
				siteTitre = titre;
				SWFAddress.setTitle( siteTitre );
				swfAdress = swfAdressEnable;
			}
			if (treeEnable) {
				initTree();
				tree = treeEnable;
			}
			updateTitle = updateTitleEnabled;
			linkList = new ObjectList();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			 ADD LINK
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name                   nom du lien de type /.../.../...
		 * @param	displayObject		   displayObject clickable
		 * @param	displayObjectContent   Object de { nom:{ objet:dislplayObject , colors:{click:uint,out:uint,hover:uint}=null, action:Function(type:String("hover"|"out"),o:*)=null } }
		 * @param   type                   'mouse' | 'roll'
		 * @param	onClick                Function(type:String("hover"|"out"),o:*)=null
		 * @param	swfAdressEnable        est-ce que le liens utilise swfadress
		 */
		public static function add( name:String, displayObject:Object, displayObjectContent:Object=null, type:String = 'mouse', onClick:Function = null, swfAdressEnable:Boolean = false, parent:String='root' ):void 
		{
			var enable:Boolean;
			if ( swfAdress && swfAdressEnable ) { enable = true; }
			else if( swfAdress && !swfAdressEnable ) { enable = false; }
			else if( !swfAdress && swfAdressEnable ) { enable = false; }
			else if ( !swfAdress && !swfAdressEnable ) { enable = false; }
			if (tree) addToTree( name, parent, displayObject );
			link = new Link( name, displayObject, displayObjectContent, type, onClick, enable, parent );
			linkList.add( [name,link] );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			LINK TREE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function initTree(obj:*=null):void {
			treeRoot = new TreeNode('root');
		}
		
		public static function addToTree(name:String, parent:String, obj:*=null):void {
			(new TreeNode(name, obj, treeRoot.getTreeNodeByName( parent ) ) );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE LINKS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):Boolean { return linkList.remove( name ); }
		
		public static function getLink( name:String ):Link { return linkList.getObjectByName( name ).data; }
		
		public static function getLinkContent( name:String ):* { return getLink( name ).object; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  SWFADRESS UTILITIES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function replace(str, find, replace) { return str.split(find).join(replace); }
		
		private static function toTitleCase(str) { return str.substr(0,1).toUpperCase() + str.substr(1); }
		
		private static function formatTitle(title) { return siteTitre + (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : ''); }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		PARSE ADDRESS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function parseAddress( value:String ):Array {
			var result:Array = new Array();
			var tmp:Array = value.split('/');
			for (var i:int = 0; i < tmp.length; i++) 
			{
				if ( tmp[i] != '' ) result.push( tmp[i]+'/' );
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		    TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function toString():String {
			return treeRoot.treeToString();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:SWFAddressEvent ):void 
		{
			var args:Object;
			var prop:String;
			try {
				if ( evt.value == '/' ) {
					walker = linkList.head;
					while ( walker ) {
						if ( walker.data.isActive() && walker.data.isSwfAddress() ) { walker.data.undoAction(); }
						walker = walker.next;
					}
					
					state = "home";
					///////////////////////////////////////////////////////////////
					args = { info:"changed state", state:state };
					eEvent = new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
				}
				else {
					//undo manage with the tree for better handling, but debugging not easy -> TODO LATER
					walker = linkList.head;//treeRoot.getTreeNodeByName(evt.value).childs.head;
					while ( walker ) {
						if ( walker.data.isActive() && walker.data.isSwfAddress() ) { walker.data.undoAction(); }
						walker = walker.next;
					}
					
					//do
					var parsed:Array = parseAddress( evt.value );
					var nextLink:String = '/';
					for (var i:int = 0; i < parsed.length ; i++) 
					{
						if (!getLink( nextLink + parsed[i] ).isActive()) {
							getLink( nextLink + parsed[i] ).doAction();
						}
						nextLink = nextLink + parsed[i];
					}
					
					state = evt.value;
					///////////////////////////////////////////////////////////////
					args = { info:"changed state", state:state };
					eEvent = new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
				}
				if(updateTitle) SWFAddress.setTitle(formatTitle(evt.value));
				
			} catch (err) {
				state = "erreur 404";
				///////////////////////////////////////////////////////////////
				args = { info:"error state", state:state };
				eEvent = new LinkManagerEvent( LinkManagerEvent.ONERRORSTATE, args );
				dispatchEvent( eEvent );
				///////////////////////////////////////////////////////////////
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function get titre():String { return siteTitre; }
		
		public static function set titre( value:String ):void { 
			siteTitre = value;
			SWFAddress.setTitle( siteTitre );
		}
		
	}
}