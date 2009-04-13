/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import railk.as3.display.DSprite;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.IController;
	import railk.as3.pattern.mvc.interfaces.IModel;
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.ui.layout.Layout;
	
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
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event)
			{ 
				for (var i:int = 0; i < layout.blocs.length; ++i) (component as DSprite).addChild( layout.blocs[i].setupView(model, controller) );
			}
			, false, 0, true );
			loader.load( new URLRequest(src) );
		}
		
		override public function hide():void {
			for (var i:int = 0; i < layout.blocs.length; ++i) (component as DSprite).removeChild(layout.blocs[i].view.component );
		}
		
		override public function dispose():void {
			layout.dispose();
			layout = null;
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
		
		public function get numChildren():int { return length; }
		
		public function get numSiblings():int {
			if (parent) return parent.length;
			return 0;
		}
	}
}