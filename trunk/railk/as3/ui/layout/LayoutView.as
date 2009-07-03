/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.ui.div.*;
	
	public class LayoutView
	{	
		public var view:IView;
		public var div:IDiv;
		public var master:LayoutView;
		public var container:LayoutView;
		
		public var viewClass:String;
		public var divClass:String;
		public var id:String;
		public var float:String;
		public var align:String;
		public var margins:Object;
		public var position:String;
		public var x:Number
		public var y:Number;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutView( container:LayoutView, master:LayoutView, viewClass:String, divClass:String, id:String, float:String, align:String, margins:Object, position:String, x:Number, y:Number ) {
			this.container = container;
			this.master = master
			this.viewClass = viewClass;
			this.divClass = divClass;
			this.id = id;
			this.float = float;
			this.align = align;
			this.margins = margins;
			this.position = position;
			this.x = x;
			this.y = y;
		}
		
		public function setup(data:*=null):void {
			div = (divClass)?new (getDefinitionByName(divClass) as Class)(id, float, align, margins, position, x, y, data):new (getDefinitionByName('railk.as3.ui.div::Div') as Class)(id, float, align, margins, position, x, y, data);
			view = (viewClass)?new (getDefinitionByName(viewClass) as Class)(id,div):new AbstractView(id,div);
		}
		
		public function activate():void {
			var X:Number = ((master)?master.div.x:0), Y:Number = ((master)?master.div.y:0);
			if (float == 'none') Y = Y+div.margins.top+((master)?master.div.height+master.div.margins.bottom:0);
			else if (float == 'left') X = X+div.margins.left + ((master)?master.div.width + master.div.margins.right:0);
			div.x += X;
			div.y += Y;
			div.state.update();
			if (master && position!='absolute') master.div.addArc(div);
			div.bind();
		}
		
		public function dispose():void {
			view=null;
			div=null;
			master=null;
		}
	}
}