/**
* 
* Static class LinkManager
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.ui.link {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.data.objectList.*;
	
	// ____________________________________________________________________________________ IMPORT SWFADRESS
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	
	public class LinkManager {
		
		// ______________________________________________________________________________ VARIABLES PROTEGEES
		protected static var disp                             :EventDispatcher;
		
		//_______________________________________________________________________________ VARIABLES STATIQUES
		private static var linkList                           :ObjectList;
		private static var walker                             :ObjectNode;
		
		//_____________________________________________________________________________ VARIABLES LINKMANAGER
		private static var _inited                            :Boolean = false;
		private static var siteTitre                          :String;
		private static var swfAdress                          :Boolean = false;
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
		public static function init( titre:String, swfAdressEnable:Boolean=false, updateTitleEnabled:Boolean=false ):void {
			if(swfAdressEnable){
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, manageEvent );
				siteTitre = titre;
				SWFAddress.setTitle( siteTitre );
				swfAdress = swfAdressEnable;
			}
			updateTitle = updateTitleEnabled;
			linkList = new ObjectList();
			_inited = true;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			 ADD LINK
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name                   nom du lien de type /.../.../...
		 * @param	displayObject		   displayObject clickable
		 * @param   type                   'mouse' | 'roll'
		 * @param	actions                Function(type:String("hover"|"out"|"do"|"undo"),requester:*,data:*)=null
		 * @param	colors                 Object {hover:,out:,click:}
		 * @param	swfAdressEnable        est-ce que le liens utilise swfadress
		 */
		public static function add( name:String, displayObject:Object=null, type:String='mouse', actions:Function = null, colors:Object=null, swfAdressEnable:Boolean = false, data:*=null):Link 
		{	
			var enable:Boolean;
			if ( swfAdress && swfAdressEnable ) enable = true;
			else if( swfAdress && !swfAdressEnable ) enable = false;
			else if( !swfAdress && swfAdressEnable ) enable = false;
			else if ( !swfAdress && !swfAdressEnable ) enable = false;
			
			var dummy:Boolean = (displayObject)? false : true;
			link = Link.getInstance().create( name, displayObject, type, actions, colors, enable, dummy, data );
			if ( !linkList.getObjectByName( name ) || dummy || linkList.getObjectByName( name ).data.isDummy() ) linkList.add( [name, link] );
			else linkList.update( name, link );
			
			return link;
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
		// 																				  		 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:SWFAddressEvent ):void 
		{
			var args:Object;
			var prop:String;
			try {
				if ( evt.value == '/' ) 
				{
					if ( getLink(evt.value) ) getLink(evt.value).doAction();
										
					state = "home";
					///////////////////////////////////////////////////////////////
					args = { info:"changed state", state:state };
					eEvent = new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////
				}
				else 
				{
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
		static public function get titre():String { return siteTitre; }
		
		static public function set titre( value:String ):void { 
			siteTitre = value;
			SWFAddress.setTitle( siteTitre );
		}
		
		static public function get inited():Boolean { return _inited; }
		
	}
}