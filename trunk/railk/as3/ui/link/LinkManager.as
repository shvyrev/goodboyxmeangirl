/**
* 
* class LinkManager
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui.link 
{	
	import flash.utils.Dictionary;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import railk.as3.pattern.singleton.Singleton;
	
	public class LinkManager implements ILinkManager
	{	
		public var inited:Boolean;
		public var state:String;
		
		private var links:ILink
		private var siteTitre:String;
		private var swfAdress:Boolean;
		private var hasUpdateTitle:Boolean;	
		private var link:ILink;
		private var groups:Dictionary = new Dictionary(true);
		private var current:String;
		
		public static function getInstance():LinkManager {
			return Singleton.getInstance(LinkManager);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function LinkManager() { Singleton.assertSingle(LinkManager); }
		
		/**
		 * INIT
		 */
		public function init( titre:String, swfAdressEnable:Boolean=false, updateTitleEnable:Boolean=false ):ILinkManager {
			if(swfAdressEnable){
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, manageEvent );
				siteTitre = titre;
				SWFAddress.setTitle( siteTitre );
				swfAdress = swfAdressEnable;
			}
			hasUpdateTitle = updateTitleEnable;
			inited = true;
			return this;
		}
		
		/**
		 * ADD GROUP
		 * @param	name
		 */
		public function addGroup(name:String, navigation:Boolean = false):ILinkManager {
			if (groups[name] != undefined) throw new Error("ce groupe existe dèjà");
			groups[name] = navigation;
			return this;
		}
		
		/**
		 * DELETE GROUP
		 * @param	name
		 */
		public function delGroup(name:String):void { if (groups[name] != undefined) delete groups[name]; }
		
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
		public function add( name:String, target:Object=null, action:Function = null, title:String='', group:String='', colors:Object=null, swfAdressEnable:Boolean = false, type:String='mouse', data:*=null):ILink {	
			if(group!="" && groups[group]== undefined) throw new Error ("le groupe "+group+" n'éxiste pas, veuillez le créer");
			var enable:Boolean;
			if ( swfAdress && swfAdressEnable ) enable = true;
			else if( swfAdress && !swfAdressEnable ) enable = false;
			else if( !swfAdress && swfAdressEnable ) enable = false;
			else if ( !swfAdress && !swfAdressEnable ) enable = false;
			
			if (!getLink(name)) {
				link = new Link(name, title, group, (group?groups[group]:false), enable).addTarget((target?target.name:name), target, type, action, colors, false, data);
				if (!links) links = link;
				else {
					link.prev = links;
					links = link;
				}
			} 
			else throw new Error ("liens déjà existant");
			return link;
		}
			
		/**
		 * MANAGE LINKS
		 */
		public function remove( name:String ):void {
			var walker:ILink = links, previous:ILink;
			while (walker ) {
				if (walker.name == name) {
					if (previous) previous.prev = walker.prev;
					else links = walker.prev;
					walker.dispose();
				}
				previous = walker;
				walker = walker.prev;
			}
		}
		
		public function getLink( name:String, group:String='' ):ILink { 
			var walker:ILink = links;
			while (walker ) {
				if(group!=""){ if (walker.name == name && walker.group == group ) return walker; }
				else{ if (walker.name == name ) return walker; }
				walker = walker.prev;
			}
			return null;
		}
		
		public function getLinks(group:String=''):Array { 
			var walker:ILink = links, result:Array=[];
			while (walker ) {
				if(group==""){ result[result.length] = walker; }
				else { if (walker.group == group ) result[result.length] = walker; }
				walker = walker.prev;
			}
			result.reverse();
			return result;
		}
		
		public function navigationChange(name:String):void {
			var group:String = getLink(name).group;
			if (groups[group]==undefined) return;
			var a:Array = getLinks(group), i:int= a.length;
			while ( --i > -1) {
				if (a[i].active && a[i].name != name) {
					a[i].action();
					break;
				}
			}
		}
		
		/**
		 * SWFADRESS UTILITIES
		 */
		public function forward():void { SWFAddress.forward(); } 
		public function back():void { SWFAddress.back(); }
		public function blanc(url:String):void { SWFAddress.href(url, '_blanc'); }
		public function setValue(value:String):void { SWFAddress.setValue(value); }
		private function replace(str:String, find:String, replace:String):String { return str.split(find).join(replace); }	
		private function toTitleCase(str:String):String { return str.substr(0,1).toUpperCase() + str.substr(1); }
		private function formatTitle(title:String):String { return siteTitre+' '+ (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : ''); }
		private function updateTitle(title:String):void {
			if (title.charAt(title.length - 1) != '/') title += '/';
			SWFAddress.setTitle(formatTitle(title));
		}
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( e:SWFAddressEvent ):void {
			var l:ILink;
			if ( getLink(e.value) ) {
				l = getLink(e.value);
				if (current == l.name) return;
				l.action(); 
				navigationChange(e.value);
			} else {
				if ( getLink(e.value + '/') ) {
					l = getLink(e.value + '/'); 
					if (current == l.name) return;
					l.action(); 
					navigationChange(e.value + '/');
				} else {
					var a:Array = e.value.split('/'), i:int = a.length, anchor:String = '', link:String = (e.value.charAt(e.value.length - 1) != '/')?e.value + '/':'/' + e.value;
					while( --i > -1 ) {
						link = link.replace(a[i] + '/', '');
						if(a[i]) anchor = a[i] + '/' + anchor;
						if (getLink(link)) {
							l = getLink(link);
							if (current == l.name) return;
							l.action(anchor);
							navigationChange(link);
							return;
						}
					}
					setValue('/');
					return;
				}
			}
			state = '/' + l.title;
			if (hasUpdateTitle) updateTitle(state);
			current = l.name;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get titre():String { return siteTitre; }
		public function set titre( value:String ):void { 
			siteTitre = value;
			SWFAddress.setTitle( siteTitre );
		}		
	}
}