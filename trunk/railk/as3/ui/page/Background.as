/**
 * background
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import flash.display.Sprite;
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.UILoader;
	
	public class Background extends AbstractView implements IView,INotifier
	{
		public var id:String;
		public var layout:Layout;
		public var src:String;
		public var loader:UILoader;
		
		public function Background(id:String, layout:Layout, src:String ) {
			super(id);
			this.id = id;
			this.layout = layout;
			this.src = src;
			this.component = new Sprite();
		}
		
		/**
		 * 	VISBILITY
		 */
		override public function show():void {
			loader = new UILoader(src, function():void {
				setupViews(layout.views);
				facade.addChild(component);
				activateViews(layout.views);
			} );
		}
		
		override public function hide():void {
			loader.stop();
			for (var i:int = 0; i < component.numChildren; i++) component.removeChildAt(i);
			facade.removeChild(component);
			component = new Sprite();
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