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
	import railk.as3.utils.Logger;
	
	public class LinkManager 
	{	
		public static var inited:Boolean;
		public static var state:String;
		
		private static var firstLink:Link
		private static var lastLink:Link
		private static var siteTitre:String;
		private static var swfAdress:Boolean;
		private static var hasUpdateTitle:Boolean;	
		private static var link:Link;
		
		/**
		 * INIT
		 */
		public static function init( titre:String, swfAdressEnable:Boolean=false, updateTitleEnable:Boolean=false ):void {
			if(swfAdressEnable){
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, manageEvent );
				siteTitre = titre;
				SWFAddress.setTitle( siteTitre );
				swfAdress = swfAdressEnable;
			}
			hasUpdateTitle = updateTitleEnable;
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
		public static function add( name:String, target:Object=null, action:Function = null, group:String='', colors:Object=null, swfAdressEnable:Boolean = false, type:String='mouse', data:*=null):Link {	
			var enable:Boolean;
			if ( swfAdress && swfAdressEnable ) enable = true;
			else if( swfAdress && !swfAdressEnable ) enable = false;
			else if( !swfAdress && swfAdressEnable ) enable = false;
			else if ( !swfAdress && !swfAdressEnable ) enable = false;
			
			var dummy:Boolean = (target)?false:true;
			if ( !getLink( name ) || dummy ) {
				link = new Link( name, target, type, action, group, colors, enable, dummy, data );
				if (!firstLink) firstLink = lastLink = link;
				else {
					lastLink.next = link;
					link.prev = lastLink;
					lastLink = link;
				}
			} else {
				link = getLink(name);
				link.target = target;
				link.type = type;
				link.action = action;
				link.group = group;
				link.colors = target;
				link.dummy = dummy;
				link.data = data;
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
			l.dispose();
			l = null;
		}
		
		public static function getLink( name:String, group:String='' ):Link { 
			var walker:Link = firstLink;
			while (walker ) {
				if (walker.name == name && walker.group == group ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public static function getLinkContent( name:String, group:String='' ):* { return getLink( name, group ).target; }
		
		/**
		 * SWFADRESS UTILITIES
		 */
		public static function forward():void { SWFAddress.forward(); } 
		public static function back():void { SWFAddress.back(); }
		public static function blanc(url:String):void { SWFAddress.href(url, '_blanc'); }
		public static function setValue(value:String):void { SWFAddress.setValue(value); }
		private static function replace(str:String, find:String, replace:String):String { return str.split(find).join(replace); }	
		private static function toTitleCase(str:String):String { return str.substr(0,1).toUpperCase() + str.substr(1); }
		private static function formatTitle(title:String):String { return siteTitre+' '+ (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : ''); }
		private static function updateTitle(title:String):void {
			if (title.charAt(title.length - 1) != '/') title += '/';
			SWFAddress.setTitle(formatTitle(title));
		}
		
		/**
		 * MANAGE EVENT
		 */
		private static function manageEvent( evt:SWFAddressEvent ):void {
			try {
				state = (evt.value == '/')?"/home":evt.value;
				if ( getLink(evt.value) ) getLink(evt.value).deepLinkAction();
				else {
					if ( getLink(evt.value + '/') ) getLink(evt.value + '/').deepLinkAction();
					else {
						var a:Array = evt.value.split('/'), i:int = a.length, anchor:String = '', link:String = (evt.value.charAt(evt.value.length - 1) != '/')?evt.value + '/':'/' + evt.value;
						while( --i > -1 ) {
							link = link.replace(a[i] + '/', '');
							if(a[i]!="index") anchor = a[i] + '/' + anchor;
							if (getLink(link)) {
								getLink(link).deepLinkAction((anchor!=""?anchor:null));
								state = link;
								return;
							}
						}
						setValue('404');
						state = "/unknown";
					}
				}			
				if (hasUpdateTitle) updateTitle(state);
				
			} catch (err:Error) {
				setValue('404');
				state = "/unknown";
				if(hasUpdateTitle) updateTitle(state);
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