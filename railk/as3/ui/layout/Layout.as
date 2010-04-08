/**
 * Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.utils.Dictionary;
	public class Layout
	{
		public var name:String;
		public var pack:String;
		public var viewsDict:Dictionary=new Dictionary(true);
		public var views:Array=[];
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Layout( pack:String, name:String, body:XML ) {
			this.pack = pack;
			this.name = name;
			construct(body);
		}
			
		private function construct(xml:XML, container:LayoutView=null, master:LayoutView=null):void {
			for (var i:int = 0; i < xml.children().length(); i++) {
				var d:XML = xml.children()[i];
				if (d.name() != 'div') continue;
				master = views[views.length] = viewsDict[d.@id.toString()] = new LayoutView(container, master, A('class', d), d.@id, A('float', d), A('align', d), A('margins', d), A('position', d), A('x', d), A('y', d), D(d), A('constraint', d), A('visible',d) );
				if ( d.children().length() > 0 ) construct( d, master );
			}
		}		
		
		/**
		 * MANAGE VIEWS
		 */
		public function getView(name:String):LayoutView { return (viewsDict[name])?viewsDict[name]:null; }
		public function removeView(name:String):void {
			for (var i:int = 0; i < views.length; i++) if (views[i].id == name) views.splice(i,1); 
			delete views[name]; 
		}
		
		/**
		 * UTILITIES
		 */
		private var attributes:Object =  { 'class':'', float:'none', align:'none', margins:null, posistion:'relative', x:0, y:0, constraint:'XY', visible:true };
		private var margins:Object =  { 0:'top', 1:'right', 2:'bottom', 3:'left' };
		private function A( name:String, xml:XML ):* {
			var i:int;
			for (i=0; i < xml.@*.length(); ++i){
				if (name == xml.@*[i].name()) {
					if (name == 'margins') {
						var a:Array = (xml.@*[i].toString()).split(','), result:Object={ top:0,right:0,bottom:0,left:0 };
						if(a.length==1){ var value:Number = Number(a[0]); result={top:value,right:value,bottom:value,left:value}; }
						else for (i=0; i < a.length; i++) result[margins[i]] = Number(a[i]);
						return result;
					}
					if(name == 'class') return pack+'.view'+(xml.@*[i].search(':')!=-1?'.':'::')+xml.@*[i];
					if(name == 'visible') return (xml.@*[i]=='true'?true:false);
					return xml.@*[i];
				}
			}	
			return attributes[name];
		}
		private function D(xml:XML):XML {
			var result:XML = new XML('<data></data>')
			for (var i:int; i < xml.children().length(); i++ ) if (xml.children()[i].name() != 'div') result.appendChild(xml.children()[i]);
			return (result.children().length() == 0)?null:result;
		}
	}
}