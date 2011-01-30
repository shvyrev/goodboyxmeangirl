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
		protected var _prev:IStatic;
		protected var _next:IStatic;
		protected var _visible:Boolean;
		protected var _anchor:String;
		protected var _id:String;
		
		protected var layout:Layout;
		protected var align:String;
		protected var onTop:Boolean;
		protected var css:String;
		protected var loader:UILoader;
		
		public function Static( MID:String, id:String, layout:Layout, align:String, onTop:Boolean, visible:Boolean ) {
			super(MID, id);
			this.id = id;
			this.layout = layout;
			this.align = align;
			this.onTop = onTop;
			this.visible = visible;
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
			setupViews(layout.views);
			if (anchor) castAnchor(anchor);
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
		public function zoom():void {}
		public function dezoom():void {}
		public function adapt():void {}
		public function castAnchor(anchor:String):void {}
		
		/**
		 * 	UTILITIES
		 */		
		protected function setupViews(views:Array):void {
			for (var i:int = 0; i < views.length; i++) views[i].setup(facade,component,data);
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
		public function get id():String { return _id; }
		public function set id(value:String):void { _id = value; }

	}
}