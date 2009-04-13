/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.interfaces.*;
	
	public class LayoutBloc extends EventDispatcher
	{	
		public var arcs:Array=[];
		public var marked:Boolean;
		public var numArcs:int=0;
		
		private var _view:IView;
		public var viewClass:String;
		public var name:String;
		public var x:Number;
		public var y:Number;
		public var height:Number;
		public var width:Number;
		public var dynamicHeight:Boolean;
		public var dynamicWidth:Boolean;
		public var align:String;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutBloc( viewClass:String, name:String, x:Number, y:Number, width:String, height:String, align:String ) {
			this.viewClass = viewClass;
			this.name = name;
			this.x = x;
			this.y = y; 
			this.width = Number(width.match(/[0-9]{0,}/)[0]);
			this.height = Number(height.match(/[0-9]{0,}/)[0]);
			this.dynamicHeight = (height.search(/\%/)!=-1)?true:false;
			this.dynamicWidth = (width.search(/\%/)!=-1)?true:false;
			this.align = align;
		}
		
		public function setupView(model:IModel, controller:IController):Object {
			if(!_view) _view = new (getDefinitionByName(viewClass) as Class)(model, controller);
			return _view.component;
		}
		
		public function get view():IView { return _view; };
		
		/**
		 * ACTION
		 */
		public function update():Boolean {
			return _view.component.update();
		}
		
		public function change():void {
			dispatchEvent( new Event(Event.CHANGE) );
		}
		
		public function dispose():void {
			viewClass=null;
			arcs=null;
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