/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import railk.as3.display.DSprite;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.*
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.UILoader;
	
	public class Page extends AbstractView implements IView
	{
		public var next:Page;
		public var prev:Page;
		
		public var id:String;
		public var title:String;
		public var parent:Page;
		public var layout:Layout;
		public var src:String;
		public var data:*;
		
		public var firstChild:Page;
		public var lastChild:Page;
		public var length:Number=0;
		
		private var loader:UILoader;
		
		public function Page( id:String, model:IModel, controller:IController, parent:Page, title:String, layout:Layout, src:String) {
			super(model, controller);
			this.id = id;
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
			loader = new UILoader( src, function():void { setupViews(layout.views,data); activateViews(layout.views); } );
		}
		
		override public function hide():void {
			var c:DSprite = (component as DSprite);
			for (var i:int = 0; i < c.numChildren; i++) c.removeChildAt(i); 
		}
		
		override public function dispose():void {
			layout = null;
		}
		
		/**
		 * 	UTILITIES
		 */
		private function setupViews(views:Array,data:*=null):void { 
			for (var i:int = 0; i < views.length; i++) {
				views[i].setup(model, controller, data)
				if (!views[i].container) component.addChild( views[i].div );
				else views[i].container.div.addChild( views[i].div  );
			}
		}
		private function activateViews(views:Array):void { for (var i:int = 0; i < views.length; i++) views[i].activate(); }
		
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