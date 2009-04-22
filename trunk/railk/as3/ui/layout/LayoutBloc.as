/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.geom.Rectangle;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.ui.layout.utils.*;
	
	public class LayoutBloc
	{	
		public var arcs:Array=[];
		public var numArcs:int = 0;
		public var stage:Stage;
		
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
		public var fixedHeight:Boolean;
		public var fixedWidth:Boolean;
		public var align:String;
		
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
			this.fixedHeight = (height.search(/f/)!=-1)?true:false;
			this.fixedWidth = (width.search(/f/)!=-1)?true:false;
			this.align = align;
			this.parent = parent;
		}
		
		public function setupView(model:IModel, controller:IController):Object {
			if(!view) view = (name!='dummy')?new (getDefinitionByName(viewClass) as Class)(model, controller):new Dummy(model,controller);
			component = view.component;
			component.x = x;
			component.y = y;
			if (fixedHeight || fixedWidth) component.scrollRect = new Rectangle(0, 0, width, height);
			component.addEventListener(Event.ADDED_TO_STAGE, function() {
				stage = component.stage;
			});
			return component;
		}
		
		/**
		 * ACTION
		 */
		public function bind():void { 
			x=component.x; width=component.width; 
			y=component.y; height=component.height;
			component.addEventListener(Event.ENTER_FRAME, check); 
			if (align) stage.addEventListener(Event.RESIZE, resize );
		}
		public function unbind():void { component.removeEventListener(Event.ENTER_FRAME, check); }
		
		private function check(evt:Event):void {
			layout.changeFrom(this);
			x=component.x; width=component.width; 
			y=component.y; height=component.height;
		}

		public function update(from:LayoutBloc):void {
			unbind();
			if(component.y >= from.y && component.y < from.y+from.height ) component.x += int(from.component.width)-from.width;
			if(component.x >= from.x && component.x < from.x+from.width ) component.y += int(from.component.height)-from.height;
			bind();
		}
		
		public function dispose():void {
			viewClass=null;
			arcs = null;
		}
		
		/**
		 * RESIZE
		 */
		private function resize(evt:Event):void {
			switch(align) {
				case 'TL' : component.x = component.y = 0; break;
				case 'TR' : 
					component.x = stage.stageWidth - component.width;
					component.y = 0;
					break;
				case 'BR' :
					component.x = stage.stageWidth - component.width;
					component.y = stage.stageHeight - component.height;
					break;
				case 'BL' : 
					component.x = 0;
					component.y = stage.stageHeight - component.height;
					break;
				case 'T' :
					component.x = stage.stageWidth*.5-component.width*.5;
					component.y = 0;
					break;
				case 'L' :
					component.x = 0;
					component.y = stage.stageHeight*.5-component.height*.5;
					break;
				case 'R' :
					component.x = stage.stageWidth - component.width;
					component.y = stage.stageHeight*.5-component.height*.5;
					break;
				case 'B' :
					component.x = stage.stageWidth*.5-component.width*.5;
					component.y = stage.stageHeight - component.height;
					break;
				case 'CENTER' :
					component.x = stage.stageWidth*.5-component.width*.5;
					component.y = stage.stageHeight*.5-component.height*.5;
					break;
			}
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