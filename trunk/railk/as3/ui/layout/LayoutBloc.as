/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.events.Event;
	import railk.as3.display.VSprite;
	
	public class LayoutBloc
	{	
		public var arcs:Array=[];
		public var marked:Boolean;
		public var numArcs:int=0;
		
		private var bloc:VSprite;
		private var subBlocs:Array=[];
		
		public var name:String;
		public var height:Number;
		public var width:Number;
		public var hasSubBlocs:Boolean;
		public var dynamicHeight:Boolean = true;
		public var dynamicWidth:Boolean = true;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutBloc(parent:Object, name:String, x:Number, y:Number, width:Number, height:Number ) {
			bloc = new VSprite(parent);
			bloc.name = name;
		}
		
		/**
		 * CONTENT
		 */
		public function addSubBlocs( blocs:Array ):void {
			for (var i:int = 0; i < blocs; i++) {
				subBlocs.add[blocs.name]
			}
		}
		
		public function addContent( content:Object ):Boolean {
			var result:Boolean;
			if ( hasSubBlocs) result = false;
			else {
				bloc.addChild( content );
				result = true;
			}
			return result;
		}
		
		public function setRegistration(x:Number, y:Number):void {
			bloc.changeRegistration(x, y);
		}
		
		public function move():void{
			
		}
		
		public function dispose():void {
			bloc = null;
		}
		
		/**
		 * GRAPH PART
		 */
		public function addArc(target:LayoutBloc, weight:int):void {
			arcs[numArcs++] = new LayoutArc(target, weight);
		}
		
		public function removeArc(target:GraphNode):Boolean {
			var i:int = numArcs;
			while( --i > -1 ) {
				if (arcs[i].bloc == target) {
					arcs.splice(i, 1);
					numArcs--;
					return true;
				}
			}
			return false;
		}
		
		public function getArc(target:GraphNode):LayoutArc {
			var i:int = numArcs;
			while( --i > -1 ) {
				var arc:LayoutArc = arcs[i];
				if (arc.bloc == target) return arc;
			}
			return null;
		}
	}
}