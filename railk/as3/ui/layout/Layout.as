/**
 * Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	public class Layout
	{
		public var name:String;
		public var parent:*;
		public var next:Layout;
		public var prev:Layout;
		public var blocs:Array=[];
		private var blocCount:int=0;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Layout( name:String, structure:Array ) {
			this.name = name;
			this.addBloc( structure );
			this.linkBloc( structure );
		}
		
		public function getBloc(name:String):LayoutBloc {
			var i:int = blocs.length;
			while ( --i > -1 ) {
				var result:LayoutBloc = getSubBloc(blocs[i],name);
				if (result) return result;
			}
			return null;
		}
		
		private function getSubBloc(blocs:Array, name:String ):LayoutBloc {
			if (blocs[0].name == name) return blocs[0];
			else {
				if (blocs[1]) {
					for (var i:int = 0; i < blocs[1].length; i++) {
						var result:LayoutBloc = getSubBloc(blocs[1][i], name);
						if (result) return result;
					}
				}
			}
			return null;
		}
		
		public function addBloc(struct:Array):void { for (var i:int = 0; i < struct.length;++i) blocs[blocCount++] = addSubBloc(struct[i]); }
		
		private function addSubBloc(struct:*,parent:LayoutBloc=null):Array {
			var result:Array=[], b:XML=(struct is Array)?struct[0]:struct;
			if(struct is Array){
				result[0] =  new LayoutBloc(this,'railk.as3.ui.layout.utils::Dummy',b.@id,b.@x,b.@y,b.@width,b.@height,b.@align,parent);
				result[1] = [];
				for (var i:int = 0; i < struct[1].length; ++i) result[1][i] = addSubBloc(struct[1][i],result[0]); 
			} 
			else result[0] =  new LayoutBloc(this,b.@view,b.@id,b.@x,b.@y,b.@width,b.@height,b.@align,parent);
			return result;
		}
		
		public function linkBloc(struct:Array):void { for (var i:int = 0; i < struct.length;++i) linkSubBloc(struct[i]); }
		
		private function linkSubBloc(struct:*):void {
			var arcs:Array, b:XML = (struct is Array)?struct[0]:struct;
			if (b.@linkId.toString()){
				arcs = b.@linkId.split(',');
				for ( var j:int = 0; j < arcs.length; ++j) addArc(b.@id, arcs[j]);
			}	
			if ( struct is Array ) for (var i:int=0; i < struct[1].length; ++i) linkSubBloc(struct[1][i]);
		}
		
		public function removeBloc(name:String):Boolean {
			var b:LayoutBloc = getBloc(name), i:int=blocs.length;
			if (!b) return false;
			
			while( --i > -1 ) {
				var t:LayoutBloc = blocs[i];
				if (t && t.getArc(b)) removeArc(t.name, b.name);
			}
			
			b = null;
			blocCount--;
			return true;
		}

		public function dispose():void {
			next = prev = null;
			blocs=[];
		}
		
		private function getArc(from:String, to:String):LayoutArc {
			var f:LayoutBloc = getBloc(from);
			var t:LayoutBloc = getBloc(to);
			if (f && t) return f.getArc(t);
			return null;
		}
		
		private function addArc(from:String,to:String,weight:int=1):Boolean {
			var f:LayoutBloc = getBloc(from);
			var t:LayoutBloc = getBloc(to);
			if (f && t){
				if (f.getArc(t)) return false;
				f.addArc(t,weight);
				return true;
			}
			return false;
		}
		
		private function removeArc(from:String, to:String):Boolean {
			var f:LayoutBloc = getBloc(from);
			var t:LayoutBloc = getBloc(to);
			if (f && t){
				f.removeArc(t);
				return true;
			}
			return false;
		}
	}
}