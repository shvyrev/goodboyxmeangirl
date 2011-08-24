/**
 * Layout View
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.ui.div.*;
	import railk.as3.ui.page.Plugins;
	import railk.as3.ui.view.UIView;
	
	public final class LayoutView implements ILayoutView
	{	
		public var div:IDiv;
		public var master:LayoutView;
		public var container:LayoutView;
		public var viewClass:Class;
		public var view:UIView;
		
		public var id:String;
		public var viewName:String;
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
		public function LayoutView( container:LayoutView, master:LayoutView, viewName:String, id:String, float:String, align:String, margins:DivMargin, position:String, x:Number, y:Number, style:String, bgStyle:String, data:XML, constraint:String, visible:Boolean ) {
			this.container = container;
			this.master = master;
			this.viewName = viewName;
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
		
		public function setup(group:String,facade:IFacade,component:*,data:*):void {
			div = new Div(id, float, align, margins, position, x, y, data, constraint);
			Plugins.getInstance().getClass(group,viewName,run,facade,component,data);
		}
		
		private function run(facade:IFacade, component:*, data:*, c:Class = null):void {
			viewClass = (c)?c:UIView;
			if (!container) component.addDiv( div );
			else container.div.addDiv( div  );
			data += (div.data != null)?div.data:'';
			view = populate(facade.registerView(viewClass, id, div, data) as UIView);
			if (visible) facade.getView(id).show();
		}
		
		public function populate(v:UIView):UIView { v.bgStyle = bgStyle; v.style = style; v.nameSpace = viewName.split('::')[0]; return v; }
		
		public function dispose():void { div=null; }
	}
}