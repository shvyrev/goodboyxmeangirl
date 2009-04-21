/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.geom.Rectangle;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.ui.layout.utils.*;
	
	public class LayoutBloc
	{	
		public var arcs:Array=[];
		public var numArcs:int=0;
		
		public var view:IView;
		public var component:*
		public var layout:Layout;
		public var viewClass:String;
		public var parent:LayoutBloc;
		public var name:String;
		public var x:int;
		public var y:int;
		public var height:int;
		public var width:int;
		public var dynamicHeight:Boolean;
		public var dynamicWidth:Boolean;
		public var align:String;
		public var moved:Point = new Point();
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutBloc( layout:Layout, viewClass:String, name:String, x:Number, y:Number, width:String, height:String, align:String, parent:LayoutBloc=null ) {
			this.layout = layout;
			this.viewClass = viewClass;
			this.name = name;
			this.x = x;
			this.y = y; 
			this.width = Number(width.match(/[0-9]{0,}/)[0]);
			this.height = Number(height.match(/[0-9]{0,}/)[0]);
			this.dynamicHeight = (height.search(/\%/)!=-1)?true:false;
			this.dynamicWidth = (width.search(/\%/)!=-1)?true:false;
			this.align = align;
			this.parent = parent;
		}
		
		public function setupView(model:IModel, controller:IController):Object {
			if(!view) view = (name!='dummy')?new (getDefinitionByName(viewClass) as Class)(model, controller):new Dummy(model,controller);
			component = view.component;
			component.x = x;
			component.y = y;
			//_view.component.scrollRect = new Rectangle(0,0,((!dynamicWidth)?width:_view.component.width),((!dynamicHeight)?height:_view.component.height));
			return component;
		}
		
		/**
		 * ACTION
		 */
		public function bind():void { 
			x=component.x; width=component.width; 
			y=component.y; height=component.height;
			component.addEventListener(Event.ENTER_FRAME, check); 
		}
		public function unbind():void { component.removeEventListener(Event.ENTER_FRAME, check); }
		
		private function check(evt:Event):void {
			layout.changeFrom(this);
			x=component.x; width=component.width; 
			y=component.y; height=component.height;
		}

		public function update(from:LayoutBloc):void {
			unbind();
			if(component.y >= from.y && component.y < from.y+from.height )component.x += int(from.component.width)-from.width+int(from.component.x)-from.x;
			if(component.x >= from.x && component.x < from.x+from.width ) component.y += int(from.component.height)-from.height+int(from.component.y)-from.y;
			bind();
		}
		
		public function dispose():void {
			viewClass=null;
			arcs = null;
		}
		
		/**
		 * GRAPH PART
		 */
		public function addArc(target:LayoutBloc, weight:int):void {
			arcs[numArcs++] = new LayoutArc(target, weight);
		}
		
		public function removeArc(target:LayoutBloc):Boolean {
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
		
		public function getArc(target:LayoutBloc):LayoutArc {
			var i:int = numArcs;
			while( --i > -1 ) {
				var arc:LayoutArc = arcs[i];
				if (arc.bloc == target) return arc;
			}
			return null;
		}
	}
}