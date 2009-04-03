/**
 * Layout Manager Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.ui.depth.DepthManager;	
	public class Layout
	{
		public var name:String;
		public var parent:*;
		public var next:Layout;
		public var prev:Layout;
		
		private var blocs:Array;
		private var blocCount:int=0;
		private var blocsDepth:DepthManager;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Layout( name:String, parent:Object,structure:LayoutStruct ) {
			this.name = name;
			this.parent = parent;
			this.blocsDepth = new DepthManager(parent);
			this.addBloc( structure.blocs );
		}
		
		public function getBloc(name:String):LayoutBloc {
			var i:int = blocs.length;
			while( --i > -1 ) if(blocs[i].name=name) return blocs[i];
			return null;
		}
		
		public function addBloc(blocs:Array):Boolean {
			for (var i:int=0;i<blocs.length;++i) blocs[blocCount++] =  new LayoutBloc(parent,baseBlocs.name,baseBlocs.x,baseBlocs.y,baseBlocs.width,baseBlocs.height);
		}
		
		public function removeBloc(name:String):Boolean {
			var b:LayoutBloc = getBloc(name), i:int=blocs.length;
			if (!b) return false;
			
			while( --i > -1 ) {
				var t:LayoutBloc = blocs[i];
				if (t && t.getArc(bloc))
					removeArc(t.name, b.name);
			}
			
			b = null;
			blocCount--;
			return true;
		}
		
		public function dispose():void {
			next = prev = null;
			blocsDepth.dispose();
			blocs=[];
		}
		
		/**
		 * GRAPH BREADTH FIRST
		 * 
		 * 
		 * @param node  The graph node at which the traversal starts.
		 * @param visit A callback function which is invoked every time a node
		 *              is visited. The visited node is accessible through
		 *              the function's first argument. You can terminate the
		 *              traversal by returning false in the callback function.
		 */
		public function breadthFirst(bloc:LayoutBloc, visit:Function):void {
			var que:Array = new Array(0x10000), divisor:int = 0x10000 - 1, front:int = 0;
			que[0] = bloc; 
			bloc.marked = true;
			var c:int = 1, k:int, i:int, arcs:Array, v:LayoutBloc, w:LayoutBloc;
			
			while (c > 0){
				v = que[front];
				if (!visit(v)) return;
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
		
		public function getArc(from:String, to:String):LayoutArc {
			var f:LayoutBloc = getBloc(from);
			var t:LayoutBloc = getBloc(to);
			if (f && t) return f.getArc(t);
			return null;
		}
		
		public function addArc(from:String,to:String,weight:int=1):Boolean {
			var f:LayoutBloc = getBloc(from);
			var t:LayoutBloc = getBloc(to);
			if (f && t){
				if (f.getArc(t)) return false;
				f.addArc(t,weight);
				return true;
			}
			return false;
		}
		
		public function removeArc(from:String, to:String):Boolean {
			var f:LayoutBloc = getBloc(from);
			var t:LayoutBloc = getBloc(to);
			if (f && t){
				f.removeArc(t);
				return true;
			}
			return false;
		}
		
		public function clearMarks():void {
			var i:int = blocCount;
			while( --i > -1 ) {
				var b:LayoutBloc = blocs[i];
				if (b) b.marked = false;
			}
		}
	}
}