/**
* 
* Static class LinkManager
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui.link 
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	
	public class LinkManager 
	{	
		protected static var disp:EventDispatcher;
		public static var inited:Boolean;
		
		private static var firstLink:Link
		private static var lastLink:Link
		private static var siteTitre:String;
		private static var swfAdress:Boolean;
		private static var updateTitle:Boolean;
		private static var state:String;		
		private static var link:Link;
		
		
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
			inited = true;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			 ADD LINK
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name                   nom du lien de type /.../.../...
		 * @param	target				   displayObject clickable
		 * @param   type                   'mouse' | 'roll'
		 * @param	actions                Function(type:String("hover"|"out"|"do"|"undo"),requester:*,data:*)=null
		 * @param	colors                 Object {hover:,out:,click:}
		 * @param	swfAdressEnable        est-ce que le liens utilise swfadress
		 */
		public static function add( name:String, target:Object=null, type:String='mouse', action:Function = null, colors:Object=null, swfAdressEnable:Boolean = false, data:*=null):Link {	
			var enable:Boolean;
			if ( swfAdress && swfAdressEnable ) enable = true;
			else if( swfAdress && !swfAdressEnable ) enable = false;
			else if( !swfAdress && swfAdressEnable ) enable = false;
			else if ( !swfAdress && !swfAdressEnable ) enable = false;
			
			var dummy:Boolean = (target)?false:true;
			link = new Link( name, target, type, action, colors, enable, dummy, data );
			if ( !getLink( name ) || dummy || getLink( name ).data.isDummy() ) {
				if (!firstLink) firstLink = lastLink = link;
				else {
					lastLink.next = link;
					link.prev = lastLink;
					lastLink = link;
				}
			} else {
				var l:Link = getLink(name);
				l.target = target;
				l.type = type;
				l.action = action;
				l.colors = colors;
				l.dummy = dummy;
				l.swfAddress = enable;
				l.data = data;
			}
			return link;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE LINKS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):void {
			var l:Link = getLink(name);
			if (l.next) l.next.prev = l.prev;
			if (l.prev) l.prev.next = l.next;
			else if (firstLink == l) firstLink = l.next;
			l = null;
		}
		
		public static function getLink( name:String ):Link { 
			var walker:Link = firstLink;
			while (walker ) {
				if (walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public static function getLinkContent( name:String ):* { return getLink( name ).target; }
		
		
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
			for (var i:int = 0; i < tmp.length; i++){
				if ( tmp[i] != '' ) result.push( tmp[i]+'/' );
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function manageEvent( evt:SWFAddressEvent ):void {
			var args:Object, prop:String;
			try {
				if ( evt.value == '/' ) {
					if ( getLink(evt.value) ) getLink(evt.value).doAction();
					state = "home";
					dispatchEvent( new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE,{ info:"changed state", state:state } ) );
				} else {
					var parsed:Array = parseAddress( evt.value );
					var nextLink:String = '/';
					for (var i:int = 0; i < parsed.length ; i++) {
						if (!getLink( nextLink + parsed[i] ).active) getLink( nextLink + parsed[i] ).doAction();
						nextLink = nextLink + parsed[i];
					}
					state = evt.value;
					dispatchEvent( new LinkManagerEvent( LinkManagerEvent.ONCHANGESTATE, { info:"changed state", state:state } ) );
				}
				if(updateTitle) SWFAddress.setTitle(formatTitle(evt.value));
				
			} catch (err) {
				state = "erreur 404";
				dispatchEvent( new LinkManagerEvent( LinkManagerEvent.ONERRORSTATE,{ info:"error state", state:state } ) );
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
	}
}