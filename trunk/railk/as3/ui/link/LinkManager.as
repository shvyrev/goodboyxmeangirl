/**
* 
* Static class LinkManager
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui.link 
{	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	public class LinkManager 
	{	
		public static var inited:Boolean;
		
		private static var firstLink:Link
		private static var lastLink:Link
		private static var siteTitre:String;
		private static var swfAdress:Boolean;
		private static var updateTitle:Boolean;
		private static var state:String;		
		private static var link:Link;
		
		/**
		 * INIT
		 */
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
		
		/**
		 * ADD LINK
		 * 
		 * @param	name                   nom du lien de type /.../.../...
		 * @param	target				   displayObject clickable
		 * @param	action                Function(type:String("hover"|"out"|"do"|"undo"),requester:*,data:*)=null
		 * @param	colors                 Object {hover:,out:,click:}
		 * @param	swfAdressEnable        est-ce que le liens utilise swfadress
		 * @param   type                   'mouse' | 'roll'
		 */
		public static function add( name:String, target:Object=null, action:Function = null, colors:Object=null, swfAdressEnable:Boolean = false, type:String='mouse', data:*=null):Link {	
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
			
		/**
		 * MANAGE LINKS
		 */
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
		
		/**
		 * SWFADRESS UTILITIES
		 */
		public static function setValue(value:String):void { SWFAddress.setValue(value); }
		private static function replace(str:String, find:String, replace:String):String { return str.split(find).join(replace); }	
		private static function toTitleCase(str:String):String { return str.substr(0,1).toUpperCase() + str.substr(1); }
		private static function formatTitle(title:String):String { return siteTitre + (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : ''); }
		
		/**
		 * MANAGE EVENT
		 */
		private static function manageEvent( evt:SWFAddressEvent ):void {
			try {
				state= (evt.value == '/')?"home":evt.value;
				if ( getLink(evt.value) ) getLink(evt.value).deepLinkAction();
				else {
					if ( getLink(evt.value + '/') ) getLink(evt.value + '/').deepLinkAction();
					else {
						var a:Array = evt.value.split('/');
						var link:String = '';
						for (var i:int = 0; i < a.length-1; ++i) link+=a[i]+'/';
						if ( getLink(link) ) getLink(link).deepLinkAction(a[a.length-1]);
						else setValue('/');
					}
				}				
				if(updateTitle) SWFAddress.setTitle(formatTitle(evt.value));
				
			} catch (err:Error) {
				state = "erreur 404";
			}
		}
		
		/**
		 * GETTER/SETTER
		 */
		static public function get titre():String { return siteTitre; }
		static public function set titre( value:String ):void { 
			siteTitre = value;
			SWFAddress.setTitle( siteTitre );
		}		
	}
}