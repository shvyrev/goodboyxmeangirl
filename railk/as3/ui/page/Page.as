/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.*
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.UILoader;
	
	public class Page extends AbstractView implements IView,INotifier
	{
		public var next:Page;
		public var prev:Page;
		
		public var id:String;
		public var title:String;
		public var parent:Page;
		public var layout:Layout;
		public var loadingView:*;
		public var src:String;
		public var loaded:Boolean;
		public var reload:Boolean;
		
		public var firstChild:Page;
		public var lastChild:Page;
		public var length:Number=0;
		
		private var loader:UILoader;
		
		public function Page( MID:String, id:String, parent:Page, title:String, loadingView:*, layout:Layout, src:String) {
			super(MID,id);
			this.id = id;
			this.parent = parent;
			this.title = title;
			this.layout = layout;
			this.loadingView = loadingView;
			this.src = src;
			this.component = new Sprite();
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
			facade.addChild( loadingView );
			var progress:Function = function(p:Number):void { loadingView.percent = p; }
			var complete:Function = function():void { facade.removeChild( loadingView ); setupViews(layout.views, data); facade.addChild(component); activateViews(layout.views); loaded = true; }
			if (!loaded && !reload) loader = new UILoader( src, complete, ((loadingView)?progress:null) );
			else complete.apply();
		}
		
		override public function hide():void {
			loader.stop();
			var i:int=0, views:Array = layout.views;
			try { for (i = 0; i < views.length; ++i) views[i].div.unbind(); }
			catch (e:Error) { /*throw e;*/}
			for (i=0; i < component.numChildren; ++i) component.removeChildAt(i);
			try { facade.removeChild(component); }
			catch (e:ArgumentError){/*throw e;*/}
			component = new Sprite();
		}
		
		override public function dispose():void {
			layout = null;
		}
		
		/**
		 * 	UTILITIES
		 */
		private function setupViews(views:Array,data:*=null):void { 
			for (var i:int = 0; i < views.length; i++) {
				views[i].setup(data)
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
		
		public function toString():String { return '[ PAGE > '+id+ ' ]'; }
	}
}