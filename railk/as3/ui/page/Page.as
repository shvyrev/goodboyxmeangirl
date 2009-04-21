/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.getDefinitionByName;
	import railk.as3.display.DSprite;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.IController;
	import railk.as3.pattern.mvc.interfaces.IModel;
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.UILoader;
	
	public class Page extends AbstractView implements IView
	{
		public var next:Page;
		public var prev:Page;
		
		public var title:String;
		public var parent:Page;
		public var layout:Layout;
		public var src:String;
		
		public var firstChild:Page;
		public var lastChild:Page;
		public var length:Number=0;
		
		private var loader:UILoader;
		
		public function Page( model:IModel, controller:IController, parent:Page, title:String, layout:Layout, src:String) {
			super(model, controller);
			this.parent = parent;
			this.title = title;
			this.layout = layout;
			this.src = src;
			this.component = new DSprite();
		}
		
		public function addChild( child:Page ):void {
			if (!firstChild) firstChild = lastChild = child;
			else {
				lastChild.next = child;
				child.prev = lastChild;
				lastChild = child;
			}
			length++;
		}
		
		override public function show():void {
			loader = new UILoader( src,function(){ 
				setupBlocs(layout.blocs,component);
				bindBlocs(layout.blocs);
			});
		}
		
		override public function hide():void {
			for (var i:int = 0; i < layout.blocs.length; ++i) (component as DSprite).removeChild(layout.blocs[i].view.component );
		}
		
		override public function dispose():void {
			layout.dispose();
			layout = null;
		}
		
		/**
		 * 	UTILITIES
		 */
		private function setupBlocs(blocs:Array, container:*=null):void {
			for (var i:int = 0; i < blocs.length; ++i) {
				var child:* = blocs[i][0].setupView(model, controller);
				if(blocs[i][1] ) setupBlocs(blocs[i][1],child);
				container.addChild( child );
			}
		}
		
		private function bindBlocs(blocs:Array):void {
			for (var i:int = 0; i < blocs.length; ++i) {
				blocs[i][0].bind();
				if(blocs[i][1] ) bindBlocs(blocs[i][1]);
			}
		}
		 
		/**
		 * 	GETTER/SETTER
		 */
		public function get isRoot():Boolean { return !Boolean(parent); }
		
		public function get isLeaf():Boolean { return length == 0; }
		
		public function get hasChildren():Boolean { return length > 0; }
		
		public function get depth():int {
			if (!parent) return 0;
			var child:Page = this, c:int = 0;
			while (child.parent) {
				c++;
				child = child.parent;
			}
			return c;
		}
	}
}