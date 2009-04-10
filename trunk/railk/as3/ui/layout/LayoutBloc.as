/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	public class LayoutBloc extends EventDispatcher
	{	
		public var arcs:Array=[];
		public var marked:Boolean;
		public var numArcs:int=0;
		
		public var target:*;
		public var moveAction:Function;
		public var moveActionParams:Array=[];
		
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
		public function LayoutBloc( name:String, x:Number, y:Number, width:String, height:String, align:String ) {
			this.name = name;
			this.x = x;
			this.y = y;
			this.width = Number(width.match(/[0-9]{0,}/)[0]);
			this.height = Number(height.match(/[0-9]{0,}/)[0]);
			this.dynamicHeight = (height.search(/\%/)!=-1)?true:false;
			this.dynamicWidth = (width.search(/\%/)!=-1)?true:false;
			this.align = align;
		}
		
		public function setup(target:*, moveAction:Function, moveActionParams:Array = null):void {
			this.target = target;
			this.moveAction = moveAction;
			this.moveActionParams = moveActionParams;
		}
		
		/**
		 * ACTION
		 */
		public function move():Boolean {
			return moveAction.apply(target, moveActionParams);
		}
		
		public function change():void {
			dispatchEvent( new Event(Event.CHANGE) );
		}
		
		public function dispose():void {
			target=null;
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