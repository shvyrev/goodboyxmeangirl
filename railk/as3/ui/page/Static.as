/**
 * Static
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.core.AbstractView;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.UILoader;
	
	public class Static extends AbstractView implements IStatic,IView,INotifier
	{
		private var _prev:IStatic;
		private var _next:IStatic;
		
		public var id:String;
		public var layout:Layout;
		public var onTop:Boolean;
		public var src:String;
		public var loader:UILoader;
		
		public function Static( MID:String, id:String, layout:Layout, onTop:Boolean, src:String ) {
			super(MID, id);
			this.id = id;
			this.layout = layout;
			this.onTop = onTop;
			this.src = src;
			this.component = new Div(id);
		}
		
		/**
		 * NOTIFICATION HANDLER
		 * 
		 * @param	evt
		 */
		override public function handleNotification(evt:Notification):void {
			switch(evt.note) {
				case 'zoom': zoom(); break;
				case 'dezoom': dezoom(); break;
				default : break;
			}
		}
		
		/**
		 * 	SHOW/HIDE
		 */
		override public function show():void {
			loader = new UILoader(src, function():void {
				setupViews(layout.views);
				(facade.container as PageStruct).addStatic(component,onTop);
				activateViews(layout.views);
			} );
		}
		
		override public function hide():void {
			loader.stop();
			for (var i:int = 0; i < component.numChildren; i++) component.removeChildAt(i);
			(facade.container as PageStruct).delStatic(component);
			component = new Div();
		}
		
		/**
		 * ZOOM/DEZOOM
		 */
		protected function zoom():void {}
		protected function dezoom():void {}
		
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
		
		/**
		 * 	GETTER/SETTERS
		 */	
		public function get prev():IStatic { return _prev; }
		public function set prev(value:IStatic):void { _prev = value; }
		public function get next():IStatic { return _next; }
		public function set next(value:IStatic):void { _next = value; }
	}
}