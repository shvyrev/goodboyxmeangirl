/**
 * background
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import railk.as3.display.DSprite;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.UILoader;
	import railk.as3.TopLevel;
	
	public class Background extends AbstractView implements IView,INotifier
	{
		public var id:String;
		public var layout:Layout;
		public var src:String;
		public var loader:UILoader;
		public var data:*;
		
		public function Background(id:String, layout:Layout, src:String ) {
			super();
			this.id = id;
			this.layout = layout;
			this.src = src;
			this.component = new DSprite();
		}
		
		/**
		 * 	VISBILITY
		 */
		override public function show():void {
			loader = new UILoader(src, function():void {
				setupViews(layout.views);
				TopLevel.main.addChild(component);
				activateViews(layout.views);
			} );
		}
		
		override public function hide():void {
			loader.stop();
			for (var i:int = 0; i < component.numChildren; i++) component.removeChildAt(i);
			TopLevel.main.removeChild(component);
			component = new DSprite();
		}
		
		/**
		 * 	UTILITIES
		 */		
		protected function setupViews(views:Array):void { 
			for (var i:int = 0; i < views.length; i++) {
				views[i].setup(data);
				if (!views[i].container) component.addChild( views[i].div );
				else views[i].container.div.addChild( views[i].div  );
			}
		}
		
		protected function activateViews(views:Array):void { for (var i:int = 0; i < views.length; i++) views[i].activate(); }
	}
}