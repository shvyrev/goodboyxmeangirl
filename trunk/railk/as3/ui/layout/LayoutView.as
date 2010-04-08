/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.ui.div.*;
	
	public class LayoutView
	{	
		public var div:IDiv;
		public var master:LayoutView;
		public var container:LayoutView;
		public var viewClass:Class;
		
		public var id:String;
		public var view:String;
		public var data:XML;
		public var visible:Boolean;
		
		protected var float:String;
		protected var align:String;
		protected var margins:Object;
		protected var position:String;
		protected var x:Number
		protected var y:Number;
		protected var constraint:String;
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutView( container:LayoutView, master:LayoutView, view:String, id:String, float:String, align:String, margins:Object, position:String, x:Number, y:Number, data:XML, constraint:String, visible:Boolean ) {
			this.container = container;
			this.master = master;
			this.view = view;
			this.data = data;
			this.id = id;
			this.float = float;
			this.align = align;
			this.margins = margins;
			this.position = position;
			this.x = x;
			this.y = y;
			this.constraint = constraint;
			this.visible = visible;
		}
		
		public function setup():void {
			viewClass = (view)?getDefinitionByName(view) as Class:View;
			div = new Div(id, float, align, margins, position, x, y, data, constraint);
			var X:Number = ((master)?master.div.x:0), Y:Number = ((master)?master.div.y:0);
			if (float == 'none') Y = Y+div.margins.top+((master)?master.div.height+master.div.margins.bottom:0);
			else if (float == 'left') X = X+div.margins.left + ((master)?master.div.width + master.div.margins.right:0);
			div.x += X;
			div.y += Y;
			if (master && position!='absolute') master.div.addArc(div);
		}
		
		public function init():void { div.state.init(); }
		public function activate():void { div.bind(); }
		
		public function dispose():void { div=null; }
	}
}