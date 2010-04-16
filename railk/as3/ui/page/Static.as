/**
 * Static
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.loader.*;
	
	public class Static extends View implements IStatic,IView,INotifier
	{
		private var _prev:IStatic;
		private var _next:IStatic;
		private var _visible:Boolean;
		private var _anchor:String;
		
		protected var id:String;
		protected var layout:Layout;
		protected var align:String;
		protected var onTop:Boolean;
		protected var src:String;
		protected var css:String;
		protected var loader:UILoader;
		
		public function Static( MID:String, id:String, layout:Layout, align:String, onTop:Boolean, visible:Boolean, src:String ) {
			super(MID, id);
			this.id = id;
			this.layout = layout;
			this.align = align;
			this.onTop = onTop;
			this.visible = visible;
			this.src = src;
			this.component = new Div(id,'none',align);
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
				case 'adapt': adapt(); break;
				default : break;
			}
		}
		
		/**
		 * 	SHOW/HIDE/UPDATE
		 */
		override public function show():void {
			(facade.container as PageStruct).addStatic(component,onTop);
			loader = loadUI(src).complete(function():void {
				setupViews(layout.views);
				if (anchor) castAnchor(anchor);
			} ).start();
		}
		
		override public function hide():void {
			loader.stop();
			for (var i:int = 0; i < component.numChildren; i++) component.removeChildAt(i);
			(facade.container as PageStruct).delStatic(component);
			component = new Div(id,'none',align);
		}
		
		public function update():void {}
		
		/**
		 * ZOOM/DEZOOM
		 */
		protected function zoom():void {}
		protected function dezoom():void {}
		protected function adapt():void {}
		protected function castAnchor(anchor:String):void {}
		
		/**
		 * 	UTILITIES
		 */		
		protected function setupViews(views:Array):void {
			for (var i:int = 0; i < views.length; i++) {
				views[i].setup();
				if (!views[i].container) component.addDiv( views[i].div );
				else views[i].container.div.addDiv( views[i].div  );
				facade.registerView(views[i].viewClass,views[i].id,views[i].div,views[i].data);
				if(views[i].visible) facade.getView(views[i].id).show();
			}
		}
		
		/**
		 * 	GETTER/SETTERS
		 */	
		public function get prev():IStatic { return _prev; }
		public function set prev(value:IStatic):void { _prev = value; }
		public function get next():IStatic { return _next; }
		public function set next(value:IStatic):void { _next = value; }
		public function get anchor():String { return _anchor; }
		public function set anchor(value:String):void { _anchor = value; }
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; }
	}
}