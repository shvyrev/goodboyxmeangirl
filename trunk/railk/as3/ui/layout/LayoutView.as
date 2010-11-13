/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.utils.getDefinitionByName;
	import railk.as3.ui.view.UIView;
	import railk.as3.ui.div.*;
	import railk.as3.utils.hasDefinition;
	
	public class LayoutView
	{	
		public var div:IDiv;
		public var master:LayoutView;
		public var container:LayoutView;
		public var viewClass:Class;
		
		public var id:String;
		public var view:String;
		public var style:String;
		public var bgStyle:String;
		public var data:XML;
		public var visible:Boolean;
		
		protected var float:String;
		protected var align:String;
		protected var margins:DivMargin;
		protected var position:String;
		protected var x:Number
		protected var y:Number;
		protected var constraint:String;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutView( container:LayoutView, master:LayoutView, view:String, id:String, float:String, align:String, margins:DivMargin, position:String, x:Number, y:Number, style:String, bgStyle:String, data:XML, constraint:String, visible:Boolean ) {
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
			this.style = style;
			this.bgStyle = bgStyle;
			this.constraint = constraint;
			this.visible = visible;
		}
		
		public function setup():void {
			viewClass = hasDefinition(view)?(getDefinitionByName(view) as Class):UIView;
			div = new Div(id, float, align, margins, position, x, y, data, constraint);
		}
		
		public function populate(v:UIView):void { v.bgStyle = bgStyle; v.style = style; v.nameSpace = view.split('::')[0]; }
		
		public function dispose():void { div=null; }
	}
}