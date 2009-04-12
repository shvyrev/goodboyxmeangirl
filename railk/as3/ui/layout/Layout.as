/**
 * Layout Manager Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.events.Event;
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
			while( --i > -1 ) if(blocs[i].name==name) return blocs[i];
			return null;
		}
		
		public function addBloc(struct:Array):void {
			for (var i:int = 0; i < struct.length;++i) {
				var b:XML = struct[i], arcs:Array;
				arcs = b.@linkId.split(',');
				blocs[blocCount++] =  new LayoutBloc(b.@view,b.@id,b.@x,b.@y,b.@width,b.@height,b.@align);
			}
		}
		
		public function linkBloc(struct:Array):void {
			for (var i:int = 0; i < struct.length;++i) {
				var b:XML = struct[i], arcs:Array;
				arcs = b.@linkId.split(',');
				for ( var j:int=0; j<arcs.length; ++j) addArc(b.@id, arcs[j]);
			}
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
		
		/**
		 * EVENT
		 */
		public function manageEvent(evt:Event):void {
			var target:LayoutBloc = evt.currentTarget as LayoutBloc;
			changeFrom(target);
		}
		
		/**
		 * GRAPH BREADTH FIRST 
		 */
		public function changeFrom(bloc:LayoutBloc):void {
			var que:Array = new Array(0x10000), divisor:int = 0x10000 - 1, front:int = 0;
			que[0] = bloc; 
			bloc.marked = true;
			var c:int = 1, k:int, i:int, arcs:Array, v:LayoutBloc, w:LayoutBloc;
			
			while (c > 0){
				v = que[front];
				if (!v.update()) return;
				arcs = v.arcs, k = v.numArcs;
				for (i = 0; i < k; i++){
					w = arcs[i].bloc;
					if (w.marked) continue;
					w.marked = true;
					que[int((c++ + front) & divisor)] = w;
				}
				if (++front == 0x10000) front = 0;
				c--;
			}
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
		
		private function clearMarks():void {
			var i:int = blocCount;
			while( --i > -1 ) {
				var b:LayoutBloc = blocs[i];
				if (b) b.marked = false;
			}
		}
	}
}